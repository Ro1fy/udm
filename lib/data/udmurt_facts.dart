/// Facts about the Udmurt language for the profile and reminders.
class UdmurtFacts {
  static const List<String> languageFacts = [
    'Удмуртский язык относится к финно-угорской языковой семье.',
    'На удмуртском языке говорят около 324 000 человек.',
  ];

  static String getRandomFact() {
    return languageFacts[DateTime.now().millisecond % languageFacts.length];
  }
}
