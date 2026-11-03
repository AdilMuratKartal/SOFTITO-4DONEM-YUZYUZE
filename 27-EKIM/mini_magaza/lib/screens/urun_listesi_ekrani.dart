import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

import'../models/kategori.dart';
import '../models/urun.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../services/i_urun_servisi.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import '../services/mock_urun_servisi.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import '../widgets/urun_karti.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

class UrunListesiEkrani extends StatefulWidget{//dinamik olarak değişeceği için stateful ypıyoruz. state hem veriler çekşldiği için hemde widget verilerini tuttuğu için state
    const UrunListesiEkrani({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();

}

class _UrunListesiEkraniState extends State<UrunListesiEkrani>{ // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
    final IUrunServisi _servis = MockUrunServisi();
    bool _yukleniyorMu = true; // Durum kontrolü için tuttuğumuz bool bayrağımız (_yukleniyorMu)
    
    final TextEditingController _aramaController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz

    Kategori _seciliKategori = Kategori.hepsi;//başlangıç değeri
    
    String _aramaKelimesi = ""; // String türünden _aramaKelimesi değişkenimiz

    List<Urun> _filtrelenmisUrunler = [];
    List<Urun> _tumUrunler = [];

    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    void initState(){ // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
        super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
        _urunleriYukle();
    }

    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    void dispose(){ // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
        _aramaController.dispose();
        super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz

    }

    Future<void> _urunleriYukle() async{

        setState((){ // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            _yukleniyorMu = true;
        });
        
        //final urunler = await _servis.kategoriyeGoreGetir(_seciliKategori);//birde tüm verilerimi çekmemiz lazım filtre uyguladım değişicek filtre uygulamadım hepsi gelicek. bu sayede tekrar tekrar api çağırısı yapmıyacağız

        final urunler = await _servis.tumUrunleriGetir();

        if(mounted){
            setState((){ // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                _tumUrunler = urunler;
                _filtrelenmisUrunler = urunler;
                _yukleniyorMu = false;
            });
        };
    }

    void _filtreUygula(){
        final aranan = _aramaController.text.trim().toLowerCase();

        setState((){ // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            _filtrelenmisUrunler = _tumUrunler.where((urun){
                final kategoriUygunMu = (_seciliKategori == Kategori.hepsi) || (urun.kategori == _seciliKategori);
                final aramaUygunMu = aranan.isEmpty || urun.baslik.toLowerCase().contains(aranan) || urun.aciklama.toLowerCase().contains(aranan);
                return kategoriUygunMu && aramaUygunMu;
            }).toList();
        });
    }

    void _favoriyiDegistir(Urun hedefUrun){
        setState((){ // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            final yeniUrun = hedefUrun.copyWith(favoriMi:!hedefUrun.favoriMi); // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
            final index = _tumUrunler.indexWhere((u)=> u.id == hedefUrun.id);
            if(index != -1){
                _tumUrunler[index] = yeniUrun;
            } 
            _filtreUygula();
        });
    }

    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    Widget build(BuildContext context){ // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
        return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
            appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
                title: const Text("Mini Mağaza", // Sayfa başlığını ekrana yazdırıyoruz
                style:TextStyle(
                    fontWeight:FontWeight.bold,

                ),),
                centerTitle: true, // Başlığı ortalamak için true veriyoruz
                actions:[
                    Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                        padding:const EdgeInsets.only(right:16.0),
                        child:Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                            child:Badge(
                                label:Text(//text child almaz, text'le ilgili şeyler olur biri metin biri stili
                                    '${_tumUrunler.where((u)=>u.favoriMi).length}',
                                    style:const TextStyle(
                                        fontWeight:FontWeight.bold
                                    ),
                                ),
                                child:const Icon(Icons.favorite,color:Colors.red),
                            ),
                        ),
                    ),
                ],
            ),
            body:Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                children:[
                    Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                        padding:const EdgeInsets.fromLTRB(16,8,16,4),
                        child:TextField( // Kullanıcıdan metin girdisi almak için form alanı
                            controller:_aramaController,
                            onChanged: (_) => _filtreUygula(),
                            decoration: InputDecoration(
                                hintText:"Ürün veya marka ara...",
                                prefixIcon:const Icon(Icons.search),
                                suffixIcon:_aramaController.text.isNotEmpty ? IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                                    icon:const Icon(Icons.clear),
                                    onPressed:(){
                                        _aramaController.clear();
                                        _filtreUygula();
                                    }
                                ) : null,
                                filled:true,
                                fillColor:Colors.grey.shade100,
                                border:OutlineInputBorder(
                                    borderRadius:BorderRadius.circular(12),
                                    borderSide:BorderSide.none,
                                ),
                                contentPadding:const EdgeInsets.symmetric(vertical:0),
                            )
                        )
                    ),
                    SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
                        scrollDirection:Axis.horizontal,
                        padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),
                        child:Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            children:Kategori.values.map((kategori){
                                final seciliMi = _seciliKategori == kategori;
                                return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                                    padding: const EdgeInsets.symmetric(horizontal:4.0),
                                    child:ChoiceChip(
                                        avatar:Text(kategori.ikon),
                                        label:Text(kategori.baslik),
                                        selected:seciliMi,
                                        onSelected:(secildi){
                                            if(secildi){
                                                setState((){ // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                                                    _seciliKategori = kategori;
                                                    _filtreUygula();
                                                });
                                            };
                                        },
                                    ),
                                );
                            }).toList(),
                        ),
                    ),
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                        child: _yukleniyorMu ? const Center(child: CircularProgressIndicator()) : _filtrelenmisUrunler.isEmpty ? Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                                mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                                children: [
                                    Icon(Icons.search_off_rounded,size:64,color:Colors.grey.shade400),
                                    const SizedBox(height:12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Text(
                                        'Aradığınız kriterlere uygun ürün bulunamadı.',
                                        style:TextStyle(color:Colors.grey.shade600,fontSize:16,fontWeight:FontWeight.w600)
                                    ),
                                ],
                            ),
                        ) 
                        : ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
                            itemCount:_filtrelenmisUrunler.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                            itemBuilder:(context,index){ // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                                final urun = _filtrelenmisUrunler[index];
                                return UrunKarti(
                                    urun:urun.copyWith(resimUrl: "https://picsum.photos/400/400?random=${urun.id}"),//resimlerin ön belleğe alınmasını engellemek için picsumda olan random parametresini kullanıcaz
                                    onFavoriTiklandi:()=>_favoriyiDegistir(urun),
                                    onDetayTiklandi:()=>{
                                        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                                            SnackBar(
                                                content:Text('${urun.baslik} tıklandı!'),
                                                duration: const Duration(milliseconds:600),
                                            ),
                                        ),
                                    },
                                );
                            },
                        ),
                    ),
                ],
            )
        ); 
    }
    
}
