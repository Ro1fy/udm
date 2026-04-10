import 'package:flutter/material.dart';
import 'constants.dart';

/// Helper class to provide theme-aware colors based on the current mode.
class AppTheme {
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Background color for the main screen
  static Color backgroundColor(BuildContext context) {
    return isDark(context) ? AppColors.black : AppColors.lightBg;
  }

  /// Card/container background color
  static Color cardBackground(BuildContext context) {
    return isDark(context) ? const Color(0xFF1A1A1A) : AppColors.white;
  }

  /// Card border color
  static Color cardBorder(BuildContext context) {
    return isDark(context) ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
  }

  /// Primary text color
  static Color textColor(BuildContext context) {
    return isDark(context) ? AppColors.white : AppColors.textOnLight;
  }

  /// Secondary text color
  static Color textSecondary(BuildContext context) {
    return isDark(context) ? AppColors.textSecondary : const Color(0xFF666666);
  }

  /// Divider color
  static Color dividerColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
  }

  /// Icon container background
  static Color iconBackground(BuildContext context) {
    return isDark(context) ? const Color(0xFF2A2A2A) : AppColors.pink.withOpacity(0.12);
  }

  /// Progress indicator background
  static Color progressBackground(BuildContext context) {
    return isDark(context) ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  }

  /// Switch inactive track color
  static Color switchInactiveTrack(BuildContext context) {
    return isDark(context) ? const Color(0xFF333333) : const Color(0xFFBDBDBD);
  }

  /// Text field fill color
  static Color textFieldFill(BuildContext context) {
    return isDark(context) ? const Color(0xFF1A1A1A) : AppColors.white;
  }

  /// Text field border color
  static Color textFieldBorder(BuildContext context) {
    return isDark(context) ? const Color(0xFF333333) : const Color(0xFFCCCCCC);
  }

  /// Shadow color
  static Color shadowColor(BuildContext context) {
    return isDark(context) ? AppColors.black.withOpacity(0.3) : const Color(0xFF000000).withOpacity(0.1);
  }

  /// Dialog background color
  static Color dialogBackground(BuildContext context) {
    return isDark(context) ? const Color(0xFF1A1A1A) : AppColors.white;
  }

  /// Game background color
  static Color gameBackground(BuildContext context) {
    return isDark(context) ? AppColors.gameBgDark : AppColors.gameBgLight;
  }

  /// Game card background color
  static Color gameCardBackground(BuildContext context) {
    return isDark(context) ? AppColors.gameCardDark : AppColors.gameCardLight;
  }

  /// Game text primary color
  static Color gameTextColor(BuildContext context) {
    return isDark(context) ? AppColors.gameTextDark : AppColors.gameTextLight;
  }

  /// Game text secondary color
  static Color gameTextSecondaryColor(BuildContext context) {
    return isDark(context) ? AppColors.gameTextSecondaryDark : AppColors.gameTextSecondaryLight;
  }

  /// Game card border color
  static Color gameCardBorderColor(BuildContext context) {
    return isDark(context) ? AppColors.cardBorder : AppColors.cardBorderLight;
  }

  /// Game card background color (alias)
  static Color gameCardBg(BuildContext context) {
    return isDark(context) ? AppColors.cardBg : AppColors.cardBgLight;
  }

  /// Creates a themed input decoration
  static InputDecoration inputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.textSecondary),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textSecondary) : null,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF333333)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF333333)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.pink),
      ),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
    );
  }
}
