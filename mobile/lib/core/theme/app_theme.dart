import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366f1),
      primary: const Color(0xFF6366f1),
      secondary: const Color(0xFF10b981),
      background: const Color(0xFFF8FAFC),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.2),
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );
}
