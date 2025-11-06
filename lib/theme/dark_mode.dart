import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF1A1C20),
    onSurface: Colors.white,
    primary: Color(0xFF3EBF7B),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF606060).withAlpha(100),
    onPrimaryContainer: Colors.grey.shade100,
  ),
);
