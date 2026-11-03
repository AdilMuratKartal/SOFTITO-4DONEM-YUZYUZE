// Flutter çekirdek Material tasarım kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Açık ve koyu tema stillerini barındıran AppTheme sınıfını içe aktarıyoruz
import 'core/theme/app_theme.dart';
// Reaktif tema modunu (Light/Dark) yöneten ThemeController sınıfını içe aktarıyoruz
import 'core/theme/theme_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// İlan detay sayfası için fiyat hesaplama kontrolcüsünü içe aktarıyoruz
import 'features/car_detail/controller/car_detail_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// İlan detay ve rezervasyon sayfasını içe aktarıyoruz
import 'features/car_detail/view/car_detail_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
// Araç vitrin listesini ve arama mantığını yöneten kontrolcüyü içe aktarıyoruz
import 'features/car_listing/controller/car_listing_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// Araç veri modelini tip güvenliği için içe aktarıyoruz
import 'features/car_listing/models/car_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Araç listeleme ana vitrin ekranını içe aktarıyoruz
import 'features/car_listing/view/car_listing_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
// Yeni araç ilanı verme form kontrolcüsünü içe aktarıyoruz
import 'features/create_listing/controller/create_listing_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// Yeni araç ilanı verme form arayüzünü içe aktarıyoruz
import 'features/create_listing/view/create_listing_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
// Dijital anahtar ve yol asistanı durum kontrolcüsünü içe aktarıyoruz
import 'features/smart_key_assistant/controller/smart_key_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
// Dijital kokpit ve anahtar yönetim sayfasını içe aktarıyoruz
import 'features/smart_key_assistant/view/smart_key_sheet.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

// =============================================================================
// UYGULAMA GİRİŞ NOKTASI (main)
//
// main.dart'ın tek sorumluluğu: Uygulamayı başlatmak, tema denetleyicisini
// dinlemek ve ana gezinti iskeletini (NavigationBar) bağlamaktır.
// Hiçbir ağır iş mantığı içermez.
// =============================================================================

// Flutter uygulamasının başlangıç fonksiyonu
void main() { // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  // Flutter widget motorunun alt sistemlerle doğru haberleştiğini garanti altına alıyoruz
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Global tema denetleyicisini başlatıyoruz (OLED Cockpit Dark varsayılan moddur)
  final themeController = ThemeController();

  // 2. Kök TakeGoApp uygulamasını ayağa kaldırıyoruz
  runApp( // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
    // Kök widget'a tema denetleyicisini iletiyoruz
    TakeGoApp(themeController: themeController),
  );
}

/// TakeGO Ana Kök Uygulama Bileşeni (StatelessWidget)
class TakeGoApp extends StatelessWidget { // TakeGoApp sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Global tema durumunu yöneten denetleyici referansı
  final ThemeController themeController; // ThemeController türünden themeController adlı değişkenimiz

  // Sabit kurucu metot
  const TakeGoApp({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.themeController, // themeController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // ValueListenableBuilder ile Gece/Gündüz modları ağır setState olmadan reaktif dinlenir
    return ValueListenableBuilder<ThemeMode>(
      // Dinlenecek olan tema durumu bildiricisi
      valueListenable: themeController.themeModeNotifier,
      // Tema modu her değiştiğinde bu fonksiyon tetiklenir
      builder: (context, themeMode, _) {
        // Ana MaterialApp kök widget'ı
        return MaterialApp( // Flutter'ın Material Design temellerini ve yönlendirmesini başlatan ana MaterialApp widget'ı
          // Sağ üstteki debug etiketini gizliyoruz
          debugShowCheckedModeBanner: false,
          // Uygulama başlığı
          title: 'TakeGO - Akıllı Araç Kiralama',
          // Dinlenen güncel tema modu (ThemeMode.light veya ThemeMode.dark)
          themeMode: themeMode,
          // Clean Mobility Light Teması
          theme: AppTheme.lightTheme,
          // OLED Cockpit Dark Teması
          darkTheme: AppTheme.darkTheme,
          // Ana Gezinti İskelet Sayfası (Alt Bar ile sekmeleri yönetir)
          home: TakeGoRootNavigation(themeController: themeController),
        );
      },
    );
  }
}

/// Ana Navigasyon Çubuğunu (NavigationBar) Yöneten İskelet Sayfa
class TakeGoRootNavigation extends StatefulWidget { // TakeGoRootNavigation sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  // Tema değiştirme butonuna AppBar üzerinden erişebilmek için kontrolcü
  final ThemeController themeController; // ThemeController türünden themeController adlı değişkenimiz

  // Kurucu fonksiyon
  const TakeGoRootNavigation({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.themeController, // themeController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<TakeGoRootNavigation> createState() => _TakeGoRootNavigationState();
}

// Ana navigasyon sekme durumunu tutan State sınıfı
class _TakeGoRootNavigationState extends State<TakeGoRootNavigation> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  // Seçili aktif sekme indeksi (0: Vitrin/İlanlar, 1: İlan Ver, 2: Kokpit/Anahtar)
  int _currentIndex = 0; // int türünden _currentIndex değişkenimiz

  // Araç listeleme ekranının iş mantığı denetleyicisi
  late final CarListingController _carListingController;

  // İlan verme ekranının form denetleyicisi
  late final CreateListingController _createListingController;

  // Dijital anahtar ve asistan modülünün denetleyicisi
  late final SmartKeyController _smartKeyController;

  // Kullanıcının kiraladığı aktif araç referansı (nullable)
  CarModel? _activeBookedCar;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    // Üst sınıfın initState metodunu çağırıyoruz
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz

    // 1. İlan kontrolcüsünü oluşturup mock verileri yüklüyoruz
    _carListingController = CarListingController()..init();

    // 2. İlan verme form kontrolcüsünü oluşturuyoruz
    _createListingController = CreateListingController();

    // 3. Dijital anahtar kontrolcüsünü başlatıp karşılama mesajını yüklüyoruz
    _smartKeyController = SmartKeyController()..init();
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    // Bellek sızıntılarını önlemek için ilan listeleme kontrolcüsünü temizliyoruz
    _carListingController.dispose();

    // İlan verme form kontrolcüsünü temizliyoruz
    _createListingController.dispose();

    // Dijital anahtar kontrolcüsünü temizliyoruz
    _smartKeyController.dispose();

    // Üst sınıfın dispose metodunu çağırıyoruz
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  /// Bir araç kartına tıklandığında detay sayfasına geçişi sağlayan fonksiyon
  void _openCarDetail(CarModel car) {
    // Detay sayfası için yeni bir CarDetailController örneği oluşturuyoruz
    final detailController = CarDetailController(
      // İncelenecek olan araç verisi
      car: car,
      // Vitrinde seçili olan kiralama periyodunu aktarıyoruz
      initialPeriod: _carListingController.selectedPeriod.value,
    );

    // Yeni sayfayı Navigator ile açıyoruz
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        // CarDetailView sayfasını inşa ediyoruz
        builder: (_) => CarDetailView(
          // Detay kontrolcüsünü bağlıyoruz
          controller: detailController,
          // Kullanıcı 'Rezervasyon Yap' butonuna bastığında çalışan eylem
          onBookAndOpenKey: () {
            // Rezervasyon yapıldı, aktif kiralanan aracı güncelliyoruz
            setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
              // Kiralanan aracı referansa alıyoruz
              _activeBookedCar = car;
              // 2 numaralı sekmeye (Dijital Kokpit sekmesine) geçiş yapıyoruz
              _currentIndex = 2;
            });
            // Detay sayfasını kapatıp ana ekrana geri dönüyoruz
            Navigator.pop(context); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
          },
        ),
      ),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // 40 satır kuralına uygun ana gezinme gövdesi
    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      // Sekmeler arası geçişlerde sayfaların durumunu koruyan IndexedStack
      body: IndexedStack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
        // Aktif olarak gösterilecek sekme numarası
        index: _currentIndex,
        // Sekmelerin listesi
        children: [
          // 1. Sekme: Araç İlanları Vitrini Ekranı
          CarListingView(
            // Vitrin kontrolcüsü
            controller: _carListingController,
            // Tema kontrolcüsü
            themeController: widget.themeController,
            // Araç seçildiğinde detay sayfasını açan metot
            onCarSelected: _openCarDetail,
            // 'İlan Ver' butonuna basıldığında 1. sekmeye geçiren eylem
            onAddListingPressed: () {
              setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                _currentIndex = 1;
              });
            },
            // 'Dijital Anahtar' ikonuna basıldığında 2. sekmeye geçiren eylem
            onOpenSmartKeyPressed: () {
              setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                _currentIndex = 2;
              });
            },
          ),

          // 2. Sekme: Yeni İlan Verme Form Ekranı
          CreateListingView(
            // İlan verme kontrolcüsü
            controller: _createListingController,
            // İlan kaydedildiğinde çalışan eylem
            onListingCreated: (newCar) {
              // Yeni eklenen aracı vitrin listesine en baştan ekliyoruz
              _carListingController.addNewListing(newCar);
              // Kullanıcıyı vitrin sekmesine geri yönlendiriyoruz
              setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                _currentIndex = 0;
              });
            },
          ),

          // 3. Sekme: Dijital Kokpit ve Akıllı Anahtar Ekranı
          SmartKeySheet(
            // Anahtar ve yol asistanı kontrolcüsü
            controller: _smartKeyController,
            // Varsa kiralanmış aktif araç, yoksa varsayılan araç
            activeCar: _activeBookedCar,
          ),
        ],
      ),

      // Alt Gezinme Çubuğu (Material 3 NavigationBar)
      bottomNavigationBar: NavigationBar(
        // Seçili olan buton indeksi
        selectedIndex: _currentIndex,
        // Kullanıcı bir sekmeye dokunduğunda indeksi güncelleyen callback
        onDestinationSelected: (index) {
          setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            _currentIndex = index;
          });
        },
        // Gezinme butonları listesi
        destinations: const [
          // 1. Buton: İlanlar Vitrini
          NavigationDestination(
            // Pasif durumdaki ikon
            icon: Icon(Icons.directions_car_outlined),
            // Seçili durumdaki dolu ikon
            selectedIcon: Icon(Icons.directions_car_rounded),
            // Buton etiketi
            label: 'İlanlar',
          ),
          // 2. Buton: İlan Ekleme Formu
          NavigationDestination(
            // Pasif durumdaki ikon
            icon: Icon(Icons.add_circle_outline_rounded),
            // Seçili durumdaki dolu ikon
            selectedIcon: Icon(Icons.add_circle_rounded),
            // Buton etiketi
            label: 'İlan Ver',
          ),
          // 3. Buton: Dijital Kokpit ve Anahtarım
          NavigationDestination(
            // Pasif durumdaki anahtar ikonu
            icon: Icon(Icons.key_outlined),
            // Seçili durumdaki dolu anahtar ikonu
            selectedIcon: Icon(Icons.key_rounded),
            // Buton etiketi
            label: 'Kokpit',
          ),
        ],
      ),
    );
  }
}
