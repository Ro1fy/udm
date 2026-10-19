import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/game_mode_screen.dart';
import '../screens/extra_game_screen.dart';
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
                        'Выбери правильный перевод слова из трёх вариантов',
                    icon: Icons.translate_rounded,
                    onTap: () => _openGame(
                      context,
                      const GameModeScreen(
                        gameMode: GameMode.chooseTranslation,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GameModeCard(
                    title: 'Найди лишнее слово',
                    description: 'Найди слово, которое относится к другой теме',
                    icon: Icons.filter_alt_rounded,
                    onTap: () => _openGame(
                      context,
                      const ExtraGameScreen(mode: ExtraGameMode.findOdd),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GameModeCard(
                    title: 'Распредели по темам',
                    description:
                        'Перетащи слова в подходящие тематические группы',
                    icon: Icons.drag_indicator_rounded,
                    onTap: () => _openGame(
                      context,
                      const ExtraGameScreen(mode: ExtraGameMode.sortWords),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GameModeCard(
                    title: 'Найди пару',
                    description: 'Сопоставь удмуртское слово с переводом',
                    icon: Icons.grid_view_rounded,
                    onTap: () => _openGame(
                      context,
                      const ExtraGameScreen(mode: ExtraGameMode.memoryPairs),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GameModeCard(
                    title: 'Собери слово',
                    description:
                        'Переставь буквы в правильном порядке, чтобы собрать удмуртское слово',
                    icon: Icons.extension_rounded,
                    onTap: () => _openGame(
                      context,
                      const GameModeScreen(gameMode: GameMode.wordScramble),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GameModeCard(
                    title: 'Правда или Ложь',
                    description: 'Определи, подходит ли слово к картинке',
                    icon: Icons.fact_check_outlined,
                    onTap: () => _openGame(
                      context,
                      const GameModeScreen(gameMode: GameMode.trueFalse),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGame(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
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
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppTheme.iconBackground(context),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor(context),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textSecondary(context),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
