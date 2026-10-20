// Flutter Materyal tasarım paketini içe aktarıyoruz
import 'package:flutter/material.dart';
// Context extension ile tema renklerine ve responsive boyutlara pratik erişimi içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Araç veri modelini tip güvenliği için içe aktarıyoruz
import '../../car_listing/models/car_model.dart';
// Dijital anahtar ve yol asistanı durum kontrolcüsünü içe aktarıyoruz
import '../controller/smart_key_controller.dart';
// Kokpit kontrol düğmesi özel widget'ını içe aktarıyoruz
import '../widget/key_action_button.dart';
// Canlı yol asistanı diyalog modalını içe aktarıyoruz
import '../widget/quick_assistant_dialog.dart';

/// TakeGO Dijital Anahtar ve Kokpit Yönetim Sayfası (SmartKeySheet)
///
/// Fiziksel anahtar olmadan araç kilitlerini yönetmeyi, farları yakmayı,
/// bagajı açmayı, canlı sürüş sayacını ve yol asistanı diyaloglarını sağlar.
class SmartKeySheet extends StatelessWidget {
  // Dijital anahtar ve asistan kontrolcüsü
  final SmartKeyController controller;
  // Kiralanan aktif araç nesnesi (Kullanıcı henüz kiralamadıysa null olabilir)
  final CarModel? activeCar;

  // Sabit kurucu metot
  const SmartKeySheet({
    super.key,
    required this.controller,
    this.activeCar,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun ana sayfa düzeni
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlık metni
        title: const Text('Dijital Kokpit Anahtarı'),
        // Sağ üst eylemler
        actions: [
          // Yol asistanı diyalogunu açan buton
          IconButton(
            // İpucu metni
            tooltip: 'Yol Asistanı',
            // Destek ikonu
            icon: const Icon(Icons.support_agent_rounded),
            // Tıklandığında asistan diyalogunu aç
            onPressed: () {
              _openAssistant(context);
            },
          ),
        ],
      ),
      // Sayfanın dikey kaydırılabilir gövdesi
      body: SingleChildScrollView(
        // Ekran kenarlarından 20 piksel iç boşluk
        padding: const EdgeInsets.all(20),
        // Elemanları dikeyde alt alta dizen Column
        child: Column(
          children: [
            // 1. Araç Bilgi Kartı: Araç adı, plaka ve eşleşme durumu
            _CarInfoCard(activeCar: activeCar),
            // 24 piksel dikey boşluk
            const SizedBox(height: 24),

            // 2. Kilit Durumu ve Canlı Sürüş Sayacı Göstergesi
            _KeyStatusDisplay(controller: controller),
            // 28 piksel dikey boşluk
            const SizedBox(height: 28),

            // 3. Otomotiv Kontrol Eylem Butonları (Kapı, Far, Bagaj)
            _CockpitControlsGrid(controller: controller),
            // 28 piksel dikey boşluk
            const SizedBox(height: 28),

            // 4. Asistan Hızlı Butonu ve Sürüşü Bitir Butonu
            _BottomActionButtons(
              // Kontrolcü referansı
              controller: controller,
              // Araç adı veya varsayılan metin
              carName: activeCar?.fullName ?? 'TakeGO Araç',
              // Asistanı açan fonksiyon
              onOpenAssistant: () {
                _openAssistant(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Yol Asistanı diyalog penceresini ekranda gösteren yardımcı metot
  void _openAssistant(BuildContext context) {
    // Flutter showDialog metodu ile modal açıyoruz
    showDialog<void>(
      // Mevcut context nesnesi
      context: context,
      // QuickAssistantDialog penceresini inşa eden builder fonksiyonu
      builder: (_) {
        return QuickAssistantDialog(controller: controller);
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 1: ARAÇ BİLGİ KARTI
// -----------------------------------------------------------------------------

// Kiralanmış olan aracın modelini ve plakasını özetleyen kart bileşeni
class _CarInfoCard extends StatelessWidget {
  // Aktif araç verisi
  final CarModel? activeCar;

  // Kurucu fonksiyon
  const _CarInfoCard({required this.activeCar});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;
    // Araç başlığını veya varsayılan vitrin aracını alıyoruz
    final carTitle = activeCar?.fullName ?? 'Tesla Model Y Long Range';
    // Araç plakasını veya varsayılan plakayı alıyoruz
    final plate = activeCar?.plate ?? '34 TGO 101';

    // Bilgi kutusu kapsayıcısı
    return Container(
      // Kutu içi 16 piksel dolgu
      padding: const EdgeInsets.all(16),
      // Arka plan rengi ve yuvarlatılmış köşeler
      decoration: BoxDecoration(
        // Temanın yükseltilmiş yüzey rengi
        color: colors.surfaceContainer,
        // 16 piksel köşe yuvarlaklığı
        borderRadius: BorderRadius.circular(16),
        // İnce kenarlık çizgisi
        border: Border.all(color: colors.outlineVariant),
      ),
      // İkon ve metinleri yan yana dizen satır
      child: Row(
        children: [
          // Dairesel araç ikonu alanı
          CircleAvatar(
            // Primary renginin %15 opaklığıyla hafif tonlu dolgu
            backgroundColor: colors.primary.withValues(alpha: 0.15),
            // Otomobil ikonu
            child: Icon(
              Icons.directions_car_rounded,
              color: colors.primary,
            ),
          ),
          // İkon ile metin arası 14 piksel boşluk
          const SizedBox(width: 14),
          // Metinleri kalan genişliğe yayan Expanded
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Araç tam adı
                Text(
                  carTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // Plaka ve dijital anahtar bağlantı bilgisi
                Text(
                  'Aktif Plaka: $plate • Dijital Anahtar Eşleşti',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 2: KİLİT DURUMU VE CANLI SAYAÇ ALANI
// -----------------------------------------------------------------------------

// Kapı kilidi açık/kapalı durumunu ve canlı sürüş süresini gösteren merkezi panel
class _KeyStatusDisplay extends StatelessWidget {
  // Kontrolcü nesnesi
  final SmartKeyController controller;

  // Kurucu fonksiyon
  const _KeyStatusDisplay({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Kapı kilidini reaktif dinleyen ValueListenableBuilder
    return ValueListenableBuilder<bool>(
      // Kontrolcüdeki isCarUnlocked durumunu dinliyoruz
      valueListenable: controller.isCarUnlocked,
      // Kilit her açıldığında veya kapandığında yeniden çizilir
      builder: (context, unlocked, _) {
        // Açıkken yeşil (secondary), kapalıyken mavi (primary) durum rengi
        final statusColor = unlocked ? colors.secondary : colors.primary;

        // Dikey hizalanmış durum göstergesi
        return Column(
          children: [
            // Dairesel büyük kilit ikonu çerçevesi
            Container(
              // Dairesel dolgu boşluğu
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                // Tam dairesel şekil
                shape: BoxShape.circle,
                // Durum renginin %12 opaklığıyla hafif zemin dolgusu
                color: statusColor.withValues(alpha: 0.12),
                // 2.5 piksel kalınlığında parlayan durum çerçevesi
                border: Border.all(color: statusColor, width: 2.5),
              ),
              // Kilit açık veya kapalı ikonu
              child: Icon(
                unlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                size: 64,
                color: statusColor,
              ),
            ),
            // İkon ile durum yazısı arası 16 piksel boşluk
            const SizedBox(height: 16),

            // Kilit durumu açıklama metni
            Text(
              unlocked ? 'KAPILAR AÇIK • SÜRÜŞE HAZIR' : 'ARAÇ KİLİTLİ VE GÜVENDE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                color: statusColor,
              ),
            ),
            // Metin ile sayaç arası 8 piksel boşluk
            const SizedBox(height: 8),

            // Canlı Sürüş Sayacını dinleyen ValueListenableBuilder
            ValueListenableBuilder<int>(
              // Kontrolcüdeki activeDriveSeconds saniyesini dinliyoruz
              valueListenable: controller.activeDriveSeconds,
              // Her saniye tetiklenen builder fonksiyonu
              builder: (context, seconds, _) {
                // Saniyeyi 2 haneli dakika olarak hesaplıyoruz
                final m = (seconds ~/ 60).toString().padLeft(2, '0');
                // Kalan saniyeyi 2 haneli olarak hesaplıyoruz
                final s = (seconds % 60).toString().padLeft(2, '0');

                // Süre etiketi kutusu
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Aktif Sürüş Süresi: $m:$s',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      // Sürüş aktifse yeşil, sıfırsa soluk renk
                      color: seconds > 0 ? colors.secondary : colors.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 3: KOKPİT EYLEM BUTONLARI (Kilit, Far, Bagaj)
// -----------------------------------------------------------------------------

// Kapı, Far ve Bagaj fonksiyonlarını içeren 3'lü buton ızgarası
class _CockpitControlsGrid extends StatelessWidget {
  // Kontrolcü referansı
  final SmartKeyController controller;

  // Kurucu fonksiyon
  const _CockpitControlsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Yan yana 3 butonu eşit mesafeyle dizen satır
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 1. Düğme: Kapıları Aç / Kilitle
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: controller.isCarUnlocked,
            builder: (context, unlocked, _) {
              return KeyActionButton(
                icon: unlocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                label: unlocked ? 'Kapıları Kilitle' : 'Kapıları Aç',
                isActive: unlocked,
                onTap: () {
                  controller.toggleCarLock();
                },
              );
            },
          ),
        ),
        // Butonlar arasına 10 piksel boşluk
        const SizedBox(width: 10),

        // 2. Düğme: Farları Yak (Otoparkta Bul)
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: controller.isHeadlightsFlashing,
            builder: (context, flashing, _) {
              return KeyActionButton(
                icon: Icons.highlight_rounded,
                label: flashing ? 'Farlar Yanıyor...' : 'Farları Yak',
                isActive: flashing,
                onTap: () {
                  controller.flashHeadlights();
                },
              );
            },
          ),
        ),
        // Butonlar arasına 10 piksel boşluk
        const SizedBox(width: 10),

        // 3. Düğme: Bagajı Aç / Kapat
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: controller.isTrunkOpen,
            builder: (context, trunkOpen, _) {
              return KeyActionButton(
                icon: Icons.garage_rounded,
                label: trunkOpen ? 'Bagaj Açık' : 'Bagajı Aç',
                isActive: trunkOpen,
                onTap: () {
                  controller.toggleTrunk();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN 4: SÜRÜŞ BİTİRME VE ASİSTAN BUTONLARI
// -----------------------------------------------------------------------------

// Sürüşü bitir butonu ve asistan butonunu içeren alt kontrol alanı
class _BottomActionButtons extends StatelessWidget {
  // Kontrolcü nesnesi
  final SmartKeyController controller;
  // Araç başlığı
  final String carName;
  // Asistan modalını açan fonksiyon
  final VoidCallback onOpenAssistant;

  // Kurucu fonksiyon
  const _BottomActionButtons({
    required this.controller,
    required this.carName,
    required this.onOpenAssistant,
  });

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Butonları dikeyde alt alta dizen Column
    return Column(
      children: [
        // Sürüşü Tamamla ve Kilitle Butonu (Kırmızı uyarı rengiyle)
        FilledButton.icon(
          onPressed: () {
            _confirmEndDrive(context);
          },
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
          ),
          icon: const Icon(Icons.stop_circle_outlined),
          label: const Text('Sürüşü Tamamla & Aracı Kilitle'),
        ),
        // Butonlar arasına 10 piksel boşluk
        const SizedBox(height: 10),

        // Canlı Yol Asistanına Soru Sor Butonu (Çerçeveli buton)
        OutlinedButton.icon(
          onPressed: onOpenAssistant,
          icon: const Icon(Icons.chat_bubble_outline_rounded),
          label: const Text('Canlı Yol Asistanına Soru Sor'),
        ),
      ],
    );
  }

  /// Sürüş bitirildiğinde çalışan süre ve yakıt özet bildirim diyalogu (Pop-up Dialog)
  void _confirmEndDrive(BuildContext context) {
    // Sürüşü bitirip istatistik özetini alıyoruz
    final summary = controller.finishDriveSession();
    // Toplam geçen dakika
    final minutes = summary['minutes'];
    // Harcanan tahmini yakıt / batarya yüzdesi
    final fuelUsed = summary['fuelPercentUsed'];

    // Özet diyalog penceresini ekrana getiriyoruz
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          // 20 piksel yuvarlatılmış diyalog köşeleri
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // Başlık satırı
          title: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(ctx).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              const Text('Sürüş Tamamlandı'),
            ],
          ),
          // Özet içerik metinleri
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$carName ile sürüşünüz başarıyla sonlandırıldı.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('• Toplam Sürüş Süresi: $minutes dakika'),
              Text('• Tahmini Tüketim: %$fuelUsed depo/şarj'),
              const SizedBox(height: 8),
              const Text(
                'Kapılar otomatik kilitlendi. Güvenli yolculuklar dileriz!',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          // Onay butonu
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
