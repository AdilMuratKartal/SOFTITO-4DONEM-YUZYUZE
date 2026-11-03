import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import 'core/services/json_data_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import 'providers/listing_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import 'providers/appointment_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import 'providers/chat_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import 'views/auth/login_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

void main() async { // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  WidgetsFlutterBinding.ensureInitialized();

  final jsonDataService = JsonDataService();
  final authProvider = AuthProvider(dataService: jsonDataService);
  final listingProvider = ListingProvider(dataService: jsonDataService);
  final appointmentProvider = AppointmentProvider(dataService: jsonDataService);
  final chatProvider = ChatProvider(dataService: jsonDataService);

  // JSON verilerini başlangıçta belleğe yükle
  await Future.wait([
    authProvider.init(),
    listingProvider.init(),
    appointmentProvider.init(),
    chatProvider.init(),
  ]);

  runApp( // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
    MultiProvider(
      providers: [ // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: listingProvider),
        ChangeNotifierProvider.value(value: appointmentProvider),
        ChangeNotifierProvider.value(value: chatProvider),
      ],
      child: const RandevuApp(),
    ),
  );
}

class RandevuApp extends StatelessWidget { // RandevuApp sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const RandevuApp({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return MaterialApp( // Flutter'ın Material Design temellerini ve yönlendirmesini başlatan ana MaterialApp widget'ı
      title: 'Randevu ve Hizmet Platformu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
