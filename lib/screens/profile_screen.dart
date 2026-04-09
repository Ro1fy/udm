import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.black,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header — centered dark card
              Center(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: const Color(0xFF2A2A2A),
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '🎓',
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.pink,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'Уровень ${user.level}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Статистика',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.whatshot,
                      title: 'Серия',
                      value: '${user.streak}',
                      color: AppColors.pink,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.star,
                      title: 'XP',
                      value: '${user.xp}',
                      color: AppColors.pink,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.menu_book,
                      title: 'Слова',
                      value:
                          '${user.wordsLearned.values.fold<int>(0, (a, b) => a + b)}',
                      color: AppColors.pink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'Результаты игр',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              _GameStatCard(
                title: 'Выбери перевод',
                played: user.gameStatsPlayed['choose_translation'] ?? 0,
                correct: user.gameStatsCorrect['choose_translation'] ?? 0,
                bestScore: user.gameStatsBestScore['choose_translation'] ?? 0,
              ),
              const SizedBox(height: 10),
              _GameStatCard(
                title: 'Собери слово',
                played: user.gameStatsPlayed['word_scramble'] ?? 0,
                correct: user.gameStatsCorrect['word_scramble'] ?? 0,
                bestScore: user.gameStatsBestScore['word_scramble'] ?? 0,
              ),
              const SizedBox(height: 10),
              _GameStatCard(
                title: 'Правда или Ложь',
                played: user.gameStatsPlayed['true_false'] ?? 0,
                correct: user.gameStatsCorrect['true_false'] ?? 0,
                bestScore: user.gameStatsBestScore['true_false'] ?? 0,
              ),
              const SizedBox(height: 22),
              const Text(
                'Аккаунт',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit, color: AppColors.pink),
                      title:
                          const Text('Редактировать профиль', style: TextStyle(color: AppColors.white)),
                      trailing:
                          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      onTap: () => _showEditProfileDialog(context),
                    ),
                    const Divider(height: 1, color: Color(0xFF2A2A2A)),
                    ListTile(
                      leading: const Icon(Icons.info, color: AppColors.skyBlue),
                      title:
                          const Text('Об удмуртском языке', style: TextStyle(color: AppColors.white)),
                      trailing:
                          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      onTap: () => _showLanguageInfo(context),
                    ),
                    const Divider(height: 1, color: Color(0xFF2A2A2A)),
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppColors.lime),
                      title:
                          const Text('Выйти', style: TextStyle(color: AppColors.white)),
                      trailing:
                          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      onTap: () async {
                        await auth.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Редактировать профиль',
            style: TextStyle(color: AppColors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.white),
          decoration: const InputDecoration(
            labelText: 'Имя',
            labelStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF333333)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<AuthProvider>().updateProfile(controller.text.trim());
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showLanguageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Text('🏠', style: TextStyle(fontSize: 26)),
            SizedBox(width: 10),
            Text('Удмуртский язык',
                style: TextStyle(color: AppColors.white, fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Интересные факты',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              _FactItem(emoji: '📊', fact: 'На удмуртском языке говорят около 324 000 человек.'),
              _FactItem(emoji: '🌍', fact: 'Удмуртский язык относится к финно-угорской языковой семье.'),
              _FactItem(emoji: '⚠️', fact: 'В 2013 году ЮНЕСКО включил удмуртский язык в атлас вымирающих языков.'),
              _FactItem(emoji: '📝', fact: 'Удмуртский алфавит основан на кириллице с добавлением букв: Ӝ/ӝ, Ӟ/ӟ, Ӥ/ӥ, Ӧ/ӧ, Ӵ/ӵ.'),
              _FactItem(emoji: '🏛️', fact: 'Удмуртия — республика в составе России, расположена между реками Кама и Вятка.'),
              const SizedBox(height: 14),
              const Text(
                'Количество носителей',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'По данным переписи 2010 года — 26,99% населения Удмуртии. К 2020 году доля сократилась примерно на 6%.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.icon, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColors.pink),
          ),
        ],
      ),
    );
  }
}

class _GameStatCard extends StatelessWidget {
  final String title;
  final int played;
  final int correct;
  final int bestScore;

  const _GameStatCard({required this.title, required this.played, required this.correct, required this.bestScore});

  @override
  Widget build(BuildContext context) {
    // correct = total correct answers, played = number of games
    // Each game has 10 questions, so max correct per game = 10
    final totalQuestions = played * 10;
    final accuracy = totalQuestions == 0 ? 0.0 : correct / totalQuestions;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.white),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(label: 'Игр', value: '$played'),
              _MiniStat(label: 'Верно', value: '$correct'),
              _MiniStat(label: 'Лучший', value: '$bestScore'),
              _MiniStat(label: 'Точность', value: '${(accuracy * 100).toInt()}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.pink),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _FactItem extends StatelessWidget {
  final String emoji;
  final String fact;

  const _FactItem({required this.emoji, required this.fact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fact,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}


