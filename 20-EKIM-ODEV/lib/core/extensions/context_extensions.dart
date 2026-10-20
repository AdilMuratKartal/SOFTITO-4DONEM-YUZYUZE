// Flutter materyal arayüz kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';

/// BuildContext için TakeGO Pratik Erişim Uzantıları (ContextExtensions)
///
/// Widget ağacında tema renklerine, boyutlara ve bildirim pencerelerine
/// temiz, tip güvenli ve kod tekrarını önleyen bir biçimde ulaşmayı sağlar.
extension ContextExtensions on BuildContext {
  // ---------------------------------------------------------------------------
  // TEMA VE RENK KISAYOLLARI
  // ---------------------------------------------------------------------------

  /// Aktif ThemeData nesnesine hızlı erişim sağlar
  ThemeData get theme => Theme.of(this);

  /// Aktif ColorScheme (Cyber Drive renk paleti) nesnesine doğrudan erişim sağlar
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Tipografi ve metin stillerine hızlı erişim sağlar
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ---------------------------------------------------------------------------
  // EKRAN BOYUT KISAYOLLARI (Responsive Helpers)
  // ---------------------------------------------------------------------------

  /// Cihaz ekranının piksel cinsinden toplam genişliğini döndürür
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Cihaz ekranının piksel cinsinden toplam yüksekliğini döndürür
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // ---------------------------------------------------------------------------
  // BİLDİRİM VE DİYALOG KISAYOLLARI
  // ---------------------------------------------------------------------------

  /// TakeGO standartlarında şık ve yüzen (floating) SnackBar bildirimi gösterir
  void showTakeGoSnackBar(
    // Gösterilecek bildirim metni (Zorunlu)
    String message, {
    // Hata durumunda kırmızı renk kullanılıp kullanılmayacağı (Varsayılan: false)
    bool isError = false,
    // Bildirimin ekranda kalma süresi (Varsayılan: 3 saniye)
    Duration duration = const Duration(seconds: 3),
  }) {
    // Varsa önceki açık bildirimleri ekrandan gizliyoruz
    ScaffoldMessenger.of(this).hideCurrentSnackBar();

    // Yeni TakeGO SnackBar bildirimini ekranda gösteriyoruz
    ScaffoldMessenger.of(this).showSnackBar(
      // Modern yüzen bildirim nesnesi
      SnackBar(
        // Bildirim metin içeriği
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        // Hata ise error rengi, normal ise primary mavi renk
        backgroundColor: isError ? colors.error : colors.primary,
        // Alttan kopuk havada yüzen modern davranış
        behavior: SnackBarBehavior.floating,
        // 12 piksel yuvarlatılmış köşeler
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Ekranda kalış süresi
        duration: duration,
      ),
    );
  }
}
