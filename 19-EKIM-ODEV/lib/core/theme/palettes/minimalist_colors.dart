import 'package:flutter/material.dart';

abstract class MinimalistColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1A1A1A),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF4A6FA5),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A1A1A),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFF2F2F7),
    onPrimary: Color(0xFF0F0F10),
    secondary: Color(0xFF64D2FF),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFF1C1C1E),
    onSurface: Color(0xFFF2F2F7),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
  );
}
