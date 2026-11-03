import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:intl/date_symbol_data_local.dart'; // Tarih, para ve sayı formatlama işlemleri için intl paketini ekliyoruz
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import 'features/views/navigation/main_navigation_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

void main() async { // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  await NotificationService.init();
  runApp(const HabitTrackerApp()); // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
}

class HabitTrackerApp extends StatefulWidget { // HabitTrackerApp sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const HabitTrackerApp({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<HabitTrackerApp> createState() => _HabitTrackerAppState();
}

class _HabitTrackerAppState extends State<HabitTrackerApp> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _themeModeNotifier.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp( // Flutter'ın Material Design temellerini ve yönlendirmesini başlatan ana MaterialApp widget'ı
          title: 'Alışkanlık Takibi',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: MainNavigationView(themeModeNotifier: _themeModeNotifier),
        );
      },
    );
  }
}
