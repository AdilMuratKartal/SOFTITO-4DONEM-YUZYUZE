import 'package:flutter/material.dart';

abstract class HandDrawnColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2B2D42),
    onPrimary: Color(0xFFF4EBD9),
    secondary: Color(0xFFF4A261),
    onSecondary: Color(0xFF2B2D42),
    surface: Color(0xFFFFF9DE),
    onSurface: Color(0xFF2B2D42),
    error: Color(0xFFE76F51),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFECEFF1),
    onPrimary: Color(0xFF1E2229),
    secondary: Color(0xFFFDE68A),
    onSecondary: Color(0xFF1E2229),
    surface: Color(0xFF2C313C),
    onSurface: Color(0xFFECEFF1),
    error: Color(0xFFFCA5A5),
    onError: Color(0xFF1E2229),
  );
}
