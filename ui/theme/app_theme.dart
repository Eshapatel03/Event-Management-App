import 'package:flutter/material.dart';

class AppTheme {
  // Deep navy / charcoal
  static const Color background = Color(0xFF070A12);
  static const Color card = Color(0xFF0B1220);

  static const Color primaryBlue = Color(0xFFC0E1D2);
  static const Color beige = Color(0xFFF6F4E8);
  static const Color infoBlue = Color(0xFFC0E1D2);

  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white70),
        bodyLarge: TextStyle(color: Colors.white70),
      ),
    );
  }
}

extension AppThemeX on BuildContext {
  Color get bg => AppTheme.background;
  Color get card => AppTheme.card;
  Color get primaryBlue => AppTheme.primaryBlue;
  Color get infoBlue => AppTheme.infoBlue;
}
