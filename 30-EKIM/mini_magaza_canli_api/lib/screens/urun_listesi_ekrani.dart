// Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Ürün veri modelini içe aktarır
import '../models/urun.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Kategori enum ve extension yapısını içe aktarır
import '../models/kategori.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Ürün servisi soyut sözleşmesini (interface) içe aktarır
import '../services/i_urun_servisi.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
// Gerçek REST API ile haberleşen somut servis sınıfını içe aktarır
import '../services/api_urun_servisi.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
// Liste elemanları için hazırlanan ürün kartı bileşenini içe aktarır
import '../widgets/urun_karti.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
// Kart tıklandığında açılacak detay ekranını içe aktarır
import 'urun_detay_ekrani.dart';

// Canlı API'den ürünleri çeken, filtreleyen ve 4 durumu yöneten durumlu (Stateful) ana ekran widget'ı
class UrunListesiEkrani extends StatefulWidget { // UrunListesiEkrani sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  // Widget ağacı için kurucu metot
  const UrunListesiEkrani({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  // Ekranın durum (state) yöneticisini oluşturan metot
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // UrunListesiEkraniState durum nesnesini bağlar
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
// UrunListesiEkrani sınıfının kapanış parantezi
}

// Ekranın durum değişkenlerini, API çağrılarını ve UI mantığını barındıran State sınıfı
class _UrunListesiEkraniState extends State<UrunListesiEkrani> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  // Polimorfizm prensibi ile soyut arayüze bağlanan API servis referansı
  final IUrunServisi _servis = ApiUrunServisi();

  // Arama metin kutusunu kontrol eden ve temizleme işlemlerini yürüten kontrolcü
  final TextEditingController _aramaKontrolcusu = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz

  // API'den gelen orijinal ve eksiksiz ürün havuzu
  List<Urun> _tumUrunler = [];
  // Kullanıcının anlık arama ve kategori seçimine göre filtrelenmiş aktif liste
  List<Urun> _filtrelenmisUrunler = [];

  // Asenkron veri çekme işleminin devam edip etmediğini tutan bayrak
  bool _yukleniyor = true; // Durum kontrolü için tuttuğumuz bool bayrağımız (_yukleniyor)
  // Ağ veya sunucu hatası oluştuğunda hata metnini tutan değişken (hata yoksa null'dır)
  String? _hataMesaji;
  // Kullanıcının o anda seçili tuttuğu kategori filtresi (varsayılan: hepsi)
  Kategori _seciliKategori = Kategori.hepsi;

  // Widget ilk kez belleğe yüklendiğinde bir kez çalışan yaşam döngüsü metodu
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // initState metodunun gövdesi
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    // Üst sınıfın initState metodunu çağırır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    // Sayfa açılır açılmaz ürünleri API'den çekmeye başlar
    _urunleriYukle();
  // initState metodunun kapanış parantezi
  }

  // Widget ağaçtan kaldırıldığında bellek sızıntısını önleyen yaşam döngüsü metodu
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // dispose metodunun gövdesi
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    // Arama kontrolcüsünü bellekten serbest bırakır
    _aramaKontrolcusu.dispose();
    // Üst sınıfın dispose metodunu çağırır
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  // dispose metodunun kapanış parantezi
  }

  // FakeStore REST API'den ürünleri asenkron olarak çeken ana fonksiyon
  Future<void> _urunleriYukle() async {
    // Ekranı 'Yükleniyor' moduna sokmak ve eski hataları temizlemek için setState çağrılır
    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      // Yüklenme animasyonunu başlatır
      _yukleniyor = true;
      // Varsa önceki hata mesajını sıfırlar
      _hataMesaji = null;
    // setState kapanışı
    });

    // Olası ağ kopmaları, zaman aşımı ve format hataları için try bloğu
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      // Servis üzerinden HTTP GET isteğini atar ve ürün listesini bekler
      final urunler = await _servis.urunleriGetir();
      // Widget ağaçta hâlâ aktif mi kontrol eder (kullanıcı sayfa yüklenirken geri çıktıysa hata almamak için)
      if (!mounted) return;

      // Veriler başarıyla geldiyse durumu günceller
      setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
        // Ham ürün listesini kaydeder
        _tumUrunler = urunler;
        // Başlangıçta tüm ürünleri filtreli listeye de aktarır
        _filtrelenmisUrunler = urunler;
        // Yüklenme bayrağını kapatır
        _yukleniyor = false;
      // setState kapanışı
      });
      // Varsa mevcut filtreleri yeni listeye uygular
      _filtreleriUygula();
    // Ağ, zaman aşımı veya sunucu kaynaklı bir hata yakalandığında
    } catch (hata) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      // Widget ağaçta hâlâ aktif mi kontrol eder
      if (!mounted) return;
      // Ekranı 'Hata' durumuna geçirmek için setState çağrılır
      setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
        // Kullanıcıya gösterilecek anlaşılır hata metnini oluşturur
        _hataMesaji = 'Ürünler yüklenirken bir sorun oluştu.\nİnternet bağlantınızı kontrol edin.';
        // Yüklenme durumunu kapatır
        _yukleniyor = false;
      // setState kapanışı
      });
    // try-catch kapanışı
    }
  // _urunleriYukle fonksiyonu kapanış parantezi
  }

  // Hem arama metnini hem de seçili kategoriyi harmanlayarak listeyi süzen metot
  void _filtreleriUygula() {
    // Arama kutusundaki metni küçük harfe çevirip sağ ve soldaki boşlukları temizler
    final aramaMetni = _aramaKontrolcusu.text.toLowerCase().trim();

    // Filtrelenmiş listeyi güncelleyip UI'ı tetikler
    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      // Tüm ürün havuzunu filtreleme işleminden geçirir
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        // Kategori şartını inceler (hepsi seçiliyse veya ürünün kategorisi seçilenle aynıysa true)
        final kategoriUygun = _seciliKategori == Kategori.hepsi || urun.kategori == _seciliKategori;
        // Arama şartını inceler (kullanıcı bir şey yazmadıysa veya başlık metni arananı içeriyorsa true)
        final aramaUygun = aramaMetni.isEmpty || urun.baslik.toLowerCase().contains(aramaMetni);
        // İki şartın da sağlandığı ürünleri listede tutar
        return kategoriUygun && aramaUygun;
      // where filtreleme sonucu Iterable'ı Listeye dönüştürür
      }).toList();
    // setState kapanışı
    });
  // _filtreleriUygula fonksiyonu kapanış parantezi
  }

  // Kullanıcı yatay bardaki bir kategori çipine tıkladığında çalışan metot
  void _kategoriDegistir(Kategori yeniKategori) {
    // Seçili kategoriyi günceller
    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      // Yeni kategoriyi kaydeder
      _seciliKategori = yeniKategori;
    // setState kapanışı
    });
    // Yeni kategoriye göre listeyi yeniden filtreler
    _filtreleriUygula();
  // _kategoriDegistir kapanış parantezi
  }

  // Ekranın görsel ağacını kuran ana build fonksiyonu
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // BuildContext parametresini alan build fonksiyonu
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Temel sayfa iskeletini sağlayan Scaffold
    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      // Sayfanın üst başlık çubuğu
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        // Başlık metni
        title: const Text('Mini Mağaza (Canlı API)'), // Sayfa başlığını ekrana yazdırıyoruz
        // Başlığı ortalar
        centerTitle: true, // Başlığı ortalamak için true veriyoruz
        // AppBar sağ üst köşesindeki hızlı işlem butonları
        actions: [
          // Elle yenileme yapmayı sağlayan yenile butonu
          IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
            // Yenile simgesi
            icon: const Icon(Icons.refresh),
            // Tıklanınca ürünleri sıfırdan çeker
            onPressed: _urunleriYukle,
            // Ekran okuyucular için ipucu metni
            tooltip: 'Yenile',
          // IconButton kapanışı
          ),
        // actions listesi kapanışı
        ],
      // AppBar kapanışı
      ),
      // Sayfanın ana gövdesini oluşturan dikey sütun (Column)
      body: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        // Sütun içi alt bileşenler listesi
        children: [
          // Canlı arama kutusunun dış kenar boşluklarını belirleyen Padding
          Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
            // Yatayda 16, dikeyde 8 piksel boşluk
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // Kullanıcının metin girdiği TextField bileşeni
            child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
              // Metin kontrolcüsünü bağlar
              controller: _aramaKontrolcusu,
              // Kullanıcı her harf yazdığında veya sildiğinde filtreyi anlık tetikler
              onChanged: (_) => _filtreleriUygula(),
              // Arama kutusunun görsel süslemesi
              decoration: InputDecoration(
                // Kutu boşken görünen ipucu metni
                hintText: 'Ürün ara...',
                // Kutunun sol başındaki büyüteç simgesi
                prefixIcon: const Icon(Icons.search),
                // Kullanıcı yazı yazdığında beliren çarpı (temizle) butonu
                suffixIcon: _aramaKontrolcusu.text.isNotEmpty
                    // Metin varsa temizleme ikon butonu gösterir
                    ? IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                        // Çarpı ikonu
                        icon: const Icon(Icons.clear),
                        // Tıklandığında metin kutusunu temizler ve listeyi tazeler
                        onPressed: () {
                          // Metni sıfırlar
                          _aramaKontrolcusu.clear();
                          // Filtreyi yeniler
                          _filtreleriUygula();
                        // onPressed kapanışı
                        },
                      // IconButton kapanışı
                      )
                    // Metin yoksa sağ tarafı boş bırakır
                    : null,
                // Kutunun iç dolgulu olmasını sağlar
                filled: true,
                // Kutu zemin rengi (çok açık gri)
                fillColor: Colors.grey.shade100,
                // Kutunun köşelerini yuvarlatan kenarlık tanımı
                border: OutlineInputBorder(
                  // 12 piksellik ovallik
                  borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  // Varsayılan sınır çizgisini kaldırır
                  borderSide: BorderSide.none,
                // OutlineInputBorder kapanışı
                ),
              // InputDecoration kapanışı
              ),
            // TextField kapanışı
            ),
          // Padding kapanışı
          ),
          // Kategorileri yatayda kaydırılabilir sunan sabit yükseklikli alan
          SizedBox(
            // Yatay çubuğun dikey yüksekliği (48 piksel)
            height: 48,
            // Yatay eksende kaydırılabilir liste
            child: ListView.separated(
              // Kaydırma yönünü yatay yapar
              scrollDirection: Axis.horizontal,
              // Çubuğun sağ ve solundaki iç boşluklar
              padding: const EdgeInsets.symmetric(horizontal: 16),
              // Toplam kategori sayısı kadar eleman üretir
              itemCount: Kategori.values.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              // Çipler arasına 8 piksel yatay boşluk koyar
              separatorBuilder: (context, index) => const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // Her bir kategori için ChoiceChip üreten builder
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                // Sıradaki kategori nesnesini alır
                final kategori = Kategori.values[index];
                // Bu kategorinin seçili olup olmadığını belirler
                final seciliMi = _seciliKategori == kategori;

                // Tıklanabilir ve seçilebilir çip bileşeni
                return ChoiceChip(
                  // Çip üzerinde görünen Türkçe metin
                  label: Text(kategori.gorunenAd),
                  // Çipin seçili olma durumu
                  selected: seciliMi,
                  // Çipe tıklandığında kategoriyi değiştiren eylem
                  onSelected: (secildi) {
                    // Seçildiyse yeni kategoriyi atar
                    if (secildi) _kategoriDegistir(kategori);
                  // onSelected kapanışı
                  },
                  // Seçili çipin zemin rengi
                  selectedColor: Colors.indigo.shade100,
                  // Seçili çipin üzerindeki yazı ve simge rengi
                  labelStyle: TextStyle(
                    // Seçili ise lacivert, değilse koyu gri yazı
                    color: seciliMi ? Colors.indigo.shade900 : Colors.grey.shade800,
                    // Seçili ise kalın yazı
                    fontWeight: seciliMi ? FontWeight.bold : FontWeight.normal,
                  // TextStyle kapanışı
                  ),
                // ChoiceChip kapanışı
                );
              // itemBuilder kapanışı
              },
            // ListView.separated kapanışı
            ),
          // SizedBox kapanışı
          ),
          // 4 piksel dikey boşluk
          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          // Kalan ekran alanını kaplayan ve 4 asenkron durumu yöneten Expanded bileşeni
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            // 4 UI durumunu koşullu olarak ekrana basan ana gövde inşa edicisi
            child: _durumaGoreGovdeyiOlustur(),
          // Expanded kapanışı
          ),
        // Column çocukları kapanışı
        ],
      // Column kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }

  // 4 Asenkron Durumu (Loading, Error, Empty, Success) yöneten yardımcı metot
  Widget _durumaGoreGovdeyiOlustur() {
    // DURUM 1: Veriler internetten çekilirken ekranda loading gösterir
    if (_yukleniyor) {
      // Ortalanmış yüklenme alanı
      return const Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
        // İlerlemeyi gösteren dikey sütun
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          // Dikeyde ortalar
          mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
          // Elemanlar
          children: [
            // Dairesel ilerleme indikatörü
            CircularProgressIndicator(), // Veri yüklenirken kullanıcıya işlemin sürdüğünü gösteren yuvarlak animasyon
            // 16 piksel boşluk
            SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Kullanıcıya bilgi veren açıklama metni
            Text('FakeStore API\'den ürünler yükleniyor...'),
          // Column çocukları kapanışı
          ],
        // Column kapanışı
        ),
      // Center kapanışı
      );
    // Loading durumu sonu
    }

    // DURUM 2: Ağ kesintisi veya sunucu hatası oluştuğunda hata ekranı ve Tekrar Dene butonu gösterir
    if (_hataMesaji != null) {
      // Ortalanmış hata alanı
      return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
        // Kenar boşlukları
        child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
          // 24 piksellik iç boşluk
          padding: const EdgeInsets.all(24),
          // Elemanları dikeyde dizen Column
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            // Dikeyde ortalar
            mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
            // Elemanlar
            children: [
              // Kırmızı renkli ünlem hata simgesi
              const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
              // 16 piksel boşluk
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // Hata açıklama metni
              Text(
                // Hata metni içeriği
                _hataMesaji!,
                // Metni ortalar
                textAlign: TextAlign.center,
                // Metin stili
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              // Text kapanışı
              ),
              // 20 piksel boşluk
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // Kullanıcının işlemi tekrar başlatmasını sağlayan buton
              ElevatedButton.icon(
                // Tıklanınca yükleme fonksiyonunu yeniden çağırır
                onPressed: _urunleriYukle,
                // Yenile ikonu
                icon: const Icon(Icons.refresh),
                // Buton başlığı
                label: const Text('Tekrar Dene'),
                // Buton stili
                style: ElevatedButton.styleFrom(
                  // Buton arka plan rengi
                  backgroundColor: Colors.indigo,
                  // Buton yazı ve ikon rengi
                  foregroundColor: Colors.white,
                // styleFrom kapanışı
                ),
              // ElevatedButton kapanışı
              ),
            // Column çocukları kapanışı
            ],
          // Column kapanışı
          ),
        // Padding kapanışı
        ),
      // Center kapanışı
      );
    // Hata durumu sonu
    }

    // DURUM 3: Arama veya kategori filtresi sonucunda hiç ürün kalmadıysa boş durum (empty state) gösterir
    if (_filtrelenmisUrunler.isEmpty) {
      // Ortalanmış boşluk ekranı
      return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
        // Elemanları dikeyde ortalar
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          // Dikeyde ortalar
          mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
          // Elemanlar
          children: [
            // Arama sonucu bulunamadı simgesi
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            // 16 piksel boşluk
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Uyarı metni
            Text(
              // Kullanıcıya rehberlik eden mesaj
              'Aradığınız kriterlere uygun ürün bulunamadı.',
              // Stil
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            // Text kapanışı
            ),
          // Column çocukları kapanışı
          ],
        // Column kapanışı
        ),
      // Center kapanışı
      );
    // Boş durum sonu
    }

    // DURUM 4: Veriler başarıyla geldi ve listelenebilir durumda (Success State)
    // Kullanıcı listeyi aşağı doğru çektiğinde verileri yenileyen RefreshIndicator bileşeni
    return RefreshIndicator(
      // Çekip bırakıldığında çalışan asenkron yenileme fonksiyonu
      onRefresh: _urunleriYukle,
      // Ürün kartlarını verimli şekilde listeleyen ListView.builder
      child: ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
        // Listenin alt ve üstüne iç boşluk verir
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        // Filtrelenmiş ürün adedi kadar satır çizer
        itemCount: _filtrelenmisUrunler.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
        // Her bir indeks için ürün kartı inşa eden fonksiyon
        itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
          // Sıradaki ürün nesnesini çeker
          final urun = _filtrelenmisUrunler[index];
          // Her ürün için UrunKarti bileşenini üretir
          return UrunKarti(
            // Kartın göstereceği ürün nesnesi
            urun: urun,
            // Karta tıklandığında detay ekranına geçiş yapan fonksiyon
            onTap: () {
              // Navigator ile yeni rotaya geçiş yapar
              Navigator.push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
                // Mevcut sayfa bağlamı (context)
                context,
                // Sayfalar arası geçiş animasyonunu sağlayan MaterialPageRoute
                MaterialPageRoute(
                  // Detay ekranını inşa eden builder
                  builder: (context) => UrunDetayEkrani(urun: urun),
                // MaterialPageRoute kapanışı
                ),
              // push kapanışı
              );
            // onTap kapanışı
            },
          // UrunKarti kapanışı
          );
        // itemBuilder kapanışı
        },
      // ListView.builder kapanışı
      ),
    // RefreshIndicator kapanışı
    );
  // _durumaGoreGovdeyiOlustur fonksiyonu kapanış parantezi
  }
// _UrunListesiEkraniState sınıfının kapanış parantezi
}
