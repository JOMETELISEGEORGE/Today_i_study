import 'package:flutter/material.dart';

class OceanTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.light,

    // Soft ocean background (light but not bright)
    scaffoldBackgroundColor: const Color(0xFFF5F8FA),

    // Muted ocean blue
    primaryColor: const Color(0xFF4A90A4),

    // AppBar styling
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4A90A4),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // Text colors (soft slate)
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Color(0xFF243A44),
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF243A44),
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        color: Color(0xFF5F7A86),
        fontSize: 14,
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      hintStyle: const TextStyle(color: Color(0xFF8FA3AD)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90A4),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
  );
}
