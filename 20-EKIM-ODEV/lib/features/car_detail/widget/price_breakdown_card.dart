// Flutter'ın temel materyal tasarım widget kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Tema renklerine pratik ve tip güvenli erişim sağlayan context uzantısını içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Günlük, haftalık ve aylık kiralama periyot tiplerini içe aktarıyoruz
import '../../car_listing/models/rental_period_type.dart';
// Fiyat hesaplamalarını ve reaktif durumları yöneten denetleyiciyi içe aktarıyoruz
import '../controller/car_detail_controller.dart';

/// TakeGO Fiyat Detayı ve Süre Hesaplayıcı Kartı (PriceBreakdownCard)
///
/// Seçilen gün/hafta/ay sayısı değiştikçe toplam tutarı, kasko ve
/// hizmet bedellerini dinamik olarak yeniden hesaplayan karttır.
class PriceBreakdownCard extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // ÖZELLİKLER (Properties)
  // ---------------------------------------------------------------------------

  /// Fiyat hesaplamalarını ve reaktif sayaçları yöneten kontrolcü nesnesi
  final CarDetailController controller;

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: Kontrolcüyü zorunlu olarak alır
  const PriceBreakdownCard({
    // Widget ağacı optimizasyonu için super.key
    super.key,
    // Detay denetleyicisi (Zorunlu alan)
    required this.controller,
  });

  // ---------------------------------------------------------------------------
  // ARAYÜZ OLUŞTURMA (Build)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Kartın dış çerçevesini ve arka plan rengini belirleyen Container
    return Container(
      // Kart içi dört taraftan 18px dolgu payı
      padding: const EdgeInsets.all(18),
      // Kartın görsel kutu süslemesi
      decoration: BoxDecoration(
        // Temanın ikincil yüzey dolgu rengi
        color: context.colors.surfaceContainer,
        // 16 piksel yuvarlatılmış modern köşeler
        borderRadius: BorderRadius.circular(16),
        // Çerçeve kenarlık çizgisi
        border: Border.all(color: context.colors.outlineVariant),
      ),
      // Kart içi bileşenleri dikeyde sıralayan Column
      child: Column(
        // İçerikleri sola dayalı hizalıyoruz
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Kiralama Süresi Arttırma / Azaltma Satırı
          _DurationCounterRow(controller: controller),
          // Süre sayacı ile kasko anahtarı arasına 24px ayırıcı çizgi
          const Divider(height: 24),

          // 2. Kasko / Sigorta Paketi Seçim Anahtarı
          _InsuranceSwitchRow(controller: controller),
          // Kasko anahtarı ile fiyat dökümü arasına 24px ayırıcı çizgi
          const Divider(height: 24),

          // 3. Fiyat Dökümü ve Toplam Tutar Satırları
          _PriceCalculationRows(controller: controller),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 1: SÜRE ADEDİ SAYAÇ SATIRI
// -----------------------------------------------------------------------------

/// Kiralama periyodu adedini (+/- butonlarıyla) dinamik artıran/azaltan sayaç satırı
class _DurationCounterRow extends StatelessWidget {
  /// Kontrolcü referansı
  final CarDetailController controller;

  /// Kurucu metot
  const _DurationCounterRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    // 1. Değişken: Aktif tema renk paleti
    final colors = context.colors;

    // Periyot türünün (gün/hafta/ay) değişimini dinleyen ValueListenableBuilder
    return ValueListenableBuilder<RentalPeriodType>(
      // Dinlenen periyot bildiricisi
      valueListenable: controller.selectedPeriodNotifier,
      // Periyot değiştikçe çalışan inşa fonksiyonu
      builder: (context, period, _) {
        // Süre birim sayısını (1, 2, 3...) dinleyen iç ValueListenableBuilder
        return ValueListenableBuilder<int>(
          // Dinlenen süre birimi bildiricisi
          valueListenable: controller.durationUnitsNotifier,
          // Sayı değiştikçe çalışan inşa fonksiyonu
          builder: (context, units, _) {
            // Başlık ve artı/eksi butonlarını yan yana dizen satır
            return Row(
              // Uç noktaları ekranın iki tarafına yaslama
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol Bölüm: Başlık ve birim etiketi
                Column(
                  // Sola dayalı metinler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kalın başlık
                    const Text(
                      'Kiralama Süresi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    // Aktif birim etiketi (Örn: Birim: Günlük)
                    Text(
                      'Birim: ${period.label}',
                      style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
                // Sağ Bölüm: Eksi butonu, mevcut sayı ve Artı butonu
                Row(
                  children: [
                    // Azaltma (Eksi) butonu
                    IconButton.filledTonal(
                      // Değer 1'den büyükse azaltır, 1 ise tıklanamaz (null) olur
                      onPressed: units > 1 ? () => controller.setDuration(units - 1) : null,
                      // Eksi ikonu
                      icon: const Icon(Icons.remove_rounded, size: 18),
                    ),
                    // Sayı metni etrafında 14px yatay boşluk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      // Seçili süre metni (Örn: "3 Günlük")
                      child: Text(
                        '$units ${period.label}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    // Artırma (Artı) butonu
                    IconButton.filledTonal(
                      // Sayacı 1 artıran tetikleyici
                      onPressed: () => controller.setDuration(units + 1),
                      // Artı ikonu
                      icon: const Icon(Icons.add_rounded, size: 18),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 2: KASKO SEÇİM ANAHTARI
// -----------------------------------------------------------------------------

/// Kullanıcının tam kapsamlı kasko güvencesini açıp kapatmasını sağlayan switch satırı
class _InsuranceSwitchRow extends StatelessWidget {
  /// Kontrolcü referansı
  final CarDetailController controller;

  /// Kurucu metot
  const _InsuranceSwitchRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    // 1. Değişken: Aktif tema renk paleti
    final colors = context.colors;

    // Kasko durumunu dinleyen ValueListenableBuilder
    return ValueListenableBuilder<bool>(
      // Dinlenen kasko bildiricisi
      valueListenable: controller.fullInsuranceNotifier,
      // Durum değiştikçe çalışan inşa fonksiyonu
      builder: (context, hasInsurance, _) {
        // İkon, metinler ve anahtarı yan yana dizen satır
        return Row(
          // İki ucu yatayda zıt köşelere yayıyoruz
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sol Bölüm: Kalkan ikonu ve açıklama metinleri
            Row(
              children: [
                // Güvence kalkan ikonu (aktifken primary mavi, pasifken gri)
                Icon(
                  Icons.shield_outlined,
                  size: 20,
                  color: hasInsurance ? colors.primary : colors.onSurfaceVariant,
                ),
                // İkon ile yazı arasına 8px boşluk
                const SizedBox(width: 8),
                // Başlık ve alt başlığı dikey sıralayan Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kasko başlığı
                    const Text(
                      'Tam Kapsamlı Kasko',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    // Kasko güvence avantajı alt metni
                    Text(
                      '0 TL Muafiyetli Güvence',
                      style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
            // Sağ Bölüm: Açma/Kapama anahtarı (Switch)
            Switch(
              // Switch'in mevcut açık/kapalı değeri
              value: hasInsurance,
              // Tıklandığında kaskoyu açan/kapatan controller fonksiyonu
              onChanged: (_) => controller.toggleInsurance(),
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 3: HESAPLANAN KALEMLER VE NİHAİ TUTAR
// -----------------------------------------------------------------------------

/// Süre, kasko veya periyot değiştikçe güncellenen dinamik fiyat tablosu
class _PriceCalculationRows extends StatelessWidget {
  /// Kontrolcü referansı
  final CarDetailController controller;

  /// Kurucu metot
  const _PriceCalculationRows({required this.controller});

  @override
  Widget build(BuildContext context) {
    // 1. Değişken: Tema renkleri
    final colors = context.colors;

    // Süre, kasko ve periyot durumlarının üçünü birden dinleyen birleşik dinleyici
    return ListenableBuilder(
      // Üç ayrı ValueNotifier'ı tek çatı altında birleştiriyoruz
      listenable: Listenable.merge([
        controller.selectedPeriodNotifier,
        controller.durationUnitsNotifier,
        controller.fullInsuranceNotifier,
      ]),
      // Herhangi bir değer değiştiğinde fiyat tablosunu yeniden inşa eden fonksiyon
      builder: (context, _) {
        // Fiyat satırlarını dikeyde alt alta dizen Column
        return Column(
          children: [
            // 1. Kalem: Kiralama Taban Tutarı satırı
            _rowItem(
              'Kiralama Taban Tutarı',
              '${controller.baseAmount.toStringAsFixed(0)} ₺',
              colors,
            ),
            // Kalemler arası 6px dikey boşluk
            const SizedBox(height: 6),

            // 2. Kalem: Kasko & Güvence Bedeli satırı
            _rowItem(
              'Kasko & Güvence Bedeli',
              '${controller.insuranceAmount.toStringAsFixed(0)} ₺',
              colors,
            ),
            // Kalemler arası 6px dikey boşluk
            const SizedBox(height: 6),

            // 3. Kalem: Platform Hizmet Bedeli (%5) satırı
            _rowItem(
              'Platform Hizmet Bedeli (%5)',
              '${controller.serviceFee.toStringAsFixed(0)} ₺',
              colors,
            ),
            // Kalemler ile toplam tutar arasına 20px ayırıcı çizgi
            const Divider(height: 20),

            // 4. Kalem: Vurgulu Toplam Tutar Satırı
            Row(
              // İki ucu yatayda ayırıyoruz
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Toplam Tutar Etiketi
                const Text(
                  'Toplam Tutar',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                ),
                // Büyük ve renkli nihai fiyat tutarı (Örn: "4.850 ₺")
                Text(
                  '${controller.totalAmount.toStringAsFixed(0)} ₺',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Yardımcı metot: Standart etiket ve tutar satırı widget'ı üretir
  Widget _rowItem(String label, String value, ColorScheme colors) {
    // Etiket ve değeri yan yana hizalayan Row
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Sol tarafta açıklama etiketi
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colors.onSurfaceVariant,
          ),
        ),
        // Sağ tarafta hesaplanan sayısal tutar
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
