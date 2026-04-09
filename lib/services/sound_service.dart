import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

/// Generates simple WAV tones programmatically — no internet needed.
class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _enabled = true;

  static void setEnabled(bool value) => _enabled = value;
  static bool get isEnabled => _enabled;

  /// Play "correct" sound — ascending two-tone (C5 → E5)
  static Future<void> playCorrect() async {
    if (!_enabled) return;
    try {
      final path = await _generateTone([523.25, 659.25], 0.12);
      await _player.play(DeviceFileSource(path));
    } catch (_) {}
  }

  /// Play "incorrect" sound — low buzzer (150 Hz)
  static Future<void> playIncorrect() async {
    if (!_enabled) return;
    try {
      final path = await _generateTone([150], 0.35);
      await _player.play(DeviceFileSource(path));
    } catch (_) {}
  }

  /// Generate a WAV file with one or more sine wave tones.
  /// Frequencies in Hz, each tone plays for [durationPerTone] seconds.
  static Future<String> _generateTone(
    List<double> frequencies,
    double durationPerTone,
  ) async {
    const sampleRate = 44100;
    const bitsPerSample = 16;
    final totalSamples = (sampleRate * durationPerTone * frequencies.length).round();
    final data = <int>[];

    for (int i = 0; i < totalSamples; i++) {
      final toneIndex = i ~/ (sampleRate * durationPerTone).round();
      final freqIndex = i % (sampleRate * durationPerTone).round();
      final freq = frequencies[toneIndex.clamp(0, frequencies.length - 1)];
      final value = sin(2 * pi * freq * freqIndex / sampleRate);
      final scaled = (value * 32767).round().clamp(-32768, 32767);
      data.add(scaled & 0xFF);
      data.add((scaled >> 8) & 0xFF);
    }

    // Build WAV file bytes
    final byteRate = sampleRate * 2;
    final blockAlign = 2;
    final dataSize = data.length;
    final fileSize = 36 + dataSize;

    final bytes = BytesBuilder();
    _writeString(bytes, 'RIFF');
    _writeInt32(bytes, fileSize);
    _writeString(bytes, 'WAVE');
    _writeString(bytes, 'fmt ');
    _writeInt32(bytes, 16); // chunk size
    _writeInt16(bytes, 1); // PCM
    _writeInt16(bytes, 1); // mono
    _writeInt32(bytes, sampleRate);
    _writeInt32(bytes, byteRate);
    _writeInt16(bytes, blockAlign);
    _writeInt16(bytes, bitsPerSample);
    _writeString(bytes, 'data');
    _writeInt32(bytes, dataSize);
    bytes.add(data);

    // Save to temp file
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/sound_${DateTime.now().millisecondsSinceEpoch}.wav');
    await file.writeAsBytes(bytes.toBytes());
    return file.path;
  }

  static void _writeString(BytesBuilder b, String s) {
    b.add(s.codeUnits);
  }

  static void _writeInt16(BytesBuilder b, int v) {
    b.addByte(v & 0xFF);
    b.addByte((v >> 8) & 0xFF);
  }

  static void _writeInt32(BytesBuilder b, int v) {
    b.addByte(v & 0xFF);
    b.addByte((v >> 8) & 0xFF);
    b.addByte((v >> 16) & 0xFF);
    b.addByte((v >> 24) & 0xFF);
  }

  static Future<void> dispose() async {
    await _player.dispose();
  }
}
