import 'package:flutter/material.dart';

abstract class NeoBrutalistColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFFF70A6),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFFFFE500),
    onSurface: Color(0xFF000000),
    error: Color(0xFFFF4365),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFE500),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFFCCFF00),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFF1E1E24),
    onSurface: Color(0xFFFFFFFF),
    error: Color(0xFFFF4365),
    onError: Color(0xFFFFFFFF),
  );
}
