import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controllers/sepet_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz

 
class VitrinEkrani extends StatelessWidget{ // VitrinEkrani sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
    const VitrinEkrani({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir
    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    Widget build(BuildContext context){ // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
        return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
            appBar: AppBar(title:const Text('Canlı Vitrin(ValueNotifier)')), // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
                body:Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                    child:ElevatedButton.icon(
                        onPressed:(){
                            SepetKontrolu.ornek.sepeteEkle();
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Sepete Ürün Ekle(+1)'),
                    ),
                ),
        );
    }
}
