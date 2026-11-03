import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

import '../models/urun_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class UrunKarti extends StatelessWidget { // UrunKarti sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final UrunModel urun; // UrunModel türünden urun adlı değişkenimiz
  const UrunKarti({super.key, required this.urun}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      elevation: 2, //cartın arkasına gölge veriyor. z koordi natı
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
      child: InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
        borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
          padding: const EdgeInsets.all(10.0),
          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            crossAxisAlignment: CrossAxisAlignment.center, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              Image.network( // İnternet üzerinden URL ile resim çekip ekranda göstermek için
                urun.resimUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                    width: 90,
                    height: 90,
                    child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                      child: CircularProgressIndicator(strokeWidth: 2), // Veri yüklenirken kullanıcıya işlemin sürdüğünü gösteren yuvarlak animasyon
                    ),
                  );
                },
              ),
              const SizedBox(width: 15), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                //metinler taşıp patlamasın diye
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    Text(
                      urun.kategori,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                    Text(
                      urun.baslik,
                      maxLines: 2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                      overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                    Text(
                      '${urun.fiyat.toString()} ₺', // as String dönüşümü covariant gibi alt sınıfa dönüştürme durumlarında kullanılıyormuş tip ancak bu kadar değişiyor
                      style: TextStyle(
                        color: Colors.blueAccent.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
