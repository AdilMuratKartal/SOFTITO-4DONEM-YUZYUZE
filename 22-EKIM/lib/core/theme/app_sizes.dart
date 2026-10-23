import 'package:flutter/material.dart';

/// Mindful Emerald Rhythm - Boyut, Boşluk ve Responsive Standartları
class AppSizes {
  // Spacing (Boşluk Değerleri)
  static const double space2xs = 2.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 20.0;
  static const double space2xl = 24.0;
  static const double space3xl = 32.0;

  // Border Radius (Köşe Yuvarlama)
  static const double radiusXs = 6.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusPill = 20.0;
  static const double radiusModal = 24.0;

  // İkon Boyutları (Icon Dimensions: Small, Medium, Large)
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 28.0;

  // İkon Kutu Boyutları (Icon Box: Small, Medium, Large)
  static const double iconBoxSm = 28.0;
  static const double iconBoxMd = 38.0;
  static const double iconBoxLg = 48.0;

  // Buton ve Aksiyon Alanları (Action Buttons)
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 44.0;
  static const double buttonHeightLg = 52.0;
  static const double touchTargetMin = 44.0; // Erişilebilirlik standardı

  // Takvim Şeridi (Calendar Strip)
  static const double calendarItemMinHeight = 62.0;

  // Alışkanlık Kartı (Habit Card Dimensions)
  static const double cardPadding = 14.0;
  static const double cardBorderRadius = 16.0;
  static const double cardMinHeightCheckmark = 74.0;
  static const double cardMinHeightCounter = 114.0;

  // İlerleme Çubuğu (Progress Indicator)
  static const double progressBarHeight = 6.0;
  static const double progressBarRadius = 6.0;

  // Responsive Kırılım Noktaları (Breakpoints)
  static const double breakpointCompact = 360.0; // Küçük ekran telefonlar
  static const double breakpointMedium = 600.0;  // Standart telefonlar / Katlanabilirler
  static const double breakpointLarge = 900.0;   // Tablet ve Masaüstü

  /// Ekran boyutuna göre kompakt olup olmadığını kontrol eder
  static bool isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < breakpointCompact;

  /// Ekran boyutuna göre tablet/masaüstü olup olmadığını kontrol eder
  static bool isLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointLarge;
}
