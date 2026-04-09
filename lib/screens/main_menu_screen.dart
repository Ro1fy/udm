import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/auth_provider.dart';
import '../screens/learning_screen.dart';
import '../screens/games_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

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
              color: AppColors.black.withOpacity(0.15),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.black,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.textSecondary,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Привет, ${user?.name ?? 'Друг'}! 👋',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Готов учить удмуртский?',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF333333)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.whatshot,
                            color: AppColors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${user?.streak ?? 0}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
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
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF333333)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Уровень',
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '${user?.level ?? 1}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: ((user?.xp ?? 0) % 100) / 100,
                      backgroundColor: const Color(0xFF333333),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.pink),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${user?.xp ?? 0} / ${(user?.level ?? 1) * 100} XP',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Начать изучение',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
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
                    const Text(
                      'Удмуртский язык относится к финно-угорской языковой семье. Он является родственным венгерскому, финскому и эстонскому языкам! На нём говорят около 324 000 человек.',
                      style: TextStyle(
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Факты об удмуртском языке',
            style: TextStyle(color: AppColors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('📊 324 000 человек говорят на удмуртском языке.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
              Text('🌍 Финно-угорская языковая семья — родственный венгерскому, финскому, эстонскому.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
              Text('⚠️ С 2013 года в атласе вымирающих языков ЮНЕСКО.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
              Text('📝 Алфавит на основе кириллице: Ӝ/ӝ, Ӟ/ӟ, Ӥ/ӥ, Ӧ/ӧ, Ӵ/ӵ.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
              Text('🏛️ Удмуртия — между реками Кама и Вятка.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.black,
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
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.pink, size: 32),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
