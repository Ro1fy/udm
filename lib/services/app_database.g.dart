// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordBoxAdapter extends TypeAdapter<WordBox> {
  @override
  final int typeId = 0;

  @override
  WordBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordBox(
      id: fields[0] as String,
      udmurt: fields[1] as String,
      russian: fields[2] as String,
      transcription: fields[3] as String,
      imagePath: fields[4] as String?,
      topicId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordBox obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.udmurt)
      ..writeByte(2)
      ..write(obj.russian)
      ..writeByte(3)
      ..write(obj.transcription)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.topicId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopicBoxAdapter extends TypeAdapter<TopicBox> {
  @override
  final int typeId = 1;

  @override
  TopicBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopicBox(
      id: fields[0] as String,
      title: fields[1] as String,
      titleUdmurt: fields[2] as String,
      icon: fields[3] as String,
      description: fields[4] as String,
      wordIds: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TopicBox obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.titleUdmurt)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.wordIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserBoxAdapter extends TypeAdapter<UserBox> {
  @override
  final int typeId = 2;

  @override
  UserBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBox(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      password: fields[11] as String,
      createdAt: fields[3] as DateTime,
      xp: fields[4] as int,
      level: fields[5] as int,
      streak: fields[6] as int,
      wordsLearned: (fields[7] as Map?)?.cast<String, int>(),
      gameStatsPlayed: (fields[8] as Map?)?.cast<String, int>(),
      gameStatsCorrect: (fields[9] as Map?)?.cast<String, int>(),
      gameStatsBestScore: (fields[10] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserBox obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.xp)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.streak)
      ..writeByte(7)
      ..write(obj.wordsLearned)
      ..writeByte(8)
      ..write(obj.gameStatsPlayed)
      ..writeByte(9)
      ..write(obj.gameStatsCorrect)
      ..writeByte(10)
      ..write(obj.gameStatsBestScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SettingsBoxAdapter extends TypeAdapter<SettingsBox> {
  @override
  final int typeId = 3;

  @override
  SettingsBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsBox(
      soundEnabled: fields[0] as bool,
      notificationsEnabled: fields[1] as bool,
      geolocationEnabled: fields[2] as bool,
      lastLocationWordId: fields[3] as String,
      currentUserId: fields[4] as String,
      isDarkMode: fields[5] as bool? ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsBox obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.soundEnabled)
      ..writeByte(1)
      ..write(obj.notificationsEnabled)
      ..writeByte(2)
      ..write(obj.geolocationEnabled)
      ..writeByte(3)
      ..write(obj.lastLocationWordId)
      ..writeByte(4)
      ..write(obj.currentUserId)
      ..writeByte(5)
      ..write(obj.isDarkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
