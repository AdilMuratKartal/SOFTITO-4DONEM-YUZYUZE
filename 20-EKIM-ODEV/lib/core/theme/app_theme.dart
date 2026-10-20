// Flutter'ın temel materyal tasarım kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Kurumsal Cyber Drive paleti renk ve boyut sabitlerini içe aktarıyoruz
import '../constants/app_colors.dart';

/// TakeGO Kurumsal Tema Yapılandırması (AppTheme)
///
/// Material 3 tasarım standardına uygun olarak hazırlanan
/// Clean Mobility Light (Gündüz Sürüşü) ve OLED Cockpit Dark (Gece Sürüşü)
/// temalarının tüm bileşen stillerini merkezi olarak belirler.
class AppTheme {
  // Kurucu gizlenmiştir; tüm tema nesneleri statiktir ve doğrudan erişilir.
  AppTheme._();

  // ---------------------------------------------------------------------------
  // GÜNDÜZ MODU: Clean Mobility Light Teması
  // ---------------------------------------------------------------------------

  /// Gündüz sürüşü için temiz, aydınlık ve ferah tema konfigürasyonu
  static ThemeData get lightTheme {
    // 1. Değişken: Material 3 aydınlık renk şeması eşleştirmesi
    const colorScheme = ColorScheme.light(
      // Ana birincil mavi vurgu rengi
      primary: AppColors.lightPrimary,
      // İkincil yeşil durum ve kilit rengi
      secondary: AppColors.lightSecondary,
      // Kart ve diyalogların beyaz yüzey dolgusu
      surface: AppColors.lightSurface,
      // Resim yokken gösterilen açık gri silüet dolgusu
      surfaceContainerHighest: AppColors.lightImagePlaceholder,
      // Yüzey üstündeki koyu antrasit metin rengi
      onSurface: AppColors.lightTextPrimary,
      // İkincil gri açıklama metin rengi
      onSurfaceVariant: AppColors.lightTextSecondary,
      // İnce kenarlık ve ayırıcı çizgi rengi
      outlineVariant: AppColors.lightBorder,
      // Hata ve kritik durum kırmızı rengi
      error: AppColors.lightError,
    );

    // Aydınlık ThemeData nesnesini oluşturup döndürüyoruz
    return ThemeData(
      // Modern Material 3 tasarım standardını etkinleştiriyoruz
      useMaterial3: true,
      // Tema aydınlık parlaklık seviyesi
      brightness: Brightness.light,
      // Tanımlanan aydınlık renk şeması
      colorScheme: colorScheme,
      // Ekran arka plan zemin rengi (kırık beyaz)
      scaffoldBackgroundColor: AppColors.lightBackground,

      // Üst Başlık Çubuğu (AppBar) Stili
      appBarTheme: const AppBarTheme(
        // Başlık çubuğu zemin rengi
        backgroundColor: AppColors.lightSurface,
        // İkon ve metin ön plan rengi
        foregroundColor: AppColors.lightTextPrimary,
        // Düz ve gölgesiz modern görünüm
        elevation: 0,
        // Kaydırıldığında oluşan hafif gölge
        scrolledUnderElevation: 1,
        // Başlığı sola dayalı hizala
        centerTitle: false,
        // Başlık metni yazı tipi stili
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),

      // Kart Bileşeni (Card) Varsayılan Teması
      cardTheme: CardThemeData(
        // Kart zemin rengi
        color: AppColors.lightSurface,
        // Sıfır yükseklik (gölgesiz)
        elevation: 0,
        // Kenar taşmalarını kesen anti-alias kırpma
        clipBehavior: Clip.antiAlias,
        // Kart kenarlık şekli ve köşe yuvarlaklığı
        shape: RoundedRectangleBorder(
          // 16 piksel yuvarlatılmış köşeler
          borderRadius: BorderRadius.circular(AppColors.cardBorderRadius),
          // İnce kart çerçeve çizgisi
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),

      // SegmentedButton (Periyot Seçici) Stili
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          // 12px yuvarlatılmış hap biçimi
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          // Buton içi metin stili
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ),

      // Birincil Buton (FilledButton) Stili
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          // Buton arka plan rengi: primary mavi
          backgroundColor: AppColors.lightPrimary,
          // Buton yazı ve ikon rengi: beyaz
          foregroundColor: Colors.white,
          // Minimum 50px ergonomik dokunma yüksekliği
          minimumSize: const Size.fromHeight(50),
          // 14 piksel yuvarlatılmış buton köşesi
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          // Kalın ve okunaklı buton yazı tipi
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),

      // Form Girdi Alanı (InputDecoration) Stili
      inputDecorationTheme: InputDecorationTheme(
        // Arka plan rengiyle doldurulsun
        filled: true,
        // Giriş kutusu zemin rengi
        fillColor: AppColors.lightSurface,
        // Kutu içi dolgu boşluğu
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        // Standart kenarlık stili
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        // Etkin (odaklanılmamış) kenarlık stili
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        // Odaklanılmış (aktif) kenarlık stili
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GECE MODU: OLED Cockpit Dark Teması
  // ---------------------------------------------------------------------------

  /// Gece sürüşü için derin OLED siyahı ve neon mavi detaylı kokpit teması
  static ThemeData get darkTheme {
    // 1. Değişken: Material 3 karanlık renk şeması eşleştirmesi
    const colorScheme = ColorScheme.dark(
      // Gece sürüşünde parlayan neon mavi vurgu rengi
      primary: AppColors.darkPrimary,
      // Gece modunda parlayan fosforlu yeşil onay rengi
      secondary: AppColors.darkSecondary,
      // Derin kokpit koyu yüzey dolgu rengi
      surface: AppColors.darkSurface,
      // Koyu antrasit fotoğraf silüet dolgusu
      surfaceContainerHighest: AppColors.darkImagePlaceholder,
      // Yumuşak açık beyaz metin rengi
      onSurface: AppColors.darkTextPrimary,
      // Gümüş gri ikincil metin rengi
      onSurfaceVariant: AppColors.darkTextSecondary,
      // Loş kenarlık ve çerçeve çizgisi rengi
      outlineVariant: AppColors.darkBorder,
      // Gece modu hata kırmızı rengi
      error: AppColors.darkError,
    );

    // Gece modu ThemeData nesnesini oluşturup döndürüyoruz
    return ThemeData(
      // Modern Material 3 standardı
      useMaterial3: true,
      // Tema karanlık parlaklık seviyesi
      brightness: Brightness.dark,
      // Tanımlanan karanlık renk şeması
      colorScheme: colorScheme,
      // OLED ekranlar için saf siyah arka plan zemin rengi
      scaffoldBackgroundColor: AppColors.darkBackground,

      // Gece Modu Üst Başlık Çubuğu Stili
      appBarTheme: const AppBarTheme(
        // Kokpit antrasiti başlık zemin rengi
        backgroundColor: AppColors.darkSurface,
        // Beyaz metin ve ikon rengi
        foregroundColor: AppColors.darkTextPrimary,
        // Sıfır gölge
        elevation: 0,
        // Kaydırmada hafif ayırıcı gölge
        scrolledUnderElevation: 1,
        // Başlığı sola dayalı hizala
        centerTitle: false,
        // Başlık yazı stili
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),

      // Gece Modu Kart Bileşeni Stili
      cardTheme: CardThemeData(
        // Koyu kart zemin rengi
        color: AppColors.darkSurface,
        // Sıfır yükseklik
        elevation: 0,
        // Kenar taşmalarını kesen anti-alias kırpma
        clipBehavior: Clip.antiAlias,
        // Kart kenarlık şekli ve köşe yuvarlaklığı
        shape: RoundedRectangleBorder(
          // 16 piksel yuvarlatılmış köşeler
          borderRadius: BorderRadius.circular(AppColors.cardBorderRadius),
          // Loş kokpit çerçeve çizgisi
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),

      // Gece Modu SegmentedButton Stili
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          // 12px yuvarlatılmış köşeler
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          // Buton içi metin stili
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ),

      // Gece Modu Birincil Buton Stili
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          // Parlak neon mavi buton rengi
          backgroundColor: AppColors.darkPrimary,
          // Beyaz buton metni
          foregroundColor: Colors.white,
          // 50px sabit ergonomik yükseklik
          minimumSize: const Size.fromHeight(50),
          // 14 piksel yuvarlatılmış buton köşesi
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          // Kalın buton yazı tipi
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),

      // Gece Modu Form Girdi Alanı Stili
      inputDecorationTheme: InputDecorationTheme(
        // Arka plan rengiyle doldurulsun
        filled: true,
        // Giriş alanı koyu zemin rengi
        fillColor: AppColors.darkSurface,
        // İç dolgu boşluğu
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        // Standart kenarlık stili
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        // Etkin (odaklanılmamış) kenarlık stili
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        // Odaklanılmış (aktif) kenarlık stili
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
        ),
      ),
    );
  }
}
