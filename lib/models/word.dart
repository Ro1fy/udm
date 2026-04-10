/// Word model for vocabulary cards
class Word {
  final String id;
  final String udmurt;
  final String russian;
  final String transcription;
  final String? imagePath;
  final String? audioPath;
  final String topicId;

  const Word({
    required this.id,
    required this.udmurt,
    required this.russian,
    required this.transcription,
    this.imagePath,
    this.audioPath,
    required this.topicId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'udmurt': udmurt,
        'russian': russian,
        'transcription': transcription,
        'imagePath': imagePath,
        'audioPath': audioPath,
        'topicId': topicId,
      };

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        id: json['id'] as String,
        udmurt: json['udmurt'] as String,
        russian: json['russian'] as String,
        transcription: json['transcription'] as String,
        imagePath: json['imagePath'] as String?,
        audioPath: json['audioPath'] as String?,
        topicId: json['topicId'] as String,
      );
}

/// Topic model for grouping words
class Topic {
  final String id;
  final String title;
  final String titleUdmurt;
  final String icon;
  final String description;
  final List<String> wordIds;

  const Topic({
    required this.id,
    required this.title,
    required this.titleUdmurt,
    required this.icon,
    required this.description,
    required this.wordIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'titleUdmurt': titleUdmurt,
        'icon': icon,
        'description': description,
        'wordIds': wordIds,
      };

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'] as String,
        title: json['title'] as String,
        titleUdmurt: json['titleUdmurt'] as String,
        icon: json['icon'] as String,
        description: json['description'] as String,
        wordIds: List<String>.from(json['wordIds'] as List),
      );
}

/// Result of a single question in a game session
class QuestionResult {
  final Word word;
  final bool isCorrect;
  final String? userAnswer; // For word scramble
  final String? selectedOption; // For choose translation
  final bool? userSaysTrue; // For true/false
  final int points;

  const QuestionResult({
    required this.word,
    required this.isCorrect,
    this.userAnswer,
    this.selectedOption,
    this.userSaysTrue,
    this.points = 10,
  });
}
