import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../data/vocabulary.dart';
import 'dart:math';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notifications.initialize(initSettings);
    _isInitialized = true;
  }

  static Future<void> sendLocationNotification({
    required double latitude,
    required double longitude,
  }) async {
    if (!_isInitialized) return;

    // Pick a random word to show as "nearby"
    final allWords = VocabularyData.words;
    final random = Random();
    final word = allWords[random.nextInt(allWords.length)];
    final emoji = _getEmojiForWord(word);

    const androidDetails = AndroidNotificationDetails(
      'udmurt_kyl_location',
      'Удмурт кыл - Геолокация',
      channelDescription: 'Уведомления об интересных словах рядом с вами',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifications.show(
      0,
      '$emoji Интересное слово рядом!',
      '"${word.udmurt}" ${word.transcription} — ${word.russian}',
      details,
    );
  }

  static Future<void> sendDailyReminder() async {
    if (!_isInitialized) return;

    const androidDetails = AndroidNotificationDetails(
      'udmurt_kyl_daily',
      'Удмурт кыл - Напоминания',
      channelDescription: 'Ежедневные напоминания для изучения языка',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifications.show(
      1,
      '📚 Время учить удмуртский!',
      'Откройте приложение и выучите новые слова сегодня',
      details,
    );
  }

  static Future<void> scheduleDailyReminder() async {
    if (!_isInitialized) return;

    // Schedule at 10:00 AM
    await _notifications.zonedSchedule(
      2,
      '📚 Удмурт кыл',
      'Пора учить новые слова!',
      _nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'udmurt_kyl_reminder',
          'Напоминания',
          channelDescription: 'Ежедневные напоминания',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTenAM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  static String _getEmojiForWord(dynamic word) {
    switch (word.topicId) {
      case 'greetings':
        return '👋';
      case 'numbers':
        return '🔢';
      case 'wild_animals':
        return '🐻';
      case 'domestic_animals':
        return '🐄';
      case 'family':
        return '👨‍👩‍👧‍👦';
      default:
        return '📚';
    }
  }
}
