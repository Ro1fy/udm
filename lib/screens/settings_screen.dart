import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

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
              const Text(
                'Настройки',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink.withOpacity(0.3),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '🏠 Удмурт кыл',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Версия 1.0.0',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    const Center(
                      child: Text(
                        'Мобильное приложение для изучения удмуртского языка через игровые модули',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Основные настройки',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: Column(
                  children: [
                    _SettingTile(
                      icon: Icons.volume_up,
                      title: 'Звук',
                      subtitle: 'Включить звуковое сопровождение',
                      value: settings.soundEnabled,
                      onChanged: settings.toggleSound,
                    ),
                    const Divider(height: 1, color: Color(0xFF2A2A2A)),
                    _SettingTile(
                      icon: Icons.notifications,
                      title: 'Уведомления',
                      subtitle: 'Push-уведомления об интересных словах',
                      value: settings.notificationsEnabled,
                      onChanged: (v) async {
                        if (v) {
                          final s = await Permission.notification.request();
                          if (s.isGranted) settings.toggleNotifications(true);
                        } else {
                          settings.toggleNotifications(false);
                        }
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFF2A2A2A)),
                    _SettingTile(
                      icon: Icons.location_on,
                      title: 'Геолокация',
                      subtitle: 'Слова и достопримечательности рядом',
                      value: settings.geolocationEnabled,
                      onChanged: (v) async {
                        if (v) {
                          final s = await Permission.locationWhenInUse.request();
                          if (s.isGranted) settings.toggleGeolocation(true);
                        } else {
                          settings.toggleGeolocation(false);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'О приложении',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: Column(
                  children: [
                    const _InfoTile(
                      icon: Icons.language,
                      title: 'Удмуртский язык',
                      subtitle: 'Финно-угорская языковая семья',
                    ),
                    const Divider(height: 1, color: Color(0xFF2A2A2A)),
                    const _InfoTile(
                      icon: Icons.people,
                      title: 'Носителей',
                      subtitle: '~324 000 человек',
                    ),
                    const Divider(height: 1, color: Color(0xFF2A2A2A)),
                    const _InfoTile(
                      icon: Icons.warning_amber,
                      title: 'Статус ЮНЕСКО',
                      subtitle: 'Под угрозой исчезновения (с 2013 г.)',
                    ),
                    const Divider(height: 1, color: Color(0xFF2A2A2A)),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.pink.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.info, color: AppColors.pink),
                      ),
                      title: const Text('Подробнее о языке',
                          style: TextStyle(color: AppColors.white)),
                      trailing: const Icon(Icons.chevron_right,
                          color: AppColors.textSecondary),
                      onTap: () => _showLanguageDetails(context),
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

  void _showLanguageDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Удмуртский язык',
            style: TextStyle(color: AppColors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Общие сведения',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.skyBlue)),
              SizedBox(height: 6),
              Text(
                'Удмуртский язык (удмурт кыл) — язык удмуртов, один из финно-угорских языков.',
                style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
              ),
              SizedBox(height: 14),
              Text('Алфавит',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.skyBlue)),
              SizedBox(height: 6),
              Text(
                'Основан на кириллице. Дополнительные буквы: Ӝ/ӝ, Ӟ/ӟ, Ӥ/ӥ, Ӧ/ӧ, Ӵ/ӵ.',
                style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      secondary: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.pink.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.pink, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.white)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.pink,
      inactiveTrackColor: const Color(0xFF333333),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.pink.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.pink, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.white)),
      subtitle: Text(subtitle,
          style: const TextStyle(color: AppColors.textSecondary)),
    );
  }
}

