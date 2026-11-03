import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'core/constants/app_strings.dart';
import 'core/extensions/context_extensions.dart';
import 'core/services/storage_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import 'core/theme/app_themes.dart';
import 'core/theme/controllers/theme_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import 'core/theme/models/app_theme_type.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import 'features/calendar_view/view/calendar_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import 'features/theme_selector/view/theme_selector_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import 'features/timeline/view/timeline_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

void main() async { // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  runApp(const IJournalApp()); // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
}

class IJournalApp extends StatelessWidget { // IJournalApp sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const IJournalApp({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final themeController = ThemeController.instance;

    return ValueListenableBuilder<JournalTheme>(
      valueListenable: themeController.currentTheme,
      builder: (context, activeTheme, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeController.currentMode,
          builder: (context, activeMode, _) {
            return MaterialApp( // Flutter'ın Material Design temellerini ve yönlendirmesini başlatan ana MaterialApp widget'ı
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              themeMode: activeMode,
              theme: AppThemes.getTheme(activeTheme, Brightness.light),
              darkTheme: AppThemes.getTheme(activeTheme, Brightness.dark),
              home: const MainNavigationShell(),
            );
          },
        );
      },
    );
  }
}

/// Ana alt menü ve gezinme kabuğu (Timeline, Calendar, ThemeSelector).
class MainNavigationShell extends StatefulWidget { // MainNavigationShell sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const MainNavigationShell({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  int _currentIndex = 0; // int türünden _currentIndex değişkenimiz

  final List<Widget> _screens = const [
    TimelineView(),
    CalendarView(),
    ThemeSelectorView(),
  ];

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      body: IndexedStack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          border: Border(
            top: BorderSide(
              color: style.borderColor.withValues(alpha: 0.3),
              width: style.borderWidth < 1.5 ? 1.0 : style.borderWidth,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: context.colors.surface,
          indicatorColor: context.colors.primary.withValues(alpha: 0.18),
          onDestinationSelected: (index) {
            setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: AppStrings.tabTimeline,
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: AppStrings.tabCalendar,
            ),
            NavigationDestination(
              icon: Icon(Icons.palette_outlined),
              selectedIcon: Icon(Icons.palette),
              label: AppStrings.tabThemes,
            ),
          ],
        ),
      ),
    );
  }
}
