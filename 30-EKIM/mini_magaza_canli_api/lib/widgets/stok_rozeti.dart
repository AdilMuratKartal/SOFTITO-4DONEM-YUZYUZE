// Flutter'ın temel Material bileşenlerini içe aktarır
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

// Bir ürünün stokta olup olmadığını renkli rozet (badge) olarak gösteren tekrar kullanılabilir widget
class StokRozeti extends StatelessWidget { // StokRozeti sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Ürünün stokta var olup olmadığını belirten boolean değer
  final bool stoktaVarMi; // bool türünden stoktaVarMi adlı değişkenimiz

  // StokRozeti sınıfının değişmez (const) kurucu metodu
  const StokRozeti({ // Genel, sabit sınıf constructor'ı
    // Widget ağacı için opsiyonel anahtar parametresi
    super.key,
    // Stok bilgisinin zorunlu parametre olduğunu belirtir
    required this.stoktaVarMi, // stoktaVarMi parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  // Kurucu metodun kapanış parantezi
  });

  // Widget'ın görsel ağacını inşa eden build metodu
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // BuildContext parametresi ile Build metodunun gövdesi
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Rozetin dış kutusunu ve kenarlık/arka plan özelliklerini belirleyen Container
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      // Rozet içi kenar boşlukları (iç padding)
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // Rozetin görsel dekorasyon özellikleri
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        // Stokta varsa yeşil, tükenmişse kırmızı arka plan rengi
        color: stoktaVarMi
            // Stokta var ise açık yeşil tonu
            ? Colors.green.shade50
            // Tükendi ise açık kırmızı tonu
            : Colors.red.shade50,
        // Rozetin köşelerini yuvarlatan yarıçap tanımı
        borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        // Rozetin dışına ince zarif bir çerçeve çizgisi çizer
        border: Border.all(
          // Çerçeve rengini duruma göre yeşil veya kırmızı yapar
          color: stoktaVarMi
              // Stokta var ise yeşil çerçeve
              ? Colors.green.shade300
              // Tükendi ise kırmızı çerçeve
              : Colors.red.shade300,
          // Çerçeve kalınlığı (1 piksel)
          width: 1,
        // Border.all kapanışı
        ),
      // BoxDecoration kapanışı
      ),
      // Rozet içindeki metin widget'ı
      child: Text(
        // Stok durumuna göre ekranda gösterilecek metin
        stoktaVarMi ? 'Stokta Var' : 'Tükendi',
        // Metin stil özellikleri
        style: TextStyle(
          // Yazı tipi boyutu
          fontSize: 11,
          // Yazı kalınlığı (yarı kalın)
          fontWeight: FontWeight.w600,
          // Metin rengini duruma göre koyu yeşil veya koyu kırmızı yapar
          color: stoktaVarMi
              // Koyu yeşil metin rengi
              ? Colors.green.shade800
              // Koyu kırmızı metin rengi
              : Colors.red.shade800,
        // TextStyle kapanışı
        ),
      // Text widget kapanışı
      ),
    // Container widget kapanışı
    );
  // build metodu kapanış parantezi
  }
// StokRozeti sınıfının kapanış parantezi
}
