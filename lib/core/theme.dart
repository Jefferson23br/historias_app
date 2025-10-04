import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFFFF7B7B);     
  static const secondary = Color(0xFF6EC3FF);   
  static const accent = Color(0xFFFFD66E);      
  static const bgColor = Color(0xFFFFF9F2);     
  static const textColor = Color(0xFF333333);   
  static const success = Color(0xFF4CAF50);     
  static const error = Color(0xFFE57373);       

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: bgColor,
    primaryColor: primary,
    
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: Colors.white,
      error: error,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textColor,
        fontSize: 14,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF8F8F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 2),
      ),
    ),
    
    useMaterial3: true,
  );
}