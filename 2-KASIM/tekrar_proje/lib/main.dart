import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'screens/tekrar3.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz


void main() { // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  runApp(const MyApp()); // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
}


class MyApp extends StatelessWidget { // MyApp sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const MyApp({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  // This widget is the root of your application.
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routerConfig: uygulamaRotalari,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
