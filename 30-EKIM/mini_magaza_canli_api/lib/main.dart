// Flutter'ın temel Material bileşenlerini içeren kütüphaneyi içe aktarır
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Uygulamanın ana açılış sayfası olan canlı ürün listesi ekranını içe aktarır
import 'screens/urun_listesi_ekrani.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

// Dart ve Flutter uygulamalarının çalışmaya başladığı ana giriş fonksiyonu
void main() { // Dart ve Flutter uygulamasını başlatan ana giriş fonksiyonumuz
  // Widget ağacını başlatıp ekranın ilk çizimini yapan Flutter fonksiyonu
  runApp( // runApp ile uygulamanın kök widget'ını yükleyip çizim döngüsünü başlatıyoruz
    // Kök widget olarak MiniMagazaApiUygulamasi bileşenini bağlar
    const MiniMagazaApiUygulamasi(),
  // runApp fonksiyon çağrısının kapanışı
  );
// main fonksiyonunun kapanış parantezi
}

// Uygulamanın genel tema, yönlendirme ve yapılandırma ayarlarını barındıran kök widget
class MiniMagazaApiUygulamasi extends StatelessWidget { // MiniMagazaApiUygulamasi sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // MiniMagazaApiUygulamasi sınıfının değişmez (const) kurucu metodu
  const MiniMagazaApiUygulamasi({ // Genel, sabit sınıf constructor'ı
    // Üst sınıfa anahtar parametresini iletir
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Kök widget'ın görsel yapısını inşa eden build metodu
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // BuildContext parametresini alan ve Widget döndüren build fonksiyonu
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Material Design tasarım standartlarını uygulayan kök MaterialApp bileşeni
    return MaterialApp( // Flutter'ın Material Design temellerini ve yönlendirmesini başlatan ana MaterialApp widget'ı
      // Cihazın görev yöneticisinde görünecek uygulama başlığı
      title: 'Mini Mağaza Canlı API',
      // Sağ üst köşedeki kırmızı 'DEBUG' etiket bandını gizler
      debugShowCheckedModeBanner: false,
      // Uygulamanın genel görsel temasını belirleyen ThemeData yapılandırması
      theme: ThemeData(
        // Google Material Design 3 tasarım sistemini aktifleştirir
        useMaterial3: true,
        // Uygulamanın tüm renk paletini türeteceği tohum (seed) rengi (İndigo / Gece Mavisi)
        colorSchemeSeed: Colors.indigo,
        // Uygulama genelindeki AppBar varsayılan stil ayarları
        appBarTheme: const AppBarTheme(
          // AppBar başlığının ortalanmasını sağlar
          centerTitle: true, // Başlığı ortalamak için true veriyoruz
          // AppBar gölge yüksekliği
          elevation: 0, // Kartın arkasına gölge veriyoruz (z koordinatı)
        // AppBarTheme kapanışı
        ),
      // ThemeData kapanışı
      ),
      // Uygulama ilk açıldığında gösterilecek ana sayfa bileşeni
      home: const UrunListesiEkrani(),
    // MaterialApp kapanışı
    );
  // build metodu kapanış parantezi
  }
// MiniMagazaApiUygulamasi sınıfının kapanış parantezi
}
