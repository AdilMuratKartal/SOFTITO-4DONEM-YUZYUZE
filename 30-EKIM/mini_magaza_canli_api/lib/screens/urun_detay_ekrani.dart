// Flutter temel arayüz kütüphanesini içe aktarır
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Detayları gösterilecek ürün veri modelini içe aktarır
import '../models/urun.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Kategori Türkçe adını almak için kategori modelini içe aktarır
import '../models/kategori.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Stok rozeti bileşenini içe aktarır
import '../widgets/stok_rozeti.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

// Tıklanan ürünün geniş görselini, açıklamasını ve satın alma butonunu sunan detay ekranı
class UrunDetayEkrani extends StatelessWidget { // UrunDetayEkrani sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // Ekranda gösterilecek olan ürün nesnesi
  final Urun urun; // Urun türünden urun adlı değişkenimiz

  // UrunDetayEkrani sınıfının kurucu metodu
  const UrunDetayEkrani({ // Genel, sabit sınıf constructor'ı
    // Widget ağacı için süper anahtar
    super.key,
    // Gösterilecek ürün nesnesinin zorunlu olduğunu belirtir
    required this.urun, // urun parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını inşa eden build metodu
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // BuildContext parametresini alan metot
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // Ekranın temel iskeletini sağlayan Scaffold bileşeni
    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      // Sayfanın üst başlık çubuğu (AppBar)
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        // Başlık metni
        title: const Text('Ürün Detayı'), // Sayfa başlığını ekrana yazdırıyoruz
        // Başlığı ortalar
        centerTitle: true, // Başlığı ortalamak için true veriyoruz
      // AppBar kapanışı
      ),
      // Sayfa içeriğinin taşmasını önleyen ve kaydırılmasını sağlayan SingleChildScrollView
      body: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
        // Tüm sayfa içeriği için kenar boşlukları
        padding: const EdgeInsets.all(16),
        // Sayfa elemanlarını dikeyde alt alta dizen Column bileşeni
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          // Elemanları sola yaslar
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          // Column çocukları listesi
          children: [
            // Liste ekranındaki küçük resimle eşleşen Hero animasyon widget'ı
            Hero(
              // Liste kartındaki etiket ile birebir aynı etiket (tag)
              tag: 'urun_resim_${urun.id}',
              // Resmi ortalayan Center widget'ı
              child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                // Sabit yüksekliğe sahip kutu
                child: SizedBox(
                  // Resmin dikey yüksekliği (240 piksel)
                  height: 240,
                  // İnternetten ürünün büyük halini çeken Image.network
                  child: Image.network( // İnternet üzerinden URL ile resim çekip ekranda göstermek için
                    // Ürünün FakeStore görsel adresi
                    urun.resimUrl,
                    // Resmin orijinal oranını koruyarak kutuya sığmasını sağlar
                    fit: BoxFit.contain,
                    // Görsel yüklenirken dönen çubuk gösterir
                    loadingBuilder: (context, child, progress) {
                      // Yükleme bittiyse resmi göster
                      if (progress == null) return child;
                      // Yüklenirken dönen çember
                      return const Center(child: CircularProgressIndicator()); // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                    // loadingBuilder kapanışı
                    },
                  // Image.network kapanışı
                  ),
                // SizedBox kapanışı
                ),
              // Center kapanışı
              ),
            // Hero kapanışı
            ),
            // Resim ile bilgiler arasına 20 piksel dikey boşluk
            const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Kategori adı ve Stok rozetini yan yana gösteren satır
            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              // İki uca yaslar
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
              // Satır çocukları
              children: [
                // Kategori adı kutusu
                Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  // Kutu içi kenar boşlukları
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  // Kutu dekorasyonu
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    // Açık indigo zemin rengi
                    color: Colors.indigo.shade50,
                    // Yuvarlatılmış köşeler
                    borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  // BoxDecoration kapanışı
                  ),
                  // Kategori adı metni
                  child: Text(
                    // Kategorinin Türkçe adı
                    urun.kategori.gorunenAd,
                    // Kategori stili
                    style: TextStyle(
                      // Yazı boyutu
                      fontSize: 12,
                      // Kalın yazı tipi
                      fontWeight: FontWeight.bold,
                      // İndigo renk
                      color: Colors.indigo.shade700,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                // Container kapanışı
                ),
                // Stok durum rozeti
                StokRozeti(stoktaVarMi: urun.stoktaVarMi),
              // Row çocukları kapanışı
              ],
            // Row kapanışı
            ),
            // 12 piksel dikey boşluk
            const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Ürün başlığını büyük puntolarla gösteren metin
            Text(
              // Ürünün tam başlığı
              urun.baslik,
              // Başlık metin stili
              style: const TextStyle(
                // Büyük yazı boyutu
                fontSize: 20,
                // Kalın yazı karakteri
                fontWeight: FontWeight.bold,
              // TextStyle kapanışı
              ),
            // Text kapanışı
            ),
            // 8 piksel dikey boşluk
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Puan, yıldız simgesi ve oy sayısını gösteren satır
            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              // Sıra elemanları
              children: [
                // Sarı yıldız simgesi
                const Icon(Icons.star, size: 20, color: Colors.amber),
                // 4 piksel boşluk
                const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                // Ortalama puan metni
                Text(
                  // Puan değeri
                  urun.degerlendirme.puan.toStringAsFixed(1),
                  // Puan stili
                  style: const TextStyle(
                    // Yazı boyutu
                    fontSize: 14,
                    // Kalın yazı
                    fontWeight: FontWeight.bold,
                  // TextStyle kapanışı
                  ),
                // Text kapanışı
                ),
                // 6 piksel boşluk
                const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                // Toplam oy sayısı metni
                Text(
                  // Oy adedi açıklaması
                  '(${urun.degerlendirme.oySayisi} değerlendirme)',
                  // Stil ayarı
                  style: TextStyle(
                    // Yazı boyutu
                    fontSize: 13,
                    // Gri renk
                    color: Colors.grey.shade600,
                  // TextStyle kapanışı
                  ),
                // Text kapanışı
                ),
              // Row çocukları kapanışı
              ],
            // Row kapanışı
            ),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // İnce ayırıcı çizgi
            const Divider(), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
            // 12 piksel dikey boşluk
            const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // 'Ürün Açıklaması' ara başlığı
            const Text(
              // Başlık metni
              'Ürün Açıklaması',
              // Başlık stili
              style: TextStyle(
                // Yazı boyutu
                fontSize: 16,
                // Kalın yazı tipi
                fontWeight: FontWeight.bold,
              // TextStyle kapanışı
              ),
            // Text kapanışı
            ),
            // 8 piksel dikey boşluk
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Ürünün uzun açıklama metni
            Text(
              // Açıklama metni içeriği
              urun.aciklama,
              // Açıklama metin stili
              style: TextStyle(
                // Yazı boyutu
                fontSize: 14,
                // Okunabilirlik için satır yüksekliği katsayısı
                height: 1.5,
                // Koyu gri yazı rengi
                color: Colors.grey.shade800,
              // TextStyle kapanışı
              ),
            // Text kapanışı
            ),
            // Sayfanın altındaki sabit barın üstünü kapatmaması için 40 piksel boşluk
            const SizedBox(height: 40), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          // Column çocukları kapanışı
          ],
        // Column kapanışı
        ),
      // SingleChildScrollView kapanışı
      ),
      // Ekranın en altında sabit duran fiyat ve satın alma çubuğu
      bottomNavigationBar: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        // Çubuk iç kenar boşlukları
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        // Çubuk zemin dekorasyonu
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          // Beyaz arka plan
          color: Colors.white,
          // Üste doğru hafif gölge efekti
          boxShadow: [
            // Kutu gölgesi tanımı
            BoxShadow(
              // Hafif siyah ton
              color: Colors.black.withOpacity(0.05),
              // Gölge yayılma yarıçapı
              blurRadius: 10,
              // Gölgenin yukarı doğru konumu
              offset: const Offset(0, -4),
            // BoxShadow kapanışı
            ),
          // boxShadow listesi kapanışı
          ],
        // BoxDecoration kapanışı
        ),
        // Güvenli alan (özellikle alt çizgiye sahip telefonlar için)
        child: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
          // Fiyat ile Butonu yan yana dizen Row bileşeni
          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            // İki uca yaslar
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
            // Elemanlar
            children: [
              // Fiyat sütunu
              Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                // Sütunun sadece kapladığı kadar alan tutmasını sağlar
                mainAxisSize: MainAxisSize.min,
                // Sola yaslar
                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                // Elemanlar
                children: [
                  // 'Toplam Fiyat' etiket metni
                  Text(
                    // Etiket içeriği
                    'Toplam Fiyat',
                    // Etiket stili
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  // Text kapanışı
                  ),
                  // 2 basamaklı ürün satış fiyatı
                  Text(
                    // Fiyat metni
                    '${urun.fiyat.toStringAsFixed(2)} ₺',
                    // Fiyat stili
                    style: TextStyle(
                      // Büyük yazı boyutu
                      fontSize: 20,
                      // Çok kalın yazı tipi
                      fontWeight: FontWeight.w800,
                      // İndigo renk
                      color: Colors.indigo.shade700,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                // Column çocukları kapanışı
                ],
              // Column kapanışı
              ),
              // Sepete ekleme butonu
              ElevatedButton.icon(
                // Stokta yoksa butonu devre dışı (null) bırakır, varsa tıklama eylemi atar
                onPressed: urun.stoktaVarMi
                    // Stokta var ise tıklanınca çalışacak fonksiyon
                    ? () {
                        // Kullanıcıya işlemin başarılı olduğunu bildiren SnackBar gösterir
                        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                          // Gösterilecek SnackBar içeriği
                          SnackBar(
                            // Bildirim mesajı metni
                            content: Text('${urun.baslik} sepete eklendi!'),
                            // SnackBar arka plan rengi
                            backgroundColor: Colors.green.shade700,
                            // Ekranda kalma süresi
                            duration: const Duration(seconds: 2),
                          // SnackBar kapanışı
                          ),
                        // showSnackBar kapanışı
                        );
                      // Tıklama fonksiyonu kapanışı
                      }
                    // Stokta yoksa null geçerek butonu tıkspanamaz (disabled) yapar
                    : null,
                // Butonun solundaki sepet ikonu
                icon: const Icon(Icons.shopping_cart),
                // Buton metni
                label: Text(urun.stoktaVarMi ? 'Sepete Ekle' : 'Tükendi'),
                // Buton stil ayarları
                style: ElevatedButton.styleFrom(
                  // Buton arka plan rengi
                  backgroundColor: Colors.indigo,
                  // Buton üzerindeki yazı ve ikon rengi
                  foregroundColor: Colors.white,
                  // Buton iç boşlukları
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  // Yuvarlak köşeler
                  shape: RoundedRectangleBorder(
                    // 12 piksellik ovallik
                    borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  // RoundedRectangleBorder kapanışı
                  ),
                // styleFrom kapanışı
                ),
              // ElevatedButton kapanışı
              ),
            // Row çocukları kapanışı
            ],
          // Row kapanışı
          ),
        // SafeArea kapanışı
        ),
      // Container kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// UrunDetayEkrani sınıfının kapanış parantezi
}
