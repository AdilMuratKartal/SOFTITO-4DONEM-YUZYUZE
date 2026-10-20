import 'package:flutter/material.dart';

abstract class JournalClassicColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1B263B),
    onPrimary: Color(0xFFFFFDF8),
    secondary: Color(0xFFD4A373),
    onSecondary: Color(0xFF1B263B),
    surface: Color(0xFFFFFDF8),
    onSurface: Color(0xFF1B263B),
    error: Color(0xFF8A3324),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFE6DFD5),
    onPrimary: Color(0xFF181512),
    secondary: Color(0xFFC69C6D),
    onSecondary: Color(0xFF181512),
    surface: Color(0xFF26211C),
    onSurface: Color(0xFFE6DFD5),
    error: Color(0xFFD48C46),
    onError: Color(0xFF000000),
  );
}
