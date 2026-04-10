import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/landmark.dart';
import '../data/landmarks.dart';
import 'notification_service.dart';

class GeolocationService {
  static bool _isMonitoring = false;
  static StreamSubscription<Position>? _positionStream;
  static final Set<String> _notifiedLandmarks = {};
  static final Map<String, DateTime> _lastNotificationTime = {};
  static const String _prefsKey = 'notified_landmarks';

  static const double notificationRadius = 500;
  static const Duration cooldownDuration = Duration(hours: 2);

  static bool get isMonitoring => _isMonitoring;

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermission();
      if (hasPermission == LocationPermission.denied ||
          hasPermission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> startMonitoring({
    required VoidCallback? onLocationError,
  }) async {
    if (_isMonitoring) return;

    final isEnabled = await isLocationServiceEnabled();
    if (!isEnabled) {
      onLocationError?.call();
      return;
    }

    final permission = await checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      onLocationError?.call();
      return;
    }

    _isMonitoring = true;
    await _loadNotifiedLandmarks();

    final locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _checkNearbyLandmarks(position.latitude, position.longitude);
      },
      onError: (e) {
        _isMonitoring = false;
        onLocationError?.call();
      },
    );
  }

  static Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;

    await _positionStream?.cancel();
    _positionStream = null;
    _isMonitoring = false;
  }

  static Future<void> _checkNearbyLandmarks(
    double latitude,
    double longitude,
  ) async {
    final nearbyLandmarks = LandmarksData.getLandmarksNearby(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: notificationRadius,
    );

    for (final landmark in nearbyLandmarks) {
      if (_shouldNotify(landmark.id)) {
        await _sendLandmarkNotification(landmark);
        _notifiedLandmarks.add(landmark.id);
        _lastNotificationTime[landmark.id] = DateTime.now();
      }
    }
  }

  static bool _shouldNotify(String landmarkId) {
    if (_notifiedLandmarks.contains(landmarkId)) {
      final lastTime = _lastNotificationTime[landmarkId];
      if (lastTime != null) {
        final timeSinceLastNotification = DateTime.now().difference(lastTime);
        if (timeSinceLastNotification < cooldownDuration) {
          return false;
        }
      }
    }
    return true;
  }

  static Future<void> _sendLandmarkNotification(Landmark landmark) async {
    if (!NotificationService.isInitialized) return;

    final androidDetails = const AndroidNotificationDetails(
      'udmurt_kyl_landmarks',
      'Удмурт кыл - Достопримечательности',
      channelDescription: 'Уведомления о достопримечательностях рядом с вами',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final darwinDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await NotificationService.show(
      landmark.id.hashCode,
      '${landmark.emoji} ${landmark.name}',
      '${landmark.description}\n📍 ${landmark.location}',
      details,
    );

    await _saveNotifiedLandmarks();
  }

  static Future<void> _loadNotifiedLandmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_prefsKey);
      if (data != null) {
        _notifiedLandmarks.clear();
        _notifiedLandmarks.addAll(data.split(','));
      }
    } catch (e) {
      // Ignore errors
    }
  }

  static Future<void> _saveNotifiedLandmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, _notifiedLandmarks.join(','));
    } catch (e) {
      // Ignore errors
    }
  }

  static void clearNotificationHistory() {
    _notifiedLandmarks.clear();
    _lastNotificationTime.clear();
    _saveNotifiedLandmarks();
  }

  static Set<String> getNotifiedLandmarks() {
    return Set.from(_notifiedLandmarks);
  }
}
