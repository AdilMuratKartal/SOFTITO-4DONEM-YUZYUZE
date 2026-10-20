// Flutter'ın temel materyal tasarım widget kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Kırmızı çizgi sabit yükseklik (260.0 px) ve renk sabitlerini içe aktarıyoruz
import '../../../core/constants/app_colors.dart';
// BuildContext üzerinden tema renklerine pratik erişim sağlayan extension'ı içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Detayları gösterilecek aracın veri modelini içe aktarıyoruz
import '../../car_listing/models/car_model.dart';

/// TakeGO Sabit Detay Görsel Banner'ı (CarImageBanner)
///
/// Kırmızı Çizgi Kuralı: İlan detay sayfasında kapak görseli alanı
/// daima sabit `height: 260.0` piksel ve `width: double.infinity` olarak
/// konumlandırılır; kayma veya taşma (RenderFlex overflow) yaşanması engellenir.
class CarImageBanner extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // ÖZELLİKLER (Properties)
  // ---------------------------------------------------------------------------

  /// Banner üzerinde plaka, yıl, mesafe ve tip bilgileri gösterilecek araç modeli
  final CarModel car;

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu: Araç modelini zorunlu parametre olarak alır
  const CarImageBanner({
    // Performans için super.key parametresi
    super.key,
    // Gösterilecek araç nesnesi (Zorunlu alan)
    required this.car,
  });

  // ---------------------------------------------------------------------------
  // ARAYÜZ OLUŞTURMA (Build)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // 1. Değişken: Aktif tema renk paleti
    final colors = context.colors;

    // Kırmızı Çizgi Kuralı gereği sabit 260.0 px yükseklikte SizedBox kapsayıcısı
    return SizedBox(
      // Kırmızı çizgi kuralı sabit yüksekliği (260.0 piksel)
      height: AppColors.detailImageHeight,
      // Genişlik yatayda ekranı tamamen kaplar
      width: double.infinity,
      // İç katmanları üst üste bindirmek için Stack widget'ı
      child: Stack(
        // Çocuk widget'ları Stack alanını tamamen dolduracak şekilde esnetiyoruz
        fit: StackFit.expand,
        children: [
          // -------------------------------------------------------------------
          // KATMAN 1: Zemin Silüet Dolgusu (Temaya uyumlu kokpit grisi)
          // -------------------------------------------------------------------
          Container(
            // Yüzey arka plan dolgu rengi
            color: colors.surfaceContainerHighest,
            // İkonu merkeze yerleştiren Center
            child: Center(
              // Elektrikli araç ise şarjlı araba ikonu, benzinli ise standart araba ikonu
              child: Icon(
                // Şartlı ikon seçimi
                car.isElectric
                    ? Icons.electric_car_rounded
                    : Icons.directions_car_rounded,
                // Büyük 80px silüet boyutu
                size: 80,
                // %50 şeffaflık ile şık ve dikkat dağıtmayan kokpit silüeti
                color: colors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // KATMAN 2: Alt Gölgelendirme Gradyanı (Okunabilirlik artırıcı)
          // -------------------------------------------------------------------
          Positioned(
            // Banner'ın en alt tabanına hizalama
            bottom: 0,
            // Sol kenara yaslama
            left: 0,
            // Sağ kenara yaslama
            right: 0,
            // 100 piksel yükseklikte geçiş alanı
            height: 100,
            // Gradyan boyamasını yapan DecoratedBox
            child: DecoratedBox(
              // Gradyan kutu dekorasyonu
              decoration: BoxDecoration(
                // Alttan yukarıya doğru koyudan şeffafa uzanan dikey gradyan
                gradient: LinearGradient(
                  // Gradyan başlangıç noktası: alt merkez
                  begin: Alignment.bottomCenter,
                  // Gradyan bitiş noktası: üst merkez
                  end: Alignment.topCenter,
                  // Gradyan renk geçişleri
                  colors: [
                    // Altta %95 opak temaya uygun yüzey rengi
                    colors.surface.withValues(alpha: 0.95),
                    // Üstte tamamen şeffaf bitiş
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // KATMAN 3: Sol Alt Köşe: Plaka ve Model Yılı Rozeti
          // -------------------------------------------------------------------
          Positioned(
            // Alt kenardan 16 piksel yukarıda
            bottom: 16,
            // Sol kenardan 16 piksel içeride
            left: 16,
            // Rozet kutusu
            child: Container(
              // Rozet içi dolgusu: yatayda 12px, dikeyde 6px
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              // Rozet dekorasyonu
              decoration: BoxDecoration(
                // Yarı saydam arka plan dolgusu
                color: colors.surface.withValues(alpha: 0.9),
                // 10px yuvarlak köşeler
                borderRadius: BorderRadius.circular(10),
                // İnce kenarlık çizgisi
                border: Border.all(color: colors.outlineVariant),
              ),
              // Plaka ve üretim yılı metni (Örn: 34 TGO 101 • 2024 Model)
              child: Text(
                '${car.plate} • ${car.year} Model',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // KATMAN 4: Sağ Alt Köşe: Konum ve Mesafe Rozeti
          // -------------------------------------------------------------------
          Positioned(
            // Alt kenardan 16 piksel yukarıda
            bottom: 16,
            // Sağ kenardan 16 piksel içeride
            right: 16,
            // Rozet kapsayıcısı
            child: Container(
              // Rozet içi dolgusu
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              // Rozet dekorasyonu
              decoration: BoxDecoration(
                // Yarı saydam arka plan rengi
                color: colors.surface.withValues(alpha: 0.9),
                // 10px yuvarlak köşeler
                borderRadius: BorderRadius.circular(10),
                // Kenarlık çizgisi
                border: Border.all(color: colors.outlineVariant),
              ),
              // Konum ikonu ve mesafe metnini yan yana dizen satır
              child: Row(
                // İçerik kadar yer kaplamasını sağlayan min boyutu
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Konum oku ikonu
                  Icon(
                    Icons.near_me_rounded,
                    size: 14,
                    color: colors.primary,
                  ),
                  // İkon ile metin arasına 4px yatay boşluk
                  const SizedBox(width: 4),
                  // Mesafe bilgisi metni (Örn: 2.4 km yakında)
                  Text(
                    '${car.distanceKm} km yakında',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
