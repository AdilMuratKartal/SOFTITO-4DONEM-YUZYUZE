// Flutter'ın temel arayüz kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Tema renklerine context.colors ile pratik erişim sağlayan context uzantısını içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';

/// TakeGO Yakıt / Şarj Girdi Kaydırıcısı (FuelInputSlider)
///
/// Aracın teslim edileceği anki depo veya batarya doluluk seviyesini
/// %0 ile %100 arasında kaydırıcı (Slider) ile ayarlayan bileşendir.
class FuelInputSlider extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // ÖZELLİKLER (Properties)
  // ---------------------------------------------------------------------------

  /// Depo/batarya doluluk yüzdesini (%0 - %100) reaktif olarak tutan ValueNotifier
  final ValueNotifier<int> fuelPercentNotifier;

  /// Aracın elektrikli olup olmadığını belirten reaktif ValueNotifier
  final ValueNotifier<bool> isElectricNotifier;

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: Yakıt ve motor tipi bildiricilerini zorunlu olarak alır
  const FuelInputSlider({
    // Performans optimizasyonu için super.key
    super.key,
    // Yakıt yüzdesi bildiricisi (Zorunlu alan)
    required this.fuelPercentNotifier,
    // Elektrikli araç bildiricisi (Zorunlu alan)
    required this.isElectricNotifier,
  });

  // ---------------------------------------------------------------------------
  // ARAYÜZ OLUŞTURMA (Build)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // 1. Değişken: Aktif tema renk paleti
    final colors = context.colors;

    // Kaydırıcı kutusunun dış çerçevesi ve arka planı
    return Container(
      // Kutu içi 16px dolgu payı
      padding: const EdgeInsets.all(16),
      // Kutu dekorasyonu
      decoration: BoxDecoration(
        // Temanın yüzey rengi
        color: colors.surfaceContainer,
        // 16 piksel yuvarlak köşeler
        borderRadius: BorderRadius.circular(16),
        // Çerçeve kenarlık çizgisi
        border: Border.all(color: colors.outlineVariant),
      ),
      // Başlık satırı ve kaydırıcı çubuğu dikeyde sıralayan Column
      child: Column(
        // Sola dayalı hizalama
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Satır: Başlık ve Anlık Yüzde Göstergesi
          Row(
            // İki ucu yatayda birbirine zıt köşelere yayıyoruz
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sol Kısım: Araç tipine göre dinamik başlık metni (Batarya / Depo)
              ValueListenableBuilder<bool>(
                // Motor tipini dinleyen bildirici
                valueListenable: isElectricNotifier,
                builder: (context, isElectric, _) {
                  // Elektrikli ise "Teslim Batarya Seviyesi", benzinli ise "Teslim Depo Seviyesi"
                  return Text(
                    isElectric ? 'Teslim Batarya Seviyesi' : 'Teslim Depo Seviyesi',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  );
                },
              ),
              // Sağ Kısım: Renkli ve kalın anlık yüzde metni (Örn: %75)
              ValueListenableBuilder<int>(
                // Yakıt yüzdesini dinleyen bildirici
                valueListenable: fuelPercentNotifier,
                builder: (context, percent, _) {
                  // 1. Değişken: Yüzde 50 ve üzeri ise güvenli kabul edilir
                  final isGood = percent >= 50;
                  // 2. Değişken: Güvenliyse turkuaz/yeşil, düşükse hata rengi
                  final statusColor = isGood ? colors.secondary : colors.error;
                  // Anlık yüzdeyi gösteren Text
                  return Text(
                    '%$percent',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: statusColor,
                    ),
                  );
                },
              ),
            ],
          ),

          // 2. Satır: Değer Seçim Kaydırıcısı (Slider)
          ValueListenableBuilder<int>(
            // Yakıt yüzdesini dinleyen bildirici
            valueListenable: fuelPercentNotifier,
            builder: (context, percent, _) {
              // 0 ile 100 arasında değer seçtiren materyal kaydırıcı
              return Slider(
                // Kaydırıcının mevcut ondalıklı değeri
                value: percent.toDouble(),
                // Minimum değer: %0
                min: 0,
                // Maksimum değer: %100
                max: 100,
                // 20 eşit adıma bölerek %5'lik hassas adımlarla kaydırma sağlar
                divisions: 20,
                // Kaydırıcının aktif çizgi ve topuz rengi (%50 üzeri yeşil/turkuaz, altı kırmızı)
                activeColor: percent >= 50 ? colors.secondary : colors.error,
                // Kullanıcı kaydırdıkça yeni tam sayı değerini bildiriciye aktaran fonksiyon
                onChanged: (val) {
                  // Değeri tam sayıya yuvarlayarak reaktif bildiriciyi güncelliyoruz
                  fuelPercentNotifier.value = val.round();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
