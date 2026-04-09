import 'package:flutter/material.dart';
import '../services/app_database.dart';

/// Local profile provider — no registration, no backend.
/// Profile is created automatically on first launch and stored locally.
class ProfileProvider extends ChangeNotifier {
  UserBox? _profile;
  bool _isLoaded = false;

  UserBox? get profile => _profile;
  bool get isLoaded => _isLoaded;

  Future<void> init() async {
    var existing = await AppDatabase.getCurrentUser();
    if (existing == null) {
      // Create local profile automatically
      existing = UserBox(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Ученик',
        email: '',
        password: '',
        createdAt: DateTime.now(),
      );
      await AppDatabase.saveUser(existing);
    }
    _profile = existing;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(name: name);
    await AppDatabase.saveUser(_profile!);
    notifyListeners();
  }

  Future<void> addXP(int amount) async {
    if (_profile == null) return;
    final newXP = _profile!.xp + amount;
    final newLevel = (newXP ~/ 100) + 1;
    _profile = _profile!.copyWith(xp: newXP, level: newLevel);
    await AppDatabase.saveUser(_profile!);
    notifyListeners();
  }

  Future<void> markWordLearned(String topicId) async {
    if (_profile == null) return;
    final wordsLearned = Map<String, int>.from(_profile!.wordsLearned);
    wordsLearned[topicId] = (wordsLearned[topicId] ?? 0) + 1;
    _profile = _profile!.copyWith(wordsLearned: wordsLearned);
    await AppDatabase.saveUser(_profile!);
    notifyListeners();
  }

  Future<void> updateGameStats(String gameType, int score, int total) async {
    if (_profile == null) return;
    final played = Map<String, int>.from(_profile!.gameStatsPlayed);
    final correct = Map<String, int>.from(_profile!.gameStatsCorrect);
    final best = Map<String, int>.from(_profile!.gameStatsBestScore);
    played[gameType] = (played[gameType] ?? 0) + 1;
    correct[gameType] = (correct[gameType] ?? 0) + score;
    if (score > (best[gameType] ?? 0)) {
      best[gameType] = score;
    }
    _profile = _profile!.copyWith(
      gameStatsPlayed: played,
      gameStatsCorrect: correct,
      gameStatsBestScore: best,
    );
    await AppDatabase.saveUser(_profile!);
    notifyListeners();
  }

  Future<void> incrementStreak() async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(streak: _profile!.streak + 1);
    await AppDatabase.saveUser(_profile!);
    notifyListeners();
  }

  /// Reset all progress
  Future<void> resetProgress() async {
    if (_profile == null) return;
    _profile = UserBox(
      id: _profile!.id,
      name: _profile!.name,
      email: '',
      password: _profile!.password,
      createdAt: _profile!.createdAt,
    );
    await AppDatabase.saveUser(_profile!);
    notifyListeners();
  }

  int get totalWordsLearned {
    if (_profile == null) return 0;
    return _profile!.wordsLearned.values.fold(0, (a, b) => a + b);
  }
}
