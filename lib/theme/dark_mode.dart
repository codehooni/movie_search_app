import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.grey.shade200,
    surface: Color(0xFF1A1C20),
    primaryContainer: Color(0xFF2EAF7B),
    secondaryContainer: Color(0xFF606060),
    onPrimaryContainer: Colors.grey.shade100.withAlpha(150),
    onSecondaryContainer: Colors.white.withAlpha(130),
  ),
);
