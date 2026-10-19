import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'services/app_database.dart';
import 'services/notification_service.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.init();
  await NotificationService.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const UdmurtKylApp());
}

class UdmurtKylApp extends StatefulWidget {
  const UdmurtKylApp({super.key});

  @override
  State<UdmurtKylApp> createState() => _UdmurtKylAppState();
}

class _UdmurtKylAppState extends State<UdmurtKylApp> {
  final AuthProvider _auth = AuthProvider();
  final SettingsProvider _settings = SettingsProvider();
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Show loading screen for a minimum duration
    await Future.delayed(const Duration(milliseconds: 2000));
    await _auth.init();
    await _settings.init();

    // Schedule notifications if enabled
    if (_settings.notificationsEnabled) {
      await NotificationService.scheduleAllNotifications();
    }

    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _auth),
        ChangeNotifierProvider.value(value: _settings),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
              value: settings.isDarkMode
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              child: child ?? const SizedBox.shrink(),
            ),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
                surface: AppColors.cardLight,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.lightBg,
              fontFamily: 'Rooftop',
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.lightBg,
                foregroundColor: AppColors.textOnLight,
                centerTitle: false,
                elevation: 0,
                scrolledUnderElevation: 0,
              ),
              cardTheme: CardThemeData(
                elevation: 0,
                color: AppColors.cardLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppColors.cardLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.cardBorderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.cardBorderLight,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: AppColors.cardLight,
                indicatorColor: AppColors.primary.withValues(alpha: 0.12),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  return TextStyle(
                    color: states.contains(WidgetState.selected)
                        ? AppColors.primary
                        : AppColors.textSecondaryLight,
                    fontSize: 11,
                    fontWeight: states.contains(WidgetState.selected)
                        ? FontWeight.w600
                        : FontWeight.normal,
                  );
                }),
              ),
              snackBarTheme: SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.dark,
                surface: AppColors.cardDark,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.darkBg,
              fontFamily: 'Rooftop',
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.darkBg,
                foregroundColor: AppColors.white,
                centerTitle: false,
                elevation: 0,
                scrolledUnderElevation: 0,
              ),
              cardTheme: CardThemeData(
                elevation: 0,
                color: AppColors.cardDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppColors.cardDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: AppColors.cardDark,
                indicatorColor: AppColors.primary.withValues(alpha: 0.24),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  return TextStyle(
                    color: states.contains(WidgetState.selected)
                        ? AppColors.white
                        : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: states.contains(WidgetState.selected)
                        ? FontWeight.w600
                        : FontWeight.normal,
                  );
                }),
              ),
              snackBarTheme: SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.cardDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            home: Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.isLoading) {
                  return Scaffold(
                    backgroundColor: settings.isDarkMode
                        ? AppColors.black
                        : AppColors.lightBg,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Загрузка...',
                            style: TextStyle(
                              color: settings.isDarkMode
                                  ? AppColors.white
                                  : AppColors.textOnLight,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return auth.isLoggedIn
                    ? const MainMenuScreen()
                    : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
