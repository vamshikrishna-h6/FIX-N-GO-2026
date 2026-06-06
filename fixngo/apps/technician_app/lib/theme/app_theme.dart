import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color bg = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF131318);
  static const Color card = Color(0xFF1C1C24);
  static const Color cardHigh = Color(0xFF22222C);
  static const Color red = Color(0xFFFF3B30);
  static const Color redDark = Color(0xFFCC2E26);
  static const Color orange = Color(0xFFFF6B35);
  static const Color green = Color(0xFF00C853);
  static const Color greenDark = Color(0xFF00A843);
  static const Color yellow = Color(0xFFFFD60A);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF888898);
  static const Color greyLight = Color(0xFFAAAAAB);
  static const Color border = Color(0xFF2A2A35);
  static const Color online = Color(0xFF00C853);
  static const Color offline = Color(0xFF888898);
}

class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> red = [
    BoxShadow(
      color: Color(0x55FF3B30),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> green = [
    BoxShadow(
      color: Color(0x5500C853),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.green,
        secondary: AppColors.orange,
        surface: AppColors.surface,
        onPrimary: AppColors.white,
        onSurface: AppColors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
          headlineLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: AppColors.greyLight),
          bodyMedium: TextStyle(color: AppColors.greyLight),
          labelLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shadowColor: Colors.transparent,
      ).copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.green),
        ),
      ),
    );
  }
}