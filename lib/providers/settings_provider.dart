import 'package:flutter/material.dart';
import '../services/app_database.dart';
import '../services/sound_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsBox _settings = SettingsBox();

  bool get soundEnabled => _settings.soundEnabled;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get geolocationEnabled => _settings.geolocationEnabled;
  bool get isDarkMode => _settings.isDarkMode;

  Future<void> init() async {
    _settings = await AppDatabase.getSettings();
    SoundService.setEnabled(_settings.soundEnabled);
    notifyListeners();
  }

  Future<void> toggleSound(bool value) async {
    _settings.soundEnabled = value;
    SoundService.setEnabled(value);
    await AppDatabase.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _settings.notificationsEnabled = value;
    await AppDatabase.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleGeolocation(bool value) async {
    _settings.geolocationEnabled = value;
    await AppDatabase.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _settings.isDarkMode = isDark;
    await AppDatabase.updateSettings(_settings);
    notifyListeners();
  }
}
