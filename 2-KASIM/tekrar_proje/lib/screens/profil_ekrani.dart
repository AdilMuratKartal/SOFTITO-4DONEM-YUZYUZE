import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controllers/sepet_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz

class ProfilEkrani extends StatelessWidget{ // ProfilEkrani sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
    const ProfilEkrani({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir
    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    Widget build(BuildContext context){ // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
        return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
            appBar:AppBar(title:const Text("Kullanıcı Profili")),
            body:Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                child:TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                    onPressed:()=> SepetKontrolu.ornek.sepetSifirla(),
                    child: const Text('Sepeti Temizle(0 yap)'),
                ),
            ),
        );
    }
}