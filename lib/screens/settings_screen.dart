import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import '../providers/settings_provider.dart';
import '../services/geolocation_service.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

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
              Text(
                'Настройки',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor(context),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Основные настройки',
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
                    _SettingTile(
                      icon: Icons.palette,
                      title: 'Тёмная тема',
                      subtitle: 'Использовать тёмное оформление',
                      value: settings.isDarkMode,
                      onChanged: settings.toggleTheme,
                    ),
                    Divider(height: 1, color: AppTheme.dividerColor(context)),
                    _SettingTile(
                      icon: Icons.volume_up,
                      title: 'Звук',
                      subtitle: 'Включить звуковое сопровождение',
                      value: settings.soundEnabled,
                      onChanged: settings.toggleSound,
                    ),
                    Divider(height: 1, color: AppTheme.dividerColor(context)),
                    _SettingTile(
                      icon: Icons.notifications,
                      title: 'Уведомления',
                      subtitle: 'Напоминания об обучении',
                      value: settings.notificationsEnabled,
                      onChanged: (v) async {
                        if (v) {
                          final s = await Permission.notification.request();
                          if (s.isGranted) {
                            settings.toggleNotifications(true);
                          }
                        } else {
                          settings.toggleNotifications(false);
                        }
                      },
                    ),
                    Divider(height: 1, color: AppTheme.dividerColor(context)),
                    _SettingTile(
                      icon: Icons.location_on,
                      title: 'Геолокация',
                      subtitle: 'Использование местоположения',
                      value: settings.geolocationEnabled,
                      onChanged: (v) async {
                        if (v) {
                          final s = await Permission.locationWhenInUse
                              .request();
                          if (s.isGranted) {
                            final isEnabled =
                                await GeolocationService.isLocationServiceEnabled();
                            if (isEnabled) {
                              settings.toggleGeolocation(true);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      '✓ Геолокация включена. Вы будете получать уведомления о достопримечательностях рядом.',
                                    ),
                                    backgroundColor: AppColors.primary,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Включите службу геолокации в настройках устройства',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Разрешите доступ к геолокации для получения уведомлений о достопримечательностях',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } else {
                          settings.toggleGeolocation(false);
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
          color: AppTheme.iconBackground(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppTheme.textColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary(context)),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      inactiveTrackColor: AppTheme.switchInactiveTrack(context),
    );
  }
}
