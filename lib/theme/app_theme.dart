import 'package:flutter/material.dart';

class AppTheme {
  // Palette
  static const Color navy = Color(0xFF1A2340);
  static const Color navyLight = Color(0xFF253258);
  static const Color slate = Color(0xFF5C6B8A);
  static const Color amber = Color(0xFFF5A623);
  static const Color surface = Colors.white;
  static const Color background = Color(0xFFF0F2F7);

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: navy,
          onPrimary: Colors.white,
          secondary: amber,
          onSecondary: Colors.white,
          surface: surface,
          onSurface: navy,
          error: const Color(0xFFD32F2F),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.zero,
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: navy,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          bodyMedium: TextStyle(color: navy, fontSize: 14),
          bodySmall: TextStyle(color: slate, fontSize: 12),
        ),
        dividerColor: Color(0xFFE0E4EF),
        useMaterial3: true,
      );
}
