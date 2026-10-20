import 'package:flutter/material.dart';

abstract class RubberHoseColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF111111),
    onPrimary: Color(0xFFFFF8EA),
    secondary: Color(0xFFC84B31),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFF8EA),
    onSurface: Color(0xFF111111),
    error: Color(0xFFC84B31),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFEDE0C8),
    onPrimary: Color(0xFF12100E),
    secondary: Color(0xFFB58A63),
    onSecondary: Color(0xFF12100E),
    surface: Color(0xFF231F1B),
    onSurface: Color(0xFFEDE0C8),
    error: Color(0xFF9B2226),
    onError: Color(0xFFFFFFFF),
  );
}
