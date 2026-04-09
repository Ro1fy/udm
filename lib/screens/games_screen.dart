import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/game_mode_screen.dart';
import '../theme.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundColor(context),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'Игры',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor(context),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  _GameModeCard(
                    title: 'Выбери перевод',
                    description:
                        'Посмотри на картинку и выбери правильный перевод из 4 вариантов',
                    icon: Icons.check_circle_outline,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GameModeScreen(
                              gameMode: GameMode.chooseTranslation),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _GameModeCard(
                    title: 'Собери слово',
                    description:
                        'Переставь буквы в правильном порядке, чтобы собрать удмуртское слово',
                    icon: Icons.extension,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const GameModeScreen(gameMode: GameMode.wordScramble),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _GameModeCard(
                    title: 'Правда или Ложь',
                    description:
                        'Определи, соответствует ли удмуртское слово картинке',
                    icon: Icons.shuffle,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const GameModeScreen(gameMode: GameMode.trueFalse),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _GameModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.cardBorder(context)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor(context),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.iconBackground(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.pink, size: 34),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.pink,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.pink, size: 20),
          ],
        ),
      ),
    );
  }
}
