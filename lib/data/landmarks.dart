import 'dart:math';
import '../models/landmark.dart';

class LandmarksData {
  static const List<Landmark> allLandmarks = [
    // 🏛️ Культурные и исторические достопримечательности
    Landmark(
      id: 'chaikovsky_museum',
      name: 'Музей-усадьба П.И. Чайковского',
      nameUdmurt: 'П.И. Чайковскийлэн музей-усадьбаез',
      description: 'Дом, где родился композитор, один из лучших музыкальных музеев.',
      latitude: 57.0494,
      longitude: 52.2109,
      category: 'museum',
      emoji: '🎵',
      location: 'Воткинск',
    ),
    Landmark(
      id: 'ludorvai',
      name: 'Музей-заповедник «Лудорвай»',
      nameUdmurt: '«Лудорвай» музей-заповедник',
      description: 'Архитектурно-этнографический комплекс под открытым небом.',
      latitude: 56.7038,
      longitude: 53.3122,
      category: 'museum',
      emoji: '🏛️',
      location: 'Ижевск',
    ),
    Landmark(
      id: 'kalashnikov_museum',
      name: 'Музей им. М.Т. Калашникова',
      nameUdmurt: 'М.Т. Калашниковлэн музейез',
      description: 'Музейно-выставочный комплекс, посвященный стрелковому оружию.',
      latitude: 56.8522,
      longitude: 53.2047,
      category: 'museum',
      emoji: '🔫',
      location: 'Ижевск',
    ),
    Landmark(
      id: 'michael_cathedral',
      name: 'Свято-Михайловский собор',
      nameUdmurt: 'Свято-Михайловский собор',
      description: 'Величественный собор, символ города.',
      latitude: 56.8527,
      longitude: 53.2114,
      category: 'church',
      emoji: '⛪',
      location: 'Ижевск',
    ),
    Landmark(
      id: 'bachenin_dacha',
      name: 'Дача Башенина',
      nameUdmurt: 'Башенинлэн дачаез',
      description: 'Живописный памятник архитектуры модерна.',
      latitude: 56.4733,
      longitude: 52.8106,
      category: 'architecture',
      emoji: '🏡',
      location: 'Сарапул',
    ),
    Landmark(
      id: 'siberian_track_museum',
      name: 'Музей истории Сибирского тракта',
      nameUdmurt: 'Сибирской траклэн историезлэн музейез',
      description: 'История главной каторжной дороги.',
      latitude: 57.2581,
      longitude: 52.8794,
      category: 'museum',
      emoji: '🛤️',
      location: 'с. Дебесы, с. Бачкеево',
    ),

    // 🌲 Природные достопримечательности
    Landmark(
      id: 'nechkinsky_park',
      name: 'Национальный парк «Нечкинский»',
      nameUdmurt: '«Нечкинский» национальный парк',
      description: 'Живописные пейзажи на берегу Камы.',
      latitude: 56.7289,
      longitude: 53.4378,
      category: 'nature',
      emoji: '🌲',
      location: 'Удмуртия',
    ),
    Landmark(
      id: 'baygurez_mountain',
      name: 'Гора Байгурезь',
      nameUdmurt: 'Байгурезь гора',
      description: 'Высокий холм с панорамным видом, считается священным местом.',
      latitude: 56.9500,
      longitude: 52.7500,
      category: 'nature',
      emoji: '⛰️',
      location: 'Удмуртия',
    ),
    Landmark(
      id: 'zuevy_keys',
      name: 'Зуевы Ключи',
      nameUdmurt: 'Зуевы Ключи',
      description: 'Святые источники и живописные овраги.',
      latitude: 56.8800,
      longitude: 53.3500,
      category: 'nature',
      emoji: '💧',
      location: 'Удмуртия',
    ),
    Landmark(
      id: 'cheganda_caves',
      name: 'Чегандинские пещеры',
      nameUdmurt: 'Чегандинской пещераос',
      description: 'Загадочные рукотворные пещеры на берегу Камы.',
      latitude: 56.7500,
      longitude: 53.5000,
      category: 'nature',
      emoji: '🕳️',
      location: 'Удмуртия',
    ),
    Landmark(
      id: 'zayakino_cedar',
      name: 'Заякинская кедровая роща',
      nameUdmurt: 'Заякинской кедар ур',
      description: 'Уникальная для региона посадка кедров.',
      latitude: 57.1000,
      longitude: 52.9000,
      category: 'nature',
      emoji: '🌳',
      location: 'Удмуртия',
    ),

    // 🧸 Для семейного отдыха
    Landmark(
      id: 'tol_babay',
      name: 'Резиденция Тол Бабая',
      nameUdmurt: 'Тол Бабайлэн резиденциез',
      description: 'Дом удмуртского Деда Мороза.',
      latitude: 57.1936,
      longitude: 53.5428,
      category: 'family',
      emoji: '🎅',
      location: 'с. Шаркан',
    ),
    Landmark(
      id: 'zoo_udмуртия',
      name: 'Государственный зоопарк Удмуртии',
      nameUdmurt: 'Удмуртилысь кун зоопарк',
      description: 'Один из лучших в Европе.',
      latitude: 56.8389,
      longitude: 53.2456,
      category: 'family',
      emoji: '🦁',
      location: 'Ижевск',
    ),
    Landmark(
      id: 'husky_village',
      name: 'Деревня Хаски',
      nameUdmurt: 'Хаски гурт',
      description: 'Парк активного отдыха с собаками хаски.',
      latitude: 56.8800,
      longitude: 53.1500,
      category: 'family',
      emoji: '🐕',
      location: 'Ижевск',
    ),
    Landmark(
      id: 'deer_farm',
      name: 'Оленеферма «Гринфилд парк»',
      nameUdmurt: '«Гринфилд парк» олень ферма',
      description: 'Эко-ферма, где можно покормить оленей.',
      latitude: 56.9200,
      longitude: 53.2800,
      category: 'family',
      emoji: '🦌',
      location: 'Удмуртия',
    ),

    // ✨ Уникальные места
    Landmark(
      id: 'old_bygi',
      name: 'Деревня Старые Быги',
      nameUdmurt: 'Вуж Быги гурт',
      description: 'Первая столица финно-угорского мира с этнографическими программами.',
      latitude: 57.0500,
      longitude: 52.5000,
      category: 'unique',
      emoji: '🏘️',
      location: 'Удмуртия',
    ),
    Landmark(
      id: 'crocodile_monument',
      name: 'Памятник крокодилу',
      nameUdmurt: 'Крокодиллы памятник',
      description: 'Оригинальный городской арт-объект.',
      latitude: 56.8520,
      longitude: 53.2070,
      category: 'unique',
      emoji: '🐊',
      location: 'Ижевск',
    ),
    Landmark(
      id: 'kensky_waterfall',
      name: 'Кенский водопад',
      nameUdmurt: 'Кенской водопад',
      description: 'Живописное рукотворное место недалеко от города.',
      latitude: 56.8700,
      longitude: 53.2800,
      category: 'unique',
      emoji: '💦',
      location: 'Ижевск',
    ),
  ];

  static List<Landmark> getLandmarksNearby({
    required double latitude,
    required double longitude,
    double radiusMeters = 5000,
  }) {
    return allLandmarks.where((landmark) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        landmark.latitude,
        landmark.longitude,
      );
      return distance <= radiusMeters;
    }).toList();
  }

  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000;

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }
}
