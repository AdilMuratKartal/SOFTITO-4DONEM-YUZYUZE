import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'screens/urun_listesi_ekrani.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

void main(){ // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  runApp(const MiniMagazaUygulamasi()); // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
}

class MiniMagazaUygulamasi extends StatelessWidget{ // MiniMagazaUygulamasi sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const MiniMagazaUygulamasi({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context){ // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return MaterialApp( // Flutter'ın Material Design temellerini ve yönlendirmesini başlatan ana MaterialApp widget'ı
      debugShowCheckedModeBanner: false,
      title:"Mini Mağaza",
      theme:ThemeData(
        useMaterial3:true,
        colorScheme:ColorScheme.fromSeed(
          seedColor:Colors.indigo,
          brightness:Brightness.light,
        ),),
        home:const UrunListesiEkrani(),
      );

  }
}