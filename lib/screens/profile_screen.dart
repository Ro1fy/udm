import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (!auth.isLoggedIn || user == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.backgroundColor(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👤', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 24),
                Text(
                  'Аккаунт не найден',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'У вас нет аккаунта. Пожалуйста, войдите в систему или зарегистрируйтесь.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Войти / Зарегистрироваться'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundColor(context),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              // Profile header — centered dark card
              Center(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground(context),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.cardBorder(context)),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppTheme.iconBackground(context),
                        child: user.avatar.isNotEmpty
                            ? Text(
                          user.avatar,
                          style: const TextStyle(fontSize: 44),
                        )
                            : Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '🎓',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
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
              Text(
                'Статистика',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor(context),
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
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.star,
                      title: 'XP',
                      value: '${user.xp}',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.menu_book,
                      title: 'Слова',
                      value:
                      '${user.learnedWordsReal.values.fold<int>(0, (a, b) => a + b)}',
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'Результаты игр',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor(context),
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
                title: 'Найди лишнее слово',
                played: user.gameStatsPlayed['find_odd_word'] ?? 0,
                correct: user.gameStatsCorrect['find_odd_word'] ?? 0,
                bestScore: user.gameStatsBestScore['find_odd_word'] ?? 0,
              ),
              const SizedBox(height: 10),
              _GameStatCard(
                title: 'Сортировка',
                played: user.gameStatsPlayed['sort_words'] ?? 0,
                correct: user.gameStatsCorrect['sort_words'] ?? 0,
                bestScore: user.gameStatsBestScore['sort_words'] ?? 0,
              ),
              const SizedBox(height: 10),
              _GameStatCard(
                title: 'Найди пару',
                played: user.gameStatsPlayed['memory_pairs'] ?? 0,
                correct: user.gameStatsCorrect['memory_pairs'] ?? 0,
                bestScore: user.gameStatsBestScore['memory_pairs'] ?? 0,
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
              Text(
                'Аккаунт',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor(context),
                ),
              ),
              const SizedBox(height: 12),
              Material(
                color: AppTheme.cardBackground(context),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: AppTheme.cardBorder(context)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit, color: AppColors.primary),
                      title: Text(
                        'Редактировать профиль',
                        style: TextStyle(color: AppTheme.textColor(context)),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.primary, size: 24),
                      onTap: () => _showEditProfileDialog(
                        context,
                        user.name,
                        user.avatar,
                      ),
                    ),
                    Divider(height: 1, color: AppTheme.dividerColor(context)),
                    ListTile(
                      leading: const Icon(Icons.info, color: AppColors.primary),
                      title: Text(
                        'Об удмуртском языке',
                        style: TextStyle(color: AppTheme.textColor(context)),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.primary, size: 24),
                      onTap: () => _showLanguageInfo(context),
                    ),
                    Divider(height: 1, color: AppTheme.dividerColor(context)),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: AppColors.accent,
                      ),
                      title: Text(
                        'Выйти',
                        style: TextStyle(color: AppTheme.textColor(context)),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.primary, size: 24),
                      onTap: () async {
                        await auth.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
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

  Future<void> _showEditProfileDialog(
      BuildContext context,
      String initialName,
      String initialAvatar,
      ) async {
    // Захватываем провайдер ДО открытия диалога
    final authProvider = context.read<AuthProvider>();

    await showDialog<void>(
      context: context,
      builder: (_) => ChangeNotifierProvider<AuthProvider>.value(
        value: authProvider,
        child: _EditProfileDialog(
          initialName: initialName,
          initialAvatar: initialAvatar,
        ),
      ),
    );
  }

  void _showLanguageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.dialogBackground(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Text('🏠', style: TextStyle(fontSize: 26)),
            const SizedBox(width: 10),
            Text(
              'Удмуртский язык',
              style: TextStyle(
                color: AppTheme.textColor(context),
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Удмуртский язык относится к финно-угорской языковой семье.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary(context),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'На удмуртском языке говорят около 324 000 человек.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Вынесенный диалог редактирования профиля
// ============================================================
class _EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialAvatar;

  const _EditProfileDialog({
    required this.initialName,
    required this.initialAvatar,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  static const _avatars = ['🎓', '🦊', '🐻', '🐦', '🌞', '🌿', '⚡', '🏠'];

  late final TextEditingController _controller;
  late String _selectedAvatar;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
    _selectedAvatar = widget.initialAvatar.isEmpty
        ? _avatars.first
        : widget.initialAvatar;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);

    final auth = context.read<AuthProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final newName = _controller.text.trim();
    final newAvatar = _selectedAvatar;

    navigator.pop();

    try {
      if (newName.isNotEmpty) {
        await auth.updateProfile(newName);
      }
      await auth.updateAvatar(newAvatar);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.dialogBackground(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text(
        'Редактировать профиль',
        style: TextStyle(color: AppTheme.textColor(context)),
      ),
      // SizedBox(width: double.maxFinite) нужен, чтобы SingleChildScrollView
      // не «сжал» содержимое до минимальной ширины в AlertDialog.
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                style: TextStyle(color: AppTheme.textColor(context)),
                decoration: InputDecoration(
                  labelText: 'Имя',
                  labelStyle: TextStyle(color: AppTheme.textSecondary(context)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.cardBorder(context)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Аватар',
                style: TextStyle(
                  color: AppTheme.textColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              // Область аватарок: ограничена по высоте и скроллится,
              // если список не помещается или экран слишком узкий.
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    primary: false,
                    padding: const EdgeInsets.only(right: 4),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _avatars
                          .map(
                            (avatar) => ChoiceChip(
                          label: Text(
                            avatar,
                            style: const TextStyle(fontSize: 24),
                          ),
                          selected: _selectedAvatar == avatar,
                          onSelected: (_) => setState(
                                () => _selectedAvatar = avatar,
                          ),
                          selectedColor: AppColors.primary.withValues(
                            alpha: 0.18,
                          ),
                          side: BorderSide(
                            color: _selectedAvatar == avatar
                                ? AppColors.primary
                                : AppTheme.cardBorder(context),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Отмена',
            style: TextStyle(color: AppTheme.textSecondary(context)),
          ),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder(context)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColors.primary),
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

  const _GameStatCard({
    required this.title,
    required this.played,
    required this.correct,
    required this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    // correct = total correct answers, played = number of games
    // Each game has 10 questions, so max correct per game = 10
    final totalQuestions = played * 10;
    final accuracy = totalQuestions == 0 ? 0.0 : correct / totalQuestions;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor(context),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(label: 'Игр', value: '$played'),
              _MiniStat(label: 'Верно', value: '$correct'),
              _MiniStat(label: 'Лучший', value: '$bestScore'),
              _MiniStat(
                label: 'Точность',
                value: '${(accuracy * 100).toInt()}%',
              ),
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
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondary(context),
          ),
        ),
      ],
    );
  }
}