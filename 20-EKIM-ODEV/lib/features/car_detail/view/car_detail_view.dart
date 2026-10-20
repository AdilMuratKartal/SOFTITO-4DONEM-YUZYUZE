// Flutter Materyal kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Context extension ile tema renklerine hızlı erişimi içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Günlük, haftalık, aylık çip seçici bileşenini içe aktarıyoruz
import '../../car_listing/widget/period_filter_chips.dart';
// Kiralama periyot türü enumını içe aktarıyoruz
import '../../car_listing/models/rental_period_type.dart';
// İlan detay ve fiyat hesaplama denetleyicisini içe aktarıyoruz
import '../controller/car_detail_controller.dart';
// Sabit 260px kapak görseli banner'ını içe aktarıyoruz
import '../widget/car_image_banner.dart';
// Yakıt / batarya grafiksel ilerleme çubuğu bileşenini içe aktarıyoruz
import '../widget/fuel_gauge_widget.dart';
// Dinamik fiyat dökümü ve kasko hesaplayıcı kartını içe aktarıyoruz
import '../widget/price_breakdown_card.dart';

/// TakeGO İlan Detay ve Rezervasyon Ekranı (CarDetailView)
///
/// Sabit 260px kapak görseli, araç özellikleri, benzin göstergesi,
/// dinamik fiyat dökümü ve dijital anahtar rezervasyon butonunu barındırır.
class CarDetailView extends StatelessWidget {
  // İlan detay sayfasının durum ve hesaplama kontrolcüsü
  final CarDetailController controller;

  // Kullanıcı 'Rezervasyon Yap' butonuna bastığında çağrılan eylem
  final VoidCallback? onBookAndOpenKey;

  // Sabit kurucu metot
  const CarDetailView({
    super.key,
    required this.controller,
    this.onBookAndOpenKey,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun ana sayfa düzeni
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlıkta aracın marka ve model tam adını gösteriyoruz
        title: Text(controller.car.fullName),
      ),
      // Sayfa içeriğini dikeyde kaydırılabilir kılan SingleChildScrollView
      body: SingleChildScrollView(
        // Elemanları dikeyde alt alta dizen Column
        child: Column(
          // Elemanları sola yaslıyoruz
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sabit 260px Yükseklikli Kapak Görseli Banner'ı
            CarImageBanner(car: controller.car),

            // 2. Başlık, Lokasyon ve Temel Donanım Rozetleri
            _DetailHeader(controller: controller),

            // 3. Yakıt / Batarya Gösterge Kartı
            Padding(
              // Kenarlardan 16 yatay, 8 dikey boşluk
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // Yakıt ilerleme göstergesi
              child: FuelGaugeWidget(
                // Depo doluluk yüzdesi
                fuelPercent: controller.car.fuelPercent,
                // Elektrikli araç durumu
                isElectric: controller.car.isElectric,
              ),
            ),

            // 4. Kiralama Periyodu Seçici Çipleri (Günlük/Haftalık/Aylık)
            _PeriodSelector(controller: controller),

            // 5. Dinamik Fiyat Dökümü ve Süre Belirleme Kartı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PriceBreakdownCard(controller: controller),
            ),

            // 6. Araç Açıklaması ve Donanım Çipleri Alanı
            _FeaturesSection(controller: controller),

            // Alt barın içeriği örtmesini önlemek için 100 piksel alt boşluk
            const SizedBox(height: 100),
          ],
        ),
      ),
      // Ekranın en altına sabitlenen Rezervasyon Çubuğu
      bottomNavigationBar: _BookingBottomBar(
        // Kontrolcü referansı
        controller: controller,
        // Rezervasyon butonuna basıldığında tetiklenen eylem
        onBookPressed: onBookAndOpenKey,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 1: BAŞLIK VE ÖZELLİK ROZETLERİ
// -----------------------------------------------------------------------------

// Araç adını, mesafesini ve temel özellik rozetlerini (şanzıman, koltuk, yıl vb.) çizen bileşen
class _DetailHeader extends StatelessWidget {
  // Detay kontrolcüsü
  final CarDetailController controller;

  // Kurucu fonksiyon
  const _DetailHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;
    // Araç modelini alıyoruz
    final car = controller.car;

    // Başlık etrafına iç boşluk uyguluyoruz
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Büyük ve kalın araç marka-model başlığı
          Text(
            car.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          // 4 piksel dikey boşluk
          const SizedBox(height: 4),

          // Lokasyon ve kullanıcıya olan mesafe satırı
          Row(
            children: [
              // Lokasyon pini ikonu
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: colors.primary,
              ),
              // 4 piksel yatay boşluk
              const SizedBox(width: 4),
              // Konum ve mesafe metni
              Text(
                '${car.location} • ${car.distanceKm} km uzaklıkta',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          // 12 piksel dikey boşluk
          const SizedBox(height: 12),

          // Donanım rozetlerini esnek dizen Wrap bileşeni
          Wrap(
            // Rozetler arası yatay boşluk
            spacing: 8,
            // Satır taşmalarında dikey boşluk
            runSpacing: 8,
            children: [
              // 1. Rozet: Şanzıman (Otomatik / Manuel)
              _badge(Icons.settings_outlined, car.transmission, colors),
              // 2. Rozet: Koltuk sayısı
              _badge(Icons.people_outline, '${car.seatCount} Koltuk', colors),
              // 3. Rozet: Model yılı
              _badge(Icons.calendar_today_outlined, '${car.year} Model', colors),
              // 4. Rozet: Plaka
              _badge(Icons.badge_outlined, car.plate, colors),
            ],
          ),
        ],
      ),
    );
  }

  // Ortak rozet kutucuğu üreten yardımcı fonksiyon
  Widget _badge(IconData icon, String text, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 2: PERİYOT SEÇİCİ BÖLÜMÜ
// -----------------------------------------------------------------------------

// Kiralama periyodunu (Günlük/Haftalık/Aylık) dinleyen ve değiştiren alan
class _PeriodSelector extends StatelessWidget {
  // Kontrolcü nesnesi
  final CarDetailController controller;

  // Kurucu fonksiyon
  const _PeriodSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Seçili periyot bildiricisini dinliyoruz
    return ValueListenableBuilder<RentalPeriodType>(
      valueListenable: controller.selectedPeriodNotifier,
      builder: (context, period, _) {
        // Çip bileşeni üzerinden periyot seçimini bağlıyoruz
        return PeriodFilterChips(
          selectedPeriod: period,
          onPeriodChanged: (newPeriod) {
            controller.setPeriod(newPeriod);
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 3: DONANIM VE AÇIKLAMA BÖLÜMÜ
// -----------------------------------------------------------------------------

// Aracın detaylı açıklama metnini ve donanım etiketlerini listeleyen bileşen
class _FeaturesSection extends StatelessWidget {
  // Kontrolcü nesnesi
  final CarDetailController controller;

  // Kurucu fonksiyon
  const _FeaturesSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;
    // Araç nesnesini alıyoruz
    final car = controller.car;

    // Açıklama alanı kutusu
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bölüm başlığı
          const Text(
            'Araç Hakkında',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // 8 piksel boşluk
          const SizedBox(height: 8),
          // Açıklama paragrafı
          Text(
            car.description,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          // 14 piksel boşluk
          const SizedBox(height: 14),

          // Donanım özellikleri listesi varsa gösteriyoruz
          if (car.features.isNotEmpty) ...[
            // Alt başlık
            const Text(
              'Öne Çıkan Donanımlar',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Donanımları çip olarak dizen Wrap
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: car.features.map((f) {
                return Chip(
                  label: Text(f, style: const TextStyle(fontSize: 12)),
                  backgroundColor: colors.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 4: REZERVASYON YAP BUTONU (BottomBar)
// -----------------------------------------------------------------------------

// Ekranın altına yapışık toplam tutarı ve rezervasyon yap butonunu sunan alan
class _BookingBottomBar extends StatelessWidget {
  // Kontrolcü nesnesi
  final CarDetailController controller;
  // Rezervasyon onay eylemi
  final VoidCallback? onBookPressed;

  // Kurucu fonksiyon
  const _BookingBottomBar({
    required this.controller,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Alt sabit bar kapsayıcısı
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      // Cihaz çentiği ve alt gezinme çizgisine taşmaması için SafeArea
      child: SafeArea(
        child: Row(
          children: [
            // Sol Taraf: Toplam Tutar Göstergesi (Fiyat değişimlerini dinler)
            Expanded(
              flex: 2,
              child: ListenableBuilder(
                // Periyot, süre veya kasko değiştiğinde bu alan güncellenir
                listenable: Listenable.merge([
                  controller.selectedPeriodNotifier,
                  controller.durationUnitsNotifier,
                  controller.fullInsuranceNotifier,
                ]),
                builder: (context, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Küçük etiket
                      Text(
                        'Toplam Tutar',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      // Büyük ve kalın nihai fiyat rakamı
                      Text(
                        '${controller.totalAmount.toStringAsFixed(0)} ₺',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Sağ Taraf: 'Rezervasyon Yap' eylem butonu
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                // Butona tıklandığında rezervasyon eylemini çalıştır
                onPressed: onBookPressed,
                // Anahtar ikonu
                icon: const Icon(Icons.key_rounded, size: 18),
                // Buton etiketi
                label: const Text('Rezervasyon Yap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
