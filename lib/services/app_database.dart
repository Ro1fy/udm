import 'package:hive_flutter/hive_flutter.dart';

part 'app_database.g.dart';

@HiveType(typeId: 0)
class WordBox {
  @HiveField(0)
  String id;

  @HiveField(1)
  String udmurt;

  @HiveField(2)
  String russian;

  @HiveField(3)
  String transcription;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  String topicId;

  WordBox({
    required this.id,
    required this.udmurt,
    required this.russian,
    required this.transcription,
    this.imagePath,
    required this.topicId,
  });
}

@HiveType(typeId: 1)
class TopicBox {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String titleUdmurt;

  @HiveField(3)
  String icon;

  @HiveField(4)
  String description;

  @HiveField(5)
  List<String> wordIds;

  TopicBox({
    required this.id,
    required this.title,
    required this.titleUdmurt,
    required this.icon,
    required this.description,
    required this.wordIds,
  });
}

@HiveType(typeId: 2)
class UserBox {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(11)
  String password;

  @HiveField(4)
  int xp;

  @HiveField(5)
  int level;

  @HiveField(6)
  int streak;

  @HiveField(7)
  Map<String, int> wordsLearned;

  @HiveField(8)
  Map<String, int> gameStatsPlayed;

  @HiveField(9)
  Map<String, int> gameStatsCorrect;

  @HiveField(10)
  Map<String, int> gameStatsBestScore;

  UserBox({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    Map<String, int>? wordsLearned,
    Map<String, int>? gameStatsPlayed,
    Map<String, int>? gameStatsCorrect,
    Map<String, int>? gameStatsBestScore,
  })  : wordsLearned = wordsLearned ?? {},
        gameStatsPlayed = gameStatsPlayed ?? {},
        gameStatsCorrect = gameStatsCorrect ?? {},
        gameStatsBestScore = gameStatsBestScore ?? {};

  UserBox copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    DateTime? createdAt,
    int? xp,
    int? level,
    int? streak,
    Map<String, int>? wordsLearned,
    Map<String, int>? gameStatsPlayed,
    Map<String, int>? gameStatsCorrect,
    Map<String, int>? gameStatsBestScore,
  }) {
    return UserBox(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      gameStatsPlayed: gameStatsPlayed ?? this.gameStatsPlayed,
      gameStatsCorrect: gameStatsCorrect ?? this.gameStatsCorrect,
      gameStatsBestScore: gameStatsBestScore ?? this.gameStatsBestScore,
    );
  }
}

@HiveType(typeId: 3)
class SettingsBox {
  @HiveField(0)
  bool soundEnabled;

  @HiveField(1)
  bool notificationsEnabled;

  @HiveField(2)
  bool geolocationEnabled;

  @HiveField(3)
  String lastLocationWordId;

  @HiveField(4)
  String currentUserId;

  SettingsBox({
    this.soundEnabled = true,
    this.notificationsEnabled = false,
    this.geolocationEnabled = false,
    this.lastLocationWordId = '',
    this.currentUserId = '',
  });
}

class AppDatabase {
  static const String _wordsBoxName = 'words';
  static const String _topicsBoxName = 'topics';
  static const String _userBoxName = 'user';
  static const String _settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WordBoxAdapter());
    Hive.registerAdapter(TopicBoxAdapter());
    Hive.registerAdapter(UserBoxAdapter());
    Hive.registerAdapter(SettingsBoxAdapter());
  }

  // Words
  static Future<Box<WordBox>> get wordsBox async =>
      Hive.openBox<WordBox>(_wordsBoxName);

  static Future<void> saveWords(List<WordBox> words) async {
    final box = await wordsBox;
    for (final word in words) {
      await box.put(word.id, word);
    }
  }

  static Future<List<WordBox>> getAllWords() async {
    final box = await wordsBox;
    return box.values.toList();
  }

  static Future<List<WordBox>> getWordsByTopic(String topicId) async {
    final box = await wordsBox;
    return box.values.where((w) => w.topicId == topicId).toList();
  }

  // Topics
  static Future<Box<TopicBox>> get topicsBox async =>
      Hive.openBox<TopicBox>(_topicsBoxName);

  static Future<void> saveTopics(List<TopicBox> topics) async {
    final box = await topicsBox;
    for (final topic in topics) {
      await box.put(topic.id, topic);
    }
  }

  static Future<List<TopicBox>> getAllTopics() async {
    final box = await topicsBox;
    return box.values.toList();
  }

  // User
  static Future<Box<UserBox>> get userBox async =>
      Hive.openBox<UserBox>(_userBoxName);

  static Future<void> saveUser(UserBox user) async {
    final box = await userBox;
    await box.put(user.id, user);
  }

  static Future<UserBox?> getCurrentUser() async {
    final settings = await getSettings();
    final currentId = settings.currentUserId;
    if (currentId.isEmpty) return null;
    final box = await userBox;
    return box.get(currentId);
  }

  static Future<List<UserBox>> getAllUsers() async {
    final box = await userBox;
    return box.values.toList();
  }

  static Future<void> setCurrentUserId(String? userId) async {
    final settings = await getSettings();
    settings.currentUserId = userId ?? '';
    await updateSettings(settings);
  }

  static Future<void> deleteUser() async {
    final user = await getCurrentUser();
    if (user != null) {
      final box = await userBox;
      await box.delete(user.id);
    }
    await setCurrentUserId(null);
  }

  // Settings
  static Future<Box<SettingsBox>> get settingsBox async =>
      Hive.openBox<SettingsBox>(_settingsBoxName);

  static Future<SettingsBox> getSettings() async {
    final box = await settingsBox;
    if (box.isEmpty) {
      final settings = SettingsBox();
      await box.put('settings', settings);
      return settings;
    }
    return box.values.first;
  }

  static Future<void> updateSettings(SettingsBox settings) async {
    final box = await settingsBox;
    await box.put('settings', settings);
  }

  // Clear all data
  static Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(_wordsBoxName);
    await Hive.deleteBoxFromDisk(_topicsBoxName);
    await Hive.deleteBoxFromDisk(_userBoxName);
    await Hive.deleteBoxFromDisk(_settingsBoxName);
  }
}
