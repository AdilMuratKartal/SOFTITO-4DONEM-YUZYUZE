// Flutter Materyal tasarım paketini içe aktarıyoruz
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Context extension ile tema renklerine ve responsive boyutlara pratik erişimi içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Araç veri modelini tip güvenliği için içe aktarıyoruz
import '../../car_listing/models/car_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Dijital anahtar ve yol asistanı durum kontrolcüsünü içe aktarıyoruz
import '../controller/smart_key_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// Kokpit kontrol düğmesi özel widget'ını içe aktarıyoruz
import '../widget/key_action_button.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
// Canlı yol asistanı diyalog modalını içe aktarıyoruz
import '../widget/quick_assistant_dialog.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

/// TakeGO Dijital Anahtar ve Kokpit Yönetim Sayfası (SmartKeySheet)
///
/// Fiziksel anahtar olmadan araç kilitlerini yönetmeyi, farları yakmayı,
/// bagajı açmayı, canlı sürüş sayacını ve yol asistanı diyaloglarını sağlar.
class SmartKeySheet extends StatelessWidget { // SmartKeySheet sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Dijital anahtar ve asistan kontrolcüsü
  final SmartKeyController controller; // SmartKeyController türünden controller adlı değişkenimiz
  // Kiralanan aktif araç nesnesi (Kullanıcı henüz kiralamadıysa null olabilir)
  final CarModel? activeCar; // CarModel? türünden activeCar adlı değişkenimiz

  // Sabit kurucu metot
  const SmartKeySheet({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.activeCar, // activeCar alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // 40 satır kuralına uygun ana sayfa düzeni
    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      // Üst başlık çubuğu
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        // Başlık metni
        title: const Text('Dijital Kokpit Anahtarı'), // Sayfa başlığını ekrana yazdırıyoruz
        // Sağ üst eylemler
        actions: [
          // Yol asistanı diyalogunu açan buton
          IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
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
      body: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
        // Ekran kenarlarından 20 piksel iç boşluk
        padding: const EdgeInsets.all(20),
        // Elemanları dikeyde alt alta dizen Column
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          children: [
            // 1. Araç Bilgi Kartı: Araç adı, plaka ve eşleşme durumu
            _CarInfoCard(activeCar: activeCar), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
            // 24 piksel dikey boşluk
            const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 2. Kilit Durumu ve Canlı Sürüş Sayacı Göstergesi
            _KeyStatusDisplay(controller: controller),
            // 28 piksel dikey boşluk
            const SizedBox(height: 28), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // 3. Otomotiv Kontrol Eylem Butonları (Kapı, Far, Bagaj)
            _CockpitControlsGrid(controller: controller),
            // 28 piksel dikey boşluk
            const SizedBox(height: 28), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

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
class _CarInfoCard extends StatelessWidget { // _CarInfoCard sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Aktif araç verisi
  final CarModel? activeCar; // CarModel? türünden activeCar adlı değişkenimiz

  // Kurucu fonksiyon
  const _CarInfoCard({required this.activeCar}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renklerini alıyoruz
    final colors = context.colors;
    // Araç başlığını veya varsayılan vitrin aracını alıyoruz
    final carTitle = activeCar?.fullName ?? 'Tesla Model Y Long Range';
    // Araç plakasını veya varsayılan plakayı alıyoruz
    final plate = activeCar?.plate ?? '34 TGO 101';

    // Bilgi kutusu kapsayıcısı
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      // Kutu içi 16 piksel dolgu
      padding: const EdgeInsets.all(16),
      // Arka plan rengi ve yuvarlatılmış köşeler
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        // Temanın yükseltilmiş yüzey rengi
        color: colors.surfaceContainer,
        // 16 piksel köşe yuvarlaklığı
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        // İnce kenarlık çizgisi
        border: Border.all(color: colors.outlineVariant),
      ),
      // İkon ve metinleri yan yana dizen satır
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
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
          const SizedBox(width: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          // Metinleri kalan genişliğe yayan Expanded
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
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
class _KeyStatusDisplay extends StatelessWidget { // _KeyStatusDisplay sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Kontrolcü nesnesi
  final SmartKeyController controller; // SmartKeyController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _KeyStatusDisplay({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
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
        return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          children: [
            // Dairesel büyük kilit ikonu çerçevesi
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              // Dairesel dolgu boşluğu
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
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
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

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
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

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
                return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
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
class _CockpitControlsGrid extends StatelessWidget { // _CockpitControlsGrid sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Kontrolcü referansı
  final SmartKeyController controller; // SmartKeyController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _CockpitControlsGrid({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Yan yana 3 butonu eşit mesafeyle dizen satır
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
      children: [
        // 1. Düğme: Kapıları Aç / Kilitle
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
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
        const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

        // 2. Düğme: Farları Yak (Otoparkta Bul)
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
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
        const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

        // 3. Düğme: Bagajı Aç / Kapat
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
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
class _BottomActionButtons extends StatelessWidget { // _BottomActionButtons sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Kontrolcü nesnesi
  final SmartKeyController controller; // SmartKeyController türünden controller adlı değişkenimiz
  // Araç başlığı
  final String carName; // String türünden carName adlı değişkenimiz
  // Asistan modalını açan fonksiyon
  final VoidCallback onOpenAssistant; // VoidCallback türünden onOpenAssistant adlı değişkenimiz

  // Kurucu fonksiyon
  const _BottomActionButtons({ // Genel, sabit sınıf constructor'ı
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.carName, // carName parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onOpenAssistant, // onOpenAssistant parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Butonları dikeyde alt alta dizen Column
    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
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
        const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

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
        return AlertDialog( // Kullanıcıya uyarı veya onay penceresi göstermek için AlertDialog açıyoruz
          // 20 piksel yuvarlatılmış diyalog köşeleri
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          // Başlık satırı
          title: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(ctx).colorScheme.secondary,
              ),
              const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              const Text('Sürüş Tamamlandı'),
            ],
          ),
          // Özet içerik metinleri
          content: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              Text(
                '$carName ile sürüşünüz başarıyla sonlandırıldı.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Text('• Toplam Sürüş Süresi: $minutes dakika'),
              Text('• Tahmini Tüketim: %$fuelUsed depo/şarj'),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              const Text(
                'Kapılar otomatik kilitlendi. Güvenli yolculuklar dileriz!',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          // Onay butonu
          actions: [
            FilledButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
              onPressed: () {
                Navigator.pop(ctx); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
