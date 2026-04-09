import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/auth_provider.dart';
import '../screens/learning_screen.dart';
import '../screens/games_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../theme.dart';
import '../data/udmurt_facts.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    LearningScreen(),
    GamesScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor(context),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.backgroundColor(context),
          selectedItemColor: AppColors.pink,
          unselectedItemColor: AppTheme.textSecondary(context),
          selectedFontSize: 11,
          unselectedFontSize: 10,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book), label: 'Обучение'),
            BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Игры'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Настройки'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final randomFact = UdmurtFacts.getRandomFact();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Привет, ${user?.name ?? 'Друг'}! 👋',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Готов учить удмуртский?',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.cardBorder(context)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.whatshot,
                            color: AppTheme.textColor(context), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${user?.streak ?? 0}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // XP Card — solid dark with white border
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.cardBorder(context)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Уровень',
                          style: TextStyle(
                            fontSize: 17,
                            color: AppTheme.textColor(context),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppTheme.iconBackground(context),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '${user?.level ?? 1}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: ((user?.xp ?? 0) % 100) / 100,
                      backgroundColor: AppTheme.progressBackground(context),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.pink),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${user?.xp ?? 0} / ${(user?.level ?? 1) * 100} XP',
                      style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Начать изучение',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor(context),
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _QuickActionCard(
                    title: 'Словарь',
                    icon: Icons.menu_book,
                    onTap: () {
                      // Navigate to learning tab (index 1)
                      context.findAncestorStateOfType<_MainMenuScreenState>()
                          ?._onItemTapped(1);
                    },
                  ),
                  _QuickActionCard(
                    title: 'Игры',
                    icon: Icons.games,
                    onTap: () {
                      context.findAncestorStateOfType<_MainMenuScreenState>()
                          ?._onItemTapped(2);
                    },
                  ),
                  _QuickActionCard(
                    title: 'Факты',
                    icon: Icons.lightbulb,
                    onTap: () {
                      _showFactsDialog(context);
                    },
                  ),
                  _QuickActionCard(
                    title: 'Прогресс',
                    icon: Icons.trending_up,
                    onTap: () {
                      context.findAncestorStateOfType<_MainMenuScreenState>()
                          ?._onItemTapped(3);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.skyBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: AppColors.black, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Интересный факт',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      randomFact,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.black,
                        height: 1.5,
                      ),
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

  void _showFactsDialog(BuildContext context) {
    final languageFacts = UdmurtFacts.languageFacts;
    final udmurtiaFacts = UdmurtFacts.udmurtiaFacts;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.dialogBackground(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Факты об удмуртском языке и Удмуртии',
            style: TextStyle(color: AppTheme.textColor(context))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🏠 Удмуртия и факты',
                  style: TextStyle(color: AppTheme.textColor(context), fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...udmurtiaFacts.take(5).map((fact) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $fact',
                        style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 13, height: 1.5)),
                  )),
              const SizedBox(height: 16),
              Text('📚 Удмуртский язык',
                  style: TextStyle(color: AppTheme.textColor(context), fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...languageFacts.take(5).map((fact) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $fact',
                        style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 13, height: 1.5)),
                  )),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.cardBorder(context)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.iconBackground(context),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.pink, size: 32),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
