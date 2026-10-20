// Flutter materyal arayüz kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Kırmızı çizgi sabit yükseklik (140.0 px) ve renk sabitlerini içe aktarıyoruz
import '../../../core/constants/app_colors.dart';
// SnackBar ve renk paletine hızlı erişim sağlayan context uzantılarını içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';

/// TakeGO Sabit Boyutlu Fotoğraf Yükleme Alanı (ImageUploadPlaceholder)
///
/// Kırmızı Çizgi Kuralı: İlan verme formunda fotoğraf yükleme çerçevesi
/// daima sabit `height: 140.0` piksel olarak tutulur; arayüz taşması (overflow) engellenir.
class ImageUploadPlaceholder extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // ÖZELLİKLER (Properties)
  // ---------------------------------------------------------------------------

  /// Kullanıcı yükleme kutusuna dokunduğunda tetiklenecek opsiyonel tıklama işlevi
  final VoidCallback? onTap;

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: İsteğe bağlı onTap eylemi alır
  const ImageUploadPlaceholder({
    // Widget ağacında performans optimizasyonu sağlayan super.key
    super.key,
    // Tıklama işlevi parametresi (Opsiyonel)
    this.onTap,
  });

  // ---------------------------------------------------------------------------
  // ARAYÜZ OLUŞTURMA (Build)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // 1. Değişken: Aktif tema renk paleti
    final colors = context.colors;

    // Dokunma efektini (ripple) destekleyen InkWell bileşeni
    return InkWell(
      // Dışarıdan onTap verilmişse onu çalıştırır, verilmemişse varsayılan SnackBar gösterir
      onTap: onTap ??
          () {
            // Bilgilendirme snackbar'ı gösteriyoruz
            context.showTakeGoSnackBar(
              'Kamera ve galeri simülasyonu aktif (16:9 sabit format).',
            );
          },
      // Dokunma dalgalanma efekti için 16px köşe yuvarlaklığı
      borderRadius: BorderRadius.circular(16),
      // Sabit boyutlu yükleme çerçevesi
      child: Container(
        // Kırmızı çizgi kuralı: daima 140.0 px sabit yükseklik
        height: AppColors.uploadImageHeight,
        // Yatayda genişliği tamamen doldurur
        width: double.infinity,
        // Çerçevenin kutu süslemesi
        decoration: BoxDecoration(
          // Temanın yüzey rengi
          color: colors.surfaceContainer,
          // 16 piksel yuvarlatılmış köşeler
          borderRadius: BorderRadius.circular(16),
          // Primary rengin %50 şeffaflığıyla 1.5px kalınlığında modern sınır çizgisi
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        // Fotoğraf ekleme ikonu ve açıklamalarını dikeyde ortalayan Column
        child: Column(
          // Dikey eksende içerikleri tam merkeze hizalar
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Yuvarlak ikon kapsayıcısı
            Container(
              // İkon etrafında 12px iç boşluk
              padding: const EdgeInsets.all(12),
              // Dairesel mavi/mor arka plan dekorasyonu
              decoration: BoxDecoration(
                // Temanın ana renginin %10 opaklığı
                color: colors.primary.withValues(alpha: 0.1),
                // Dairesel kutu biçimi
                shape: BoxShape.circle,
              ),
              // Fotoğraf makinesi ekleme ikonu
              child: Icon(
                Icons.add_a_photo_outlined,
                color: colors.primary,
                size: 28,
              ),
            ),
            // İkon ile başlık arasına 10px dikey boşluk
            const SizedBox(height: 10),

            // Fotoğraf ekleme ana başlık metni
            Text(
              'Araç Fotoğrafı Ekle (16:9 Sabit)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: colors.onSurface,
              ),
            ),
            // Başlık ile alt açıklama arasına 4px dikey boşluk
            const SizedBox(height: 4),

            // Yardımcı yönlendirici alt metin
            Text(
              'Net çekilmiş ön çapraz görsel yükleyiniz',
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
