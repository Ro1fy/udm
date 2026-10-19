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
    return isDark(context) ? AppColors.cardDark : AppColors.cardLight;
  }

  /// Card border color
  static Color cardBorder(BuildContext context) {
    return isDark(context) ? AppColors.cardBorder : AppColors.cardBorderLight;
  }

  /// Primary text color
  static Color textColor(BuildContext context) {
    return isDark(context) ? AppColors.white : AppColors.textOnLight;
  }

  /// Secondary text color
  static Color textSecondary(BuildContext context) {
    return isDark(context)
        ? AppColors.textSecondary
        : AppColors.textSecondaryLight;
  }

  /// Divider color
  static Color dividerColor(BuildContext context) {
    return isDark(context) ? AppColors.cardBorder : AppColors.cardBorderLight;
  }

  /// Icon container background
  static Color iconBackground(BuildContext context) {
    return AppColors.primary.withValues(alpha: isDark(context) ? 0.2 : 0.1);
  }

  /// Progress indicator background
  static Color progressBackground(BuildContext context) {
    return isDark(context) ? AppColors.cardBorder : AppColors.cardBorderLight;
  }

  /// Switch inactive track color
  static Color switchInactiveTrack(BuildContext context) {
    return isDark(context) ? AppColors.cardBorder : const Color(0xFFD0D2CC);
  }

  /// Text field fill color
  static Color textFieldFill(BuildContext context) {
    return isDark(context) ? AppColors.cardDark : AppColors.cardLight;
  }

  /// Text field border color
  static Color textFieldBorder(BuildContext context) {
    return isDark(context) ? AppColors.cardBorder : AppColors.cardBorderLight;
  }

  /// Shadow color
  static Color shadowColor(BuildContext context) {
    return AppColors.black.withValues(alpha: isDark(context) ? 0.22 : 0.05);
  }

  /// Dialog background color
  static Color dialogBackground(BuildContext context) {
    return isDark(context) ? AppColors.cardDark : AppColors.cardLight;
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
    return isDark(context)
        ? AppColors.gameTextSecondaryDark
        : AppColors.gameTextSecondaryLight;
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
      hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: AppColors.textSecondaryLight),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.cardBorderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.cardBorderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      filled: true,
      fillColor: AppColors.cardLight,
    );
  }
}
