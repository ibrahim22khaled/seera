import 'package:flutter/material.dart';

class AppTheme {
  // Colors from the reference images (Dark Navy / Indigo theme)
  static const Color darkBg = Color(0xFF0B111D); // Deep dark background
  static const Color surfaceBg = Color(
    0xFF151E2D,
  ); // Slightly lighter for containers
  static const Color primaryBlue = Color(
    0xFF1D8BFF,
  ); // Bright blue user bubble / buttons
  static const Color aiBubbleBg = Color(0xFF1E293B); // AI bubble background
  static const Color textMain = Colors.white;
  static const Color textMuted = Color(0xFF94A3B8);
  static const String fontFamily = 'Cairo';

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: darkBg,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: primaryBlue,
        surface: surfaceBg,
        onSurface: textMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBg,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBg,
        hintStyle: const TextStyle(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  // We primarily use dark mode as seen in the images, but we can keep a light variant if needed.
  // For now, let's make lightTheme also look dark to be safe, or just stick to one for now.
  static ThemeData get lightTheme => darkTheme;
}
