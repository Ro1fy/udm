/// User model for authentication and profile
class User {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final int xp;
  final int level;
  final int streak;
  final Map<String, int> wordsLearned; // topicId -> count
  final Map<String, GameStats> gameStats;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    Map<String, int>? wordsLearned,
    Map<String, GameStats>? gameStats,
  })  : wordsLearned = wordsLearned ?? const {},
        gameStats = gameStats ?? const {};

  User copyWith({
    String? name,
    String? email,
    int? xp,
    int? level,
    int? streak,
    Map<String, int>? wordsLearned,
    Map<String, GameStats>? gameStats,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      gameStats: gameStats ?? this.gameStats,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
        'xp': xp,
        'level': level,
        'streak': streak,
        'wordsLearned': wordsLearned,
        'gameStats': gameStats.map((k, v) => MapEntry(k, v.toJson())),
      };

  factory User.fromJson(Map<String, dynamic> json) {
    final gameStatsMap = <String, GameStats>{};
    if (json['gameStats'] != null) {
      (json['gameStats'] as Map<String, dynamic>).forEach((key, value) {
        gameStatsMap[key] = GameStats.fromJson(value as Map<String, dynamic>);
      });
    }
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      streak: json['streak'] as int? ?? 0,
      wordsLearned:
          Map<String, int>.from(json['wordsLearned'] as Map? ?? {}),
      gameStats: gameStatsMap,
    );
  }
}

/// Game statistics per game type
class GameStats {
  final int played;
  final int correct;
  final int bestScore;

  const GameStats({
    this.played = 0,
    this.correct = 0,
    this.bestScore = 0,
  });

  double get accuracy => played == 0 ? 0.0 : correct / played;

  GameStats copyWith({
    int? played,
    int? correct,
    int? bestScore,
  }) {
    return GameStats(
      played: played ?? this.played,
      correct: correct ?? this.correct,
      bestScore: bestScore ?? this.bestScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'played': played,
        'correct': correct,
        'bestScore': bestScore,
      };

  factory GameStats.fromJson(Map<String, dynamic> json) => GameStats(
        played: json['played'] as int? ?? 0,
        correct: json['correct'] as int? ?? 0,
        bestScore: json['bestScore'] as int? ?? 0,
      );
}
