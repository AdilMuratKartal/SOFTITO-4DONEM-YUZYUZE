import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import 'features/water_tracker/controller/water_reminder_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import 'features/water_tracker/controller/water_tracker_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import 'features/water_tracker/view/water_tracker_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import 'features/workout/controller/workout_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import 'features/workout/view/workout_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

void main() { // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp()); // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
}

/// Susadım Uygulaması Kök Bileşeni
class SusadimApp extends StatelessWidget { // SusadimApp sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const SusadimApp({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp( // Flutter'ın Material Design temellerini ve yönlendirmesini başlatan ana MaterialApp widget'ı
          title: 'Susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const MainHomeScreen(),
        );
      },
    );
  }
}

/// Ana Ekran Gezinme ve Sekme Yönetimi
class MainHomeScreen extends StatefulWidget { // MainHomeScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const MainHomeScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  int _currentIndex = 0; // int türünden _currentIndex değişkenimiz
  late final WaterTrackerController _waterController;
  late final WaterReminderController _reminderController;
  late final WorkoutController _workoutController;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _waterController = WaterTrackerController();
    _reminderController = WaterReminderController();
    _workoutController = WorkoutController();
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _waterController.dispose();
    _reminderController.dispose();
    _workoutController.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final screens = [
      WaterTrackerView(
        controller: _waterController,
        reminderController: _reminderController,
      ),
      WorkoutView(controller: _workoutController),
    ];

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      appBar: _buildAppBar(context),
      body: screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      leading: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          child: Image.asset( // Projenin assets klasöründeki yerel resmi ekranda göstermek için
            'assets/images/app_logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.water_drop_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
      title: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.center, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          Text(
            'Susadım',
            style: theme.textTheme.titleMedium?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            _currentIndex == 0 ? 'Su Takibi' : 'Antrenman & Kalori',
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11), // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
          ),
        ],
      ),
      actions: [
        IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? const Color(0xFFFFD600) : const Color(0xFF5C6BC0),
          ),
          tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
          onPressed: () => ThemeController.instance.toggleTheme(),
        ),
        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
          _currentIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop_rounded),
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center_rounded),
          label: 'Egzersiz',
        ),
      ],
    );
  }
}
