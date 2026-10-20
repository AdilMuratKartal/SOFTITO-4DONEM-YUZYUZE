// Flutter Materyal tasarım paketini içe aktarıyoruz
import 'package:flutter/material.dart';
// Uygulama renk sabitleri ve 16:9 görsel ölçülerini içe aktarıyoruz
import '../../../core/constants/app_colors.dart';
// BuildContext üzerinden tema renklerine pratik erişim uzantısını içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Gösterilecek aracın veri modelini içe aktarıyoruz
import '../models/car_model.dart';
// Kiralama periyot türü enumını (günlük, haftalık, aylık) içe aktarıyoruz
import '../models/rental_period_type.dart';

/// TakeGO Standart İlan Kartı Bileşeni (CarCardWidget)
///
/// Kırmızı Çizgi Kuralı: İlan kartlarındaki görsel alanı kesinlikle sabit
/// 16:9 oranında (veya 180px) tutulur; dinamik taşma ve zıplama engellenir.
class CarCardWidget extends StatelessWidget {
  /// Gösterilecek araç modeli verisi
  final CarModel car;

  /// Aktif seçili kiralama periyodu (Günlük/Haftalık/Aylık fiyatlama için)
  final RentalPeriodType selectedPeriod;

  /// Karta tıklandığında detay sayfasına yönlendiren opsiyonel eylem
  final VoidCallback? onTap;

  // Sabit kurucu metot
  const CarCardWidget({
    super.key,
    required this.car,
    required this.selectedPeriod,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun ana build yapısı: Dış kart kutusu
    return Card(
      // Kartlar arasına yatayda 16, dikeyde 8 piksel dış kenar boşluğu
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Tıklama efektini (ripple) kart sınırlarına kırparak veren InkWell
      child: InkWell(
        // Karta tıklandığında dışarıdan gelen onTap fonksiyonunu çalıştır
        onTap: onTap,
        // Kart içeriğini dikeyde dizen Column bileşeni
        child: Column(
          // Elemanları sola yaslıyoruz
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sabit 16:9 Görsel ve Üst Rozetler Katmanı
            _FixedCardBanner(car: car),

            // 2. Fiyat, Başlık ve Özellikler Detay Katmanı
            _CardDetails(
              car: car,
              selectedPeriod: selectedPeriod,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 1: SABİT 16:9 GÖRSEL ALANI VE ROZETLER
// -----------------------------------------------------------------------------

/// Taşmaları önleyen sabit 16:9 görsel alanı ve üzerindeki rozetler
class _FixedCardBanner extends StatelessWidget {
  // Gösterilecek araç nesnesi
  final CarModel car;

  // Kurucu fonksiyon
  const _FixedCardBanner({required this.car});

  @override
  Widget build(BuildContext context) {
    // Tema renk şemasını alıyoruz
    final colors = context.colors;

    // Görsel kutusunu kesin 16:9 en-boy oranına kilitleyen AspectRatio widget'ı
    return AspectRatio(
      // Sabit 16.0 / 9.0 oranı (RenderFlex taşmasını tamamen engeller)
      aspectRatio: AppColors.standardAspectRatio,
      // Zemin ve rozetleri üst üste bindiren Stack bileşeni
      child: Stack(
        // Çocuk widget'ların tüm kutuyu kaplamasını sağlıyoruz
        fit: StackFit.expand,
        children: [
          // Zemin Silüet Dolgusu (Fotoğraf yüklenemese de kutu boyutu asla bozulmaz)
          Container(
            // Temaya uygun hafif arka plan dolgusu
            color: colors.surfaceContainerHighest,
            // Araç ikonunu ortaya yerleştiriyoruz
            child: Center(
              // Elektrikli ise şimşekli araç, değilse standart binek araç ikonu
              child: Icon(
                car.isElectric
                    ? Icons.electric_car_rounded
                    : Icons.directions_car_rounded,
                // İkon boyutu
                size: 54,
                // Yarı saydam gri ikon rengi
                color: colors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Sol Üst Rozet: Yakıt / Batarya Durum Göstergesi
          Positioned(
            top: 12,
            left: 12,
            child: _FuelStatusBadge(
              // Depo doluluk yüzdesi
              fuelPercent: car.fuelPercent,
              // Elektrikli araç bayrağı
              isElectric: car.isElectric,
            ),
          ),

          // Sağ Üst Rozet: Şanzıman ve Kullanıcıya Olan Mesafe Bilgisi
          Positioned(
            top: 12,
            right: 12,
            child: _SpecBadge(
              // Vites ve mesafe metnini birleştirip yazdırıyoruz
              label: '${car.transmission} • ${car.distanceKm} km',
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 2: BAŞLIK, FİYAT VE LOKASYON ALANI
// -----------------------------------------------------------------------------

/// Araç adı, seçili periyot tutarı ve lokasyon bilgilerini gösteren panel
class _CardDetails extends StatelessWidget {
  // Araç verisi
  final CarModel car;
  // Seçili periyot (Günlük/Haftalık/Aylık)
  final RentalPeriodType selectedPeriod;

  // Kurucu fonksiyon
  const _CardDetails({
    required this.car,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;
    // Seçili periyoda ait birim fiyatı model üzerinden hesaplıyoruz
    final activePrice = car.priceForPeriod(selectedPeriod);

    // Kart gövdesine 14 piksel iç boşluk uyguluyoruz
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Marka/Model Başlığı ve Dinamik Periyot Fiyatı Satırı
          Row(
            // Başlık sola, fiyat sağa hizalanır
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Araç adı uzunsa taşmasın diye Expanded içine alıyoruz
              Expanded(
                child: Text(
                  // Marka ve model birleşik tam adı
                  car.fullName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                  // Tek satıra kilitliyoruz
                  maxLines: 1,
                  // Taşarsa üç nokta koyuyoruz (...)
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Sağdaki fiyat etiketi (Örn: 2400 ₺ / Gün)
              Text(
                '${activePrice.toStringAsFixed(0)} ${selectedPeriod.unitSuffix}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          // Başlık ile alt satır arasına 8 piksel boşluk
          const SizedBox(height: 8),

          // Müsaitlik Tarih Aralığı ve Teslim Lokasyonu Satırı
          Row(
            children: [
              // Takvim ikonu
              Icon(
                Icons.calendar_month_outlined,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              // İkon ile metin arası 4 piksel boşluk
              const SizedBox(width: 4),
              // Müsaitlik tarih aralığı metni
              Text(
                '${car.availableFrom.day}.${car.availableFrom.month} - ${car.availableTo.day}.${car.availableTo.month}',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
              // Araya esnek boşluk koyarak lokasyonu en sağa itiyoruz
              const Spacer(),
              // Lokasyon pin ikonu
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              // İkon ile metin arası 2 piksel boşluk
              const SizedBox(width: 2),
              // Lokasyon metni (Örn: Kadıköy, İstanbul)
              Text(
                car.location,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// YARDIMCI ROZET BİLEŞENLERİ (Badges)
// -----------------------------------------------------------------------------

/// Benzin veya elektrik seviyesini renklendirerek gösteren rozet
class _FuelStatusBadge extends StatelessWidget {
  // Depo yüzdesi (%0 - %100)
  final int fuelPercent;
  // Elektrikli araç olup olmadığı
  final bool isElectric;

  // Kurucu fonksiyon
  const _FuelStatusBadge({
    required this.fuelPercent,
    required this.isElectric,
  });

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;
    // Depo %50 veya üzerindeyse iyi (yeşil), altındaysa kırmızı/uyarı
    final isGood = fuelPercent >= 50;
    // Durum rengini belirliyoruz
    final badgeColor = isGood ? colors.secondary : colors.error;

    // Rozet kapsayıcısı
    return Container(
      // Yatayda 10, dikeyde 5 piksel iç dolgu
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // Arka plan ve kenarlık tasarımı
      decoration: BoxDecoration(
        // Yarı saydam yüzey rengi
        color: colors.surface.withValues(alpha: 0.9),
        // Yuvarlatılmış hap (pill) şekli
        borderRadius: BorderRadius.circular(20),
        // İnce renkli durum çerçevesi
        border: Border.all(color: badgeColor, width: 1.2),
      ),
      // İkon ve metni yan yana dizen satır
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Elektrikli ise şimşek, benzinli ise pompa ikonu
          Icon(
            isElectric ? Icons.bolt_rounded : Icons.local_gas_station_rounded,
            size: 14,
            color: badgeColor,
          ),
          // İkon ile metin arası 4 piksel boşluk
          const SizedBox(width: 4),
          // Yüzde metni (Örn: %88 Şarj veya %65 Depo)
          Text(
            '%$fuelPercent ${isElectric ? 'Şarj' : 'Depo'}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Vites ve mesafe gibi özellikleri gösteren yarı saydam hap rozet
class _SpecBadge extends StatelessWidget {
  // Gösterilecek metin
  final String label;

  // Kurucu fonksiyon
  const _SpecBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Yarı saydam arka planlı hap kutusu
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
      ),
      // Etiket metni
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
        ),
      ),
    );
  }
}
