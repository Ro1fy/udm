import 'package:flutter/material.dart';

/// T2 Mobile brand colors — from T2 brandbook
/// Primary:   #000000 (black), #FFFFFF (white), #FF3495 (pink)
/// Accent:    #A7FC00 (lime), #00BFFF (sky blue)
class AppColors {
  // Primary palette
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color pink = Color(0xFFFF3495);

  // Accent palette
  static const Color lime = Color(0xFFA7FC00);
  static const Color skyBlue = Color(0xFF00BFFF);

  // Derived / utility
  static const Color darkBg = Color(0xFF0D0D0D);
  static const Color lightBg = Color(0xFFF2F2F5);
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color cardBorder = Color(0xFF2A2A2A);
  static const Color cardBg = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textOnLight = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF3495);
}

class AppStrings {
  static const String appName = 'Удмурт кыл';
  static const String appSubtitle = 'Изучай удмуртский язык играя';
}
