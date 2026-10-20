import 'package:flutter/material.dart';

class JournalThemeStyle extends ThemeExtension<JournalThemeStyle> {
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final List<BoxShadow> cardShadow;
  final TextStyle headerFont;

  const JournalThemeStyle({
    required this.borderWidth,
    required this.borderColor,
    required this.borderRadius,
    required this.cardShadow,
    required this.headerFont,
  });

  @override
  JournalThemeStyle copyWith({
    double? borderWidth,
    Color? borderColor,
    double? borderRadius,
    List<BoxShadow>? cardShadow,
    TextStyle? headerFont,
  }) {
    return JournalThemeStyle(
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      cardShadow: cardShadow ?? this.cardShadow,
      headerFont: headerFont ?? this.headerFont,
    );
  }

  @override
  JournalThemeStyle lerp(ThemeExtension<JournalThemeStyle>? other, double t) {
    if (other is! JournalThemeStyle) return this;
    return JournalThemeStyle(
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
      cardShadow: cardShadow,
      headerFont: TextStyle.lerp(headerFont, other.headerFont, t) ?? headerFont,
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null || b == null) return a;
    return a + (b - a) * t;
  }
}
