// Flutter Materyal kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Context extension ile tema renklerine ve responsive ölçülere hızlı erişimi içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Açık/koyu mod geçiş kontrolcüsünü içe aktarıyoruz
import '../../../core/theme/theme_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// Vitrin iş mantığı ve filtre kontrolcüsünü içe aktarıyoruz
import '../controller/car_listing_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// Araç veri modelini içe aktarıyoruz
import '../models/car_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Kiralama periyot tiplerini içe aktarıyoruz
import '../models/rental_period_type.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// 16:9 sabit oranlı kart bileşenini içe aktarıyoruz
import '../widget/car_card_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
// Günlük/Haftalık/Aylık çip seçici bileşenini içe aktarıyoruz
import '../widget/period_filter_chips.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

/// TakeGO İlan Vitrini Ana Sayfası (CarListingView)
///
/// Kullanıcıların kiralık araçları listeleyebildiği, günlük/haftalık/aylık
/// periyoda göre dinamik fiyatları inceleyebildiği ve arama yapabildiği ekrandır.
/// [StatelessWidget] ve [ValueListenableBuilder] mimarisiyle çalışır.
class CarListingView extends StatelessWidget { // CarListingView sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  /// İlan listeleme iş mantığı denetleyicisi
  final CarListingController controller; // CarListingController türünden controller adlı değişkenimiz

  /// Koyu / Açık tema geçişini yöneten global denetleyici
  final ThemeController themeController; // ThemeController türünden themeController adlı değişkenimiz

  /// Bir araca tıklandığında detay sayfasına yönlendiren fonksiyon
  final void Function(CarModel car)? onCarSelected;

  /// Yeni ilan ekleme ekranını açan fonksiyon
  final VoidCallback? onAddListingPressed; // VoidCallback? türünden onAddListingPressed adlı değişkenimiz

  /// Dijital anahtar kokpitini açan fonksiyon
  final VoidCallback? onOpenSmartKeyPressed; // VoidCallback? türünden onOpenSmartKeyPressed adlı değişkenimiz

  // Sabit kurucu metot
  const CarListingView({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.themeController, // themeController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.onCarSelected, // onCarSelected alanına değer aktarıyoruz
    this.onAddListingPressed, // onAddListingPressed alanına değer aktarıyoruz
    this.onOpenSmartKeyPressed, // onOpenSmartKeyPressed alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // 40 satır kuralına uygun temiz sayfa iskeleti
    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      // Sayfanın üst başlık çubuğu (Logo, tema anahtarı ve dijital anahtar kısayolu)
      appBar: _buildAppBar(context),
      // Sayfa dikey içeriği
      body: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        children: [
          // 1. Arama Çubuğu ve Elektrikli Araç Filtresi Satırı
          _SearchBarRow(controller: controller), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz

          // 2. Kiralama Periyodu Seçici Çipleri (Günlük/Haftalık/Aylık)
          _PeriodSelectorRow(controller: controller), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz

          // 3. Dinamik İlan Listesi (Kalan alanı tamamen kaplar)
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: _CarListSection(
              // Kontrolcü referansı
              controller: controller,
              // Araç seçildiğinde tetiklenecek eylem
              onCarSelected: onCarSelected,
            ),
          ),
        ],
      ),
      // Sağ altta yüzen 'İlan Ver' eylem butonu
      floatingActionButton: FloatingActionButton.extended(
        // Tıklandığında ilan verme sekmesine geçiş eylemini tetikler
        onPressed: onAddListingPressed,
        // Artı ikonu
        icon: const Icon(Icons.add_rounded),
        // Buton etiketi
        label: const Text('İlan Ver'),
      ),
    );
  }

  /// TakeGO logosu, tema değiştirici ve dijital anahtar butonunu içeren AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Tema renk şemasını context üzerinden alıyoruz
    final colors = context.colors;

    // AppBar widget'ını yapılandırıyoruz
    return AppBar(
      // Sol taraftaki TakeGO logo ve marka başlığı
      title: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        // Minimum yatay genişlik
        mainAxisSize: MainAxisSize.min,
        children: [
          // Şimşek ikonlu elektrikli mobilite logo kutusu
          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
              // Elektrik mavisi arka plan
              color: colors.primary,
              // Yuvarlatılmış köşe
              borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            ),
            // Beyaz renkli elektrik şimşeği ikonu
            child: const Icon(
              Icons.electric_bolt_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          // Logo ile marka yazısı arasına 8 piksel boşluk
          const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          // TakeGO marka metni
          const Text(
            'TakeGO',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      // Sağ üst aksiyon butonları
      actions: [
        // Gece / Gündüz Modu Geçiş Butonu (ValueListenableBuilder ile dinlenir)
        ValueListenableBuilder<ThemeMode>(
          // Tema modunu dinleyen bildirici
          valueListenable: themeController.themeModeNotifier,
          // Tema değiştikçe ikonu güncelleyen builder fonksiyonu
          builder: (context, mode, _) {
            // Aktif modun koyu olup olmadığını kontrol ediyoruz
            final isDark = mode == ThemeMode.dark;

            // Tek dokunuşla tema değiştiren buton
            return IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
              // İpucu metni
              tooltip: isDark ? 'Gündüz Moduna Geç' : 'Gece Moduna Geç',
              // Koyu ise güneş ikonu, açıksa ay ikonu
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              // Butona basıldığında temayı tersine çeviriyoruz
              onPressed: () {
                themeController.toggleTheme();
              },
            );
          },
        ),

        // Dijital Anahtar ve Yol Asistanı Kısayol Butonu
        IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
          tooltip: 'Dijital Anahtar',
          icon: const Icon(Icons.key_rounded),
          onPressed: onOpenSmartKeyPressed,
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN: ARAMA ÇUBUĞU VE FİLTRE BUTONU
// -----------------------------------------------------------------------------

/// Araç markası, modeli veya şehre göre anlık filtreleme alanı
class _SearchBarRow extends StatelessWidget { // _SearchBarRow sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Arama metnini ve filtreyi güncelleyecek kontrolcü
  final CarListingController controller; // CarListingController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _SearchBarRow({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Satır etrafına dış dolgu
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      // Arama kutusu ve elektrikli filtresini yan yana dizen satır
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        children: [
          // Arama metin giriş alanını kalan genişliğe esnetiyoruz
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
              // Her harf yazıldığında filtreyi anında tetikliyoruz
              onChanged: (val) {
                controller.updateSearchQuery(val);
              },
              // Arama kutusu görsel süslemesi
              decoration: const InputDecoration(
                hintText: 'Araç markası, model veya şehir ara...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          // Arama kutusu ile filtre çipi arasına 8 piksel boşluk
          const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

          // Sadece Elektrikli Araçlar Filtre Çipi
          ValueListenableBuilder<bool>(
            // Elektrikli filtre durumunu dinliyoruz
            valueListenable: controller.electricOnlyNotifier,
            // Durum değiştikçe çipi yeniden çizen builder fonksiyonu
            builder: (context, isElectricOnly, _) {
              return FilterChip(
                // Çip etiketi
                label: const Text('Elektrikli'),
                // Elektrik şimşeği ikonu
                avatar: Icon(
                  Icons.bolt_rounded,
                  size: 16,
                  color: isElectricOnly ? Colors.white : colors.primary,
                ),
                // Seçili olup olmadığı durumu
                selected: isElectricOnly,
                // Tıklandığında elektrik filtresini tersine çevir
                onSelected: (_) {
                  controller.toggleElectricFilter();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN: PERİYOT SEÇİCİ BÖLÜMÜ
// -----------------------------------------------------------------------------

/// Seçili kiralama periyodunu dinleyen ve güncelleyen satır
class _PeriodSelectorRow extends StatelessWidget { // _PeriodSelectorRow sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Kontrolcü referansı
  final CarListingController controller; // CarListingController türünden controller adlı değişkenimiz

  // Kurucu fonksiyon
  const _PeriodSelectorRow({required this.controller}); // Genel, sabit sınıf constructor'ı

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Periyot değişimini reaktif dinleyen ValueListenableBuilder
    return ValueListenableBuilder<RentalPeriodType>(
      // Seçili periyot bildiricisi
      valueListenable: controller.selectedPeriod,
      // Periyot değiştikçe çalışan builder
      builder: (context, period, _) {
        // Hazır SegmentedButton çip bileşenimizi çağırıyoruz
        return PeriodFilterChips(
          // Seçili periyot
          selectedPeriod: period,
          // Kullanıcı periyot değiştirdiğinde kontrolcü metodunu tetikliyoruz
          onPeriodChanged: (newPeriod) {
            controller.changePeriod(newPeriod);
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ALT BİLEŞEN: ARAÇ LİSTESİ GÖVDE BÖLÜMÜ
// -----------------------------------------------------------------------------

/// Filtrelenmiş araç listesini ve seçili periyodu dinleyerek kartları oluşturan alan
class _CarListSection extends StatelessWidget { // _CarListSection sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Kontrolcü nesnesi
  final CarListingController controller; // CarListingController türünden controller adlı değişkenimiz
  // Araç seçildiğinde tetiklenen callback
  final void Function(CarModel car)? onCarSelected;

  // Kurucu fonksiyon
  const _CarListSection({ // Genel, sabit sınıf constructor'ı
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onCarSelected, // onCarSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Tema renklerini alıyoruz
    final colors = context.colors;

    // Görüntülenecek araç listesini dinleyen ValueListenableBuilder
    return ValueListenableBuilder<List<CarModel>>(
      // Süzülmüş araçlar listesi bildiricisi
      valueListenable: controller.displayedCarsNotifier,
      // Liste her güncellendiğinde çağrılan builder fonksiyonu
      builder: (context, cars, _) {
        // Eğer arama kriterine uygun hiçbir araç kalmadıysa boş durum ekranı göster
        if (cars.isEmpty) {
          return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
              children: [
                // Boş liste ikonu
                Icon(
                  Icons.car_rental_outlined,
                  size: 64,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                // 12 piksel dikey boşluk
                const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                // Bilgilendirme metni
                Text(
                  'Kriterlerinize uygun araç bulunamadı.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        // Fiyatlandırmanın anlık güncellenmesi için seçili periyodu dinliyoruz
        return ValueListenableBuilder<RentalPeriodType>(
          valueListenable: controller.selectedPeriod,
          builder: (context, period, _) {
            // Performanslı ListView.builder ile yalnızca ekrandaki kartları çiziyoruz
            return ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
              // Listedeki toplam araç adedi
              itemCount: cars.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              // Alt gezinme barının altında kalmaması için 80 piksel alt boşluk
              padding: const EdgeInsets.only(bottom: 80),
              // Her araç için çağrılan builder fonksiyonu
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                // Sıradaki aracı alıyoruz
                final car = cars[index];

                // 16:9 sabit görsel oranlı araç kartını döndürüyoruz
                return CarCardWidget(
                  // Araç verisi
                  car: car,
                  // Seçili periyot (Günlük/Haftalık/Aylık fiyatlama için)
                  selectedPeriod: period,
                  // Karta dokunulduğunda detay sayfasına yönlendir
                  onTap: () {
                    onCarSelected?.call(car);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
