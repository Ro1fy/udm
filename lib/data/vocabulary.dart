import '../models/word.dart';

/// Complete Udmurt vocabulary data for the app
class VocabularyData {
  static const List<Topic> topics = [
    Topic(
      id: 'greetings',
      title: 'Приветствия',
      titleUdmurt: 'Чиньыен веран',
      icon: '👋',
      description: 'Основные фразы для приветствия и вежливого общения',
      wordIds: ['hello', 'goodbye', 'thank_you', 'please', 'how_are_you',
                'good_morning', 'good_night', 'nice_to_meet'],
    ),
    Topic(
      id: 'numbers',
      title: 'Числа 1-10',
      titleUdmurt: 'Лыдъемъёс 1-10',
      icon: '🔢',
      description: 'Научитесь считать по-удмуртски от 1 до 10',
      wordIds: ['one', 'two', 'three', 'four', 'five',
                'six', 'seven', 'eight', 'nine', 'ten'],
    ),
    Topic(
      id: 'wild_animals',
      title: 'Дикие животные',
      titleUdmurt: 'Пöйшуръёс',
      icon: '🐻',
      description: 'Названия диких животных, обитающих в Удмуртии',
      wordIds: ['bear', 'wolf', 'fox', 'hare', 'moose',
                'squirrel', 'hedgehog', 'eagle'],
    ),
    Topic(
      id: 'domestic_animals',
      title: 'Домашние животные',
      titleUdmurt: 'Гурт пöйшуръёс',
      icon: '🐄',
      description: 'Домашние животные и их детёныши',
      wordIds: ['cow', 'horse', 'sheep', 'pig', 'chicken',
                'dog', 'cat', 'goose'],
    ),
    Topic(
      id: 'family',
      title: 'Моя семья',
      titleUdmurt: 'Монэсьтым семьяе',
      icon: '👨‍👩‍👧‍👦',
      description: 'Члены семьи и родственники',
      wordIds: ['mother', 'father', 'sister', 'brother', 'grandmother',
                'grandfather', 'son', 'daughter'],
    ),
  ];

  static const List<Word> words = [
    // === GREETINGS ===
    Word(
      id: 'hello',
      udmurt: 'Чиньы',
      russian: 'Привет',
      transcription: '[чиньы]',
      topicId: 'greetings',
    ),
    Word(
      id: 'goodbye',
      udmurt: 'Лулӑн-лулӑн',
      russian: 'До свидания',
      transcription: '[лулын-лулын]',
      topicId: 'greetings',
    ),
    Word(
      id: 'thank_you',
      udmurt: 'Тау',
      russian: 'Спасибо',
      transcription: '[тау]',
      topicId: 'greetings',
    ),
    Word(
      id: 'please',
      udmurt: 'Курисько',
      russian: 'Пожалуйста',
      transcription: '[курисько]',
      topicId: 'greetings',
    ),
    Word(
      id: 'how_are_you',
      udmurt: 'Кыӵе тӥляд мылкыдыд?',
      russian: 'Как дела?',
      transcription: '[кыче тилиад мылкыдыд]',
      topicId: 'greetings',
    ),
    Word(
      id: 'good_morning',
      udmurt: 'Бур ӵукна!',
      russian: 'Доброе утро!',
      transcription: '[бур чукна]',
      topicId: 'greetings',
    ),
    Word(
      id: 'good_night',
      udmurt: 'Бур уй!',
      russian: 'Спокойной ночи!',
      transcription: '[бур уй]',
      topicId: 'greetings',
    ),
    Word(
      id: 'nice_to_meet',
      udmurt: 'Тодматскеме шумпотӥсько',
      russian: 'Рад познакомиться',
      transcription: '[тодматскеме шумпотисько]',
      topicId: 'greetings',
    ),

    // === NUMBERS 1-10 ===
    Word(
      id: 'one',
      udmurt: 'Одӥг',
      russian: 'Один',
      transcription: '[одиг]',
      topicId: 'numbers',
    ),
    Word(
      id: 'two',
      udmurt: 'Кык',
      russian: 'Два',
      transcription: '[кык]',
      topicId: 'numbers',
    ),
    Word(
      id: 'three',
      udmurt: 'Куинь',
      russian: 'Три',
      transcription: '[куинь]',
      topicId: 'numbers',
    ),
    Word(
      id: 'four',
      udmurt: 'Нёль',
      russian: 'Четыре',
      transcription: '[нёль]',
      topicId: 'numbers',
    ),
    Word(
      id: 'five',
      udmurt: 'Вить',
      russian: 'Пять',
      transcription: '[вить]',
      topicId: 'numbers',
    ),
    Word(
      id: 'six',
      udmurt: 'Куать',
      russian: 'Шесть',
      transcription: '[куать]',
      topicId: 'numbers',
    ),
    Word(
      id: 'seven',
      udmurt: 'Сизьым',
      russian: 'Семь',
      transcription: '[сизьым]',
      topicId: 'numbers',
    ),
    Word(
      id: 'eight',
      udmurt: 'Тямыз',
      russian: 'Восемь',
      transcription: '[тямыз]',
      topicId: 'numbers',
    ),
    Word(
      id: 'nine',
      udmurt: 'Укмыс',
      russian: 'Девять',
      transcription: '[укмыс]',
      topicId: 'numbers',
    ),
    Word(
      id: 'ten',
      udmurt: 'Дас',
      russian: 'Десять',
      transcription: '[дас]',
      topicId: 'numbers',
    ),

    // === WILD ANIMALS ===
    Word(
      id: 'bear',
      udmurt: 'Гондыр',
      russian: 'Медведь',
      transcription: '[гондыр]',
      topicId: 'wild_animals',
    ),
    Word(
      id: 'wolf',
      udmurt: 'Кион',
      russian: 'Волк',
      transcription: '[кион]',
      topicId: 'wild_animals',
    ),
    Word(
      id: 'fox',
      udmurt: 'Дэри',
      russian: 'Лиса',
      transcription: '[дэри]',
      topicId: 'wild_animals',
    ),
    Word(
      id: 'hare',
      udmurt: 'Лули',
      russian: 'Заяц',
      transcription: '[лули]',
      topicId: 'wild_animals',
    ),
    Word(
      id: 'moose',
      udmurt: 'Джудж',
      russian: 'Лось',
      transcription: '[джудж]',
      topicId: 'wild_animals',
    ),
    Word(
      id: 'squirrel',
      udmurt: 'Иштан',
      russian: 'Белка',
      transcription: '[иштан]',
      topicId: 'wild_animals',
    ),
    Word(
      id: 'hedgehog',
      udmurt: 'Пияла',
      russian: 'Ёж',
      transcription: '[пияла]',
      topicId: 'wild_animals',
    ),
    Word(
      id: 'eagle',
      udmurt: 'Шунды пöйшур',
      russian: 'Орёл',
      transcription: '[шунды пёйшур]',
      topicId: 'wild_animals',
    ),

    // === DOMESTIC ANIMALS ===
    Word(
      id: 'cow',
      udmurt: 'Скал',
      russian: 'Корова',
      transcription: '[скал]',
      topicId: 'domestic_animals',
    ),
    Word(
      id: 'horse',
      udmurt: 'Вал',
      russian: 'Лошадь',
      transcription: '[вал]',
      topicId: 'domestic_animals',
    ),
    Word(
      id: 'sheep',
      udmurt: 'Ыж',
      russian: 'Овца',
      transcription: '[ыж]',
      topicId: 'domestic_animals',
    ),
    Word(
      id: 'pig',
      udmurt: 'Парсь',
      russian: 'Свинья',
      transcription: '[парсь]',
      topicId: 'domestic_animals',
    ),
    Word(
      id: 'chicken',
      udmurt: 'Кыкы',
      russian: 'Курица',
      transcription: '[кыкы]',
      topicId: 'domestic_animals',
    ),
    Word(
      id: 'dog',
      udmurt: 'Пуны',
      russian: 'Собака',
      transcription: '[пуны]',
      topicId: 'domestic_animals',
    ),
    Word(
      id: 'cat',
      udmurt: 'Каны',
      russian: 'Кошка',
      transcription: '[каны]',
      topicId: 'domestic_animals',
    ),
    Word(
      id: 'goose',
      udmurt: 'Казь',
      russian: 'Гусь',
      transcription: '[казь]',
      topicId: 'domestic_animals',
    ),

    // === FAMILY ===
    Word(
      id: 'mother',
      udmurt: 'Анай',
      russian: 'Мама',
      transcription: '[анай]',
      topicId: 'family',
    ),
    Word(
      id: 'father',
      udmurt: 'Атай',
      russian: 'Папа',
      transcription: '[атай]',
      topicId: 'family',
    ),
    Word(
      id: 'sister',
      udmurt: 'Сузэр',
      russian: 'Сестра',
      transcription: '[сузэр]',
      topicId: 'family',
    ),
    Word(
      id: 'brother',
      udmurt: 'Выны',
      russian: 'Брат',
      transcription: '[выны]',
      topicId: 'family',
    ),
    Word(
      id: 'grandmother',
      udmurt: 'Пересь анай',
      russian: 'Бабушка',
      transcription: '[пересь анай]',
      topicId: 'family',
    ),
    Word(
      id: 'grandfather',
      udmurt: 'Пересь атай',
      russian: 'Дедушка',
      transcription: '[пересь атай]',
      topicId: 'family',
    ),
    Word(
      id: 'son',
      udmurt: 'Пи',
      russian: 'Сын (мальчик)',
      transcription: '[пи]',
      topicId: 'family',
    ),
    Word(
      id: 'daughter',
      udmurt: 'Льыль',
      russian: 'Дочь (девочка)',
      transcription: '[льыль]',
      topicId: 'family',
    ),
  ];

  static Word getWordById(String id) {
    return words.firstWhere((w) => w.id == id,
        orElse: () => const Word(
              id: 'unknown',
              udmurt: '?',
              russian: 'Неизвестно',
              transcription: '',
              topicId: '',
            ));
  }

  static Topic getTopicById(String id) {
    return topics.firstWhere((t) => t.id == id,
        orElse: () => const Topic(
              id: 'unknown',
              title: 'Неизвестно',
              titleUdmurt: '',
              icon: '❓',
              description: '',
              wordIds: [],
            ));
  }
}
