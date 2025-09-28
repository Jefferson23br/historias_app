import 'package:flutter/material.dart';

class AppTheme {
  // Cores do app - alegres e infantis
  static const primary = Color(0xFFFF7B7B);     // Coral suave
  static const secondary = Color(0xFF6EC3FF);   // Azul claro
  static const accent = Color(0xFFFFD66E);      // Amarelo
  static const bgColor = Color(0xFFFFF9F2);     // Creme
  static const textColor = Color(0xFF333333);   // Cinza escuro
  static const success = Color(0xFF4CAF50);     // Verde
  static const error = Color(0xFFE57373);       // Vermelho suave

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
    
    // Tipografia arredondada e amigável
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
    
    // Botões arredondados
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
    
    // Campos de texto arredondados
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