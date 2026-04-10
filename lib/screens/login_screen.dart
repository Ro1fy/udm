import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/auth_provider.dart';
import '../screens/main_menu_screen.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;
  bool _obscurePassword = true;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = _isLoginMode
        ? await auth.login(
            _emailController.text.trim(),
            _passwordController.text,
          )
        : await auth.register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          );
    if (ok && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
      );
    } else if (mounted) {
      // Show error message if login/register failed
      final errorMsg = auth.errorMessage;
      if (errorMsg != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.pink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.backgroundColor(context),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.07),
                  // Logo circle — solid pink
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pink.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.school, color: AppColors.white, size: 56),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppStrings.appSubtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  // Form card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground(context),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppTheme.cardBorder(context)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isLoginMode ? 'Вход' : 'Регистрация',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (!_isLoginMode) ...[
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: AppColors.white),
                              decoration: InputDecoration(
                                labelText: 'Имя',
                                hintText: 'Ваше имя',
                                hintStyle:
                                    const TextStyle(color: AppColors.textSecondary),
                                prefixIcon: const Icon(Icons.person_outline,
                                    color: AppColors.textSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      const BorderSide(color: Color(0xFF333333)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      const BorderSide(color: Color(0xFF333333)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      const BorderSide(color: AppColors.pink),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1A1A1A),
                              ),
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Введите имя' : null,
                            ),
                            const SizedBox(height: 14),
                          ],
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: AppColors.white),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'example@mail.ru',
                              hintStyle:
                                  const TextStyle(color: AppColors.textSecondary),
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: AppColors.textSecondary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Color(0xFF333333)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Color(0xFF333333)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: AppColors.pink),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1A1A1A),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Введите email';
                              }
                              if (!v.contains('@')) return 'Некорректный email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: AppColors.white),
                            decoration: InputDecoration(
                              labelText: 'Пароль',
                              hintText: 'Минимум 4 символа',
                              hintStyle:
                                  const TextStyle(color: AppColors.textSecondary),
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: AppColors.textSecondary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () => setState(() {
                                  _obscurePassword = !_obscurePassword;
                                }),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Color(0xFF333333)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Color(0xFF333333)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: AppColors.pink),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1A1A1A),
                            ),
                            validator: (v) {
                              if (v == null || v.length < 4) {
                                return 'Минимум 4 символа';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 22),
                          Consumer<AuthProvider>(
                            builder: (context, auth, child) {
                              final errorMsg = auth.errorMessage;
                              return Column(
                                children: [
                                  if (errorMsg != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.pink.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.pink.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        errorMsg,
                                        style: const TextStyle(
                                          color: AppColors.pink,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                  ElevatedButton(
                                    onPressed: auth.isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.pink,
                                      foregroundColor: AppColors.white,
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                                      minimumSize: const Size(double.infinity, 56),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: auth.isLoading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              color: AppColors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            _isLoginMode ? 'Войти' : 'Создать аккаунт',
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: () {
                              context.read<AuthProvider>().clearError();
                              setState(() => _isLoginMode = !_isLoginMode);
                            },
                            child: Text(
                              _isLoginMode
                                  ? 'Нет аккаунта? Зарегистрироваться'
                                  : 'Уже есть аккаунт? Войти',
                              style: const TextStyle(
                                color: AppColors.skyBlue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Accent line — solid pink
                  Container(
                    height: 3,
                    color: AppColors.pink,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Данные хранятся только на этом устройстве',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
