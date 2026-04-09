import 'package:flutter/material.dart';
import '../services/app_database.dart';

/// Local auth — no backend. Credentials stored in Hive.
class AuthProvider extends ChangeNotifier {
  UserBox? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserBox? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await AppDatabase.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  /// Login with email + password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final allUsers = await AppDatabase.getAllUsers();
    final match = allUsers.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => UserBox(
        id: '', name: '', email: '', password: '', createdAt: DateTime.now(),
      ),
    );

    if (match.id.isNotEmpty) {
      _currentUser = match;
      await AppDatabase.setCurrentUserId(match.id);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = 'Неверный email или пароль';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Register — create new local user
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final allUsers = await AppDatabase.getAllUsers();
    if (allUsers.any((u) => u.email == email)) {
      _errorMessage = 'Этот email уже зарегистрирован';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = UserBox(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );
    await AppDatabase.saveUser(newUser);
    await AppDatabase.setCurrentUserId(newUser.id);
    _currentUser = newUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await AppDatabase.setCurrentUserId(null);
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(String name) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: name);
    await AppDatabase.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> changePassword(String newPassword) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(password: newPassword);
    await AppDatabase.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> addXP(int amount) async {
    if (_currentUser == null) return;
    final newXP = _currentUser!.xp + amount;
    final newLevel = (newXP ~/ 100) + 1;
    _currentUser = _currentUser!.copyWith(xp: newXP, level: newLevel);
    await AppDatabase.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> markWordLearned(String topicId) async {
    if (_currentUser == null) return;
    final wl = Map<String, int>.from(_currentUser!.wordsLearned);
    wl[topicId] = (wl[topicId] ?? 0) + 1;
    _currentUser = _currentUser!.copyWith(wordsLearned: wl);
    await AppDatabase.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> updateGameStats(String gameType, int score, int total) async {
    if (_currentUser == null) return;
    final played = Map<String, int>.from(_currentUser!.gameStatsPlayed);
    final correct = Map<String, int>.from(_currentUser!.gameStatsCorrect);
    final best = Map<String, int>.from(_currentUser!.gameStatsBestScore);
    played[gameType] = (played[gameType] ?? 0) + 1;
    correct[gameType] = (correct[gameType] ?? 0) + score;
    if (score > (best[gameType] ?? 0)) best[gameType] = score;
    _currentUser = _currentUser!.copyWith(
      gameStatsPlayed: played,
      gameStatsCorrect: correct,
      gameStatsBestScore: best,
    );
    await AppDatabase.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> incrementStreak() async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(streak: _currentUser!.streak + 1);
    await AppDatabase.saveUser(_currentUser!);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
