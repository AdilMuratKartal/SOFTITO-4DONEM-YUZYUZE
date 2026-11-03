///KATEGORİ DURUMLARINI EKLEMEDİK ŞİMDİLİK BEKLİYOR.
///BİRDE SAYFADA AŞAĞI İNDİKÇE TEKRAR BÜTÜN SAYFA YÜKLENİYOR ONADA BAKMAM LAZI .M BIRAKTIM SONRAYA
///BİRDE TIKLANMA DURUMLARINDA BİRŞEY YOKTUR SADE ZİYA, INKWELL BOŞA GİTTİ YANİ

import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:tekrar_proje_2/models/urun_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import 'package:tekrar_proje_2/services/i_urun_servisi.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz

import '../widgets/urun_karti.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

class UrunListeEkrani extends StatefulWidget { // UrunListeEkrani sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const UrunListeEkrani({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<UrunListeEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListeEkrani> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  final IUrunServisi _urunServisi = CanliApiUrunServisi();
  List<UrunModel> _tumUrunler = [];
  bool _yukleniyorMu = false; // Durum kontrolü için tuttuğumuz bool bayrağımız (_yukleniyorMu)

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _urunleriYukle();
  }

  Future<void> _urunleriYukle() async {
    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      _yukleniyorMu = true;
    });

    final urunler = await _urunServisi.urunleriGetir();

    if (mounted) {
      setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
        _tumUrunler = urunler;
        _yukleniyorMu = false;
      });
    }
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text( // Sayfa başlığını ekrana yazdırıyoruz
          "Test Api Sayfasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "Google Sans",
          ),
        ),
        centerTitle: true, // Başlığı ortalamak için true veriyoruz
      ),
      body: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        children: [
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: _yukleniyorMu
                ? const Center(child: CircularProgressIndicator()) // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                : _tumUrunler.isEmpty
                ? Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                    child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                      mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Text(
                          'Urunler Bulunamadı',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
                    itemCount: _tumUrunler.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                    itemBuilder: (BuildContext context, int index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                      final urun = _tumUrunler[index];
                      return UrunKarti(urun: urun);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
