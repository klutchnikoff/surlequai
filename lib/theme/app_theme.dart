import 'package:flutter/material.dart';
import 'package:surlequai/theme/colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.bgLight,
        onSurface: AppColors.textLight,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgLight,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.bgLight,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.bgDark,
        onSurface: AppColors.textDark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.bgDark,
      ),
    );
  }

  /// Retourne la couleur de texte secondaire adaptée au thème actuel
  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.textSecondaryLight
        : AppColors.textSecondaryDark;
  }

  /// Retourne la couleur tertiaire adaptée au thème actuel
  static Color getTertiaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.tertiaryLight
        : AppColors.tertiaryDark;
  }
}
