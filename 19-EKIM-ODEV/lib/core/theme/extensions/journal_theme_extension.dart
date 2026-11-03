import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

class JournalThemeStyle extends ThemeExtension<JournalThemeStyle> {
  final double borderWidth; // double türünden borderWidth adlı değişkenimiz
  final Color borderColor; // Color türünden borderColor adlı değişkenimiz
  final double borderRadius; // double türünden borderRadius adlı değişkenimiz
  final List<BoxShadow> cardShadow; // List<BoxShadow> türünden cardShadow adlı değişkenimiz
  final TextStyle headerFont; // TextStyle türünden headerFont adlı değişkenimiz

  const JournalThemeStyle({ // Genel, sabit sınıf constructor'ı
    required this.borderWidth, // borderWidth parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.borderColor, // borderColor parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.borderRadius, // borderRadius parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.cardShadow, // cardShadow parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.headerFont, // headerFont parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  JournalThemeStyle copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    double? borderWidth,
    Color? borderColor,
    double? borderRadius,
    List<BoxShadow>? cardShadow,
    TextStyle? headerFont,
  }) {
    return JournalThemeStyle(
      borderWidth: borderWidth ?? this.borderWidth, // borderWidth alanına değer aktarıyoruz
      borderColor: borderColor ?? this.borderColor, // borderColor alanına değer aktarıyoruz
      borderRadius: borderRadius ?? this.borderRadius, // borderRadius alanına değer aktarıyoruz
      cardShadow: cardShadow ?? this.cardShadow, // cardShadow alanına değer aktarıyoruz
      headerFont: headerFont ?? this.headerFont, // headerFont alanına değer aktarıyoruz
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
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
