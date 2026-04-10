import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

/// Service for playing game sounds (correct/incorrect feedback).
class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _enabled = true;

  static void setEnabled(bool value) => _enabled = value;
  static bool get isEnabled => _enabled;

  /// Play "correct" sound — correct.mp3
  static Future<void> playCorrect() async {
    if (!_enabled) return;
    try {
      await _player.play(AssetSource('audio/correct.mp3'));
    } catch (_) {}
  }

  /// Play "incorrect" sound — error.mp3
  static Future<void> playIncorrect() async {
    if (!_enabled) return;
    try {
      await _player.play(AssetSource('audio/error.mp3'));
    } catch (_) {}
  }

  static Future<void> dispose() async {
    await _player.dispose();
  }
}
