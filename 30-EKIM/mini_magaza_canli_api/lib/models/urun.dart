// Kategori numaralandırmasının (enum) ve extension metodunun tanımlandığı dosyayı içe aktarır
import 'kategori.dart';
// Ürünün puan ve oy bilgilerini tutan Degerlendirme modelini içe aktarır
import 'degerlendirme.dart';

// Mağazada satılan bir ürünü temsil eden değişmez (immutable) veri modeli
class Urun { // Urun sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  // Ürünün REST API'deki benzersiz kimlik numarası
  final int id; // int türünden id adlı değişkenimiz
  // Ürünün adı / başlığı (Örnek: Fjallraven Çanta)
  final String baslik; // String türünden baslik adlı değişkenimiz
  // Ürünün para birimi cinsinden satış fiyatı
  final double fiyat; // double türünden fiyat adlı değişkenimiz
  // Ürünün detaylı açıklaması
  final String aciklama; // String türünden aciklama adlı değişkenimiz
  // Ürünün ait olduğu tip güvenli kategori
  final Kategori kategori; // Kategori türünden kategori adlı değişkenimiz
  // Ürünün uzaktaki fotoğrafına işaret eden doğrudan URL bağlantısı
  final String resimUrl; // String türünden resimUrl adlı değişkenimiz
  // Ürünün puan ve oy adedini barındıran alt (nested) model
  final Degerlendirme degerlendirme; // Degerlendirme türünden degerlendirme adlı değişkenimiz
  // Ürünün depoda fiziksel olarak bulunup bulunmadığı bilgisi
  final bool stoktaVarMi; // bool türünden stoktaVarMi adlı değişkenimiz

  // Urun sınıfının const kurucu (constructor) metodu
  const Urun({ // Genel, sabit sınıf constructor'ı
    // Benzersiz kimliğin zorunlu olduğunu belirten alan
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Başlık alanının zorunlu olduğunu belirten parametre
    required this.baslik, // baslik parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Fiyat alanının zorunlu olduğunu belirten parametre
    required this.fiyat, // fiyat parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Açıklama alanının zorunlu olduğunu belirten parametre
    required this.aciklama, // aciklama parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Kategori alanının zorunlu olduğunu belirten parametre
    required this.kategori, // kategori parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Resim bağlantısının zorunlu olduğunu belirten parametre
    required this.resimUrl, // resimUrl parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Değerlendirme nesnesinin zorunlu olduğunu belirten parametre
    required this.degerlendirme, // degerlendirme parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Stok bilgisinin varsayılan olarak true geldiği opsiyonel parametre
    this.stoktaVarMi = true, // stoktaVarMi alanına değer aktarıyoruz
  // Yapıcı metodun kapanış parantezi
  });

  // FakeStore REST API'den gelen dinamik JSON haritasını tip güvenli Urun nesnesine çeviren fabrika kurucu
  factory Urun.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    // Yeni bir Urun nesnesi inşa ederek geriye döndürür
    return Urun(
      // int gelebilecek id değerini num üzerinden güvenle int'e dönüştürür
      id: (json['id'] as num).toInt(),
      // API'den gelen title alanını String olarak okur, null ise boş metin atar
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      // API'den gelen fiyat tam sayı (109) veya ondalıklı (109.95) gelse de tip çökmesini önlemek için num.toDouble() kullanılır
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      // API'den gelen description alanını güvenle okur
      aciklama: json['description'] as String? ?? '',
      // API'den gelen ham String kategori metnini enum değerine dönüştürür
      kategori: KategoriExtension.apiMetnindenUret(json['category'] as String? ?? ''),
      // API'den gelen resim URL bağlantısını okur
      resimUrl: json['image'] as String? ?? '',
      // rating alanındaki iç içe JSON nesnesini Degerlendirme modeline dönüştürür
      degerlendirme: json['rating'] != null
          // rating nesnesi varsa Degerlendirme.fromJson ile çözümler
          ? Degerlendirme.fromJson(json['rating'] as Map<String, dynamic>)
          // rating nesnesi yoksa varsayılan 0 puanlı güvenli nesne üretir
          : const Degerlendirme(puan: 0.0, oySayisi: 0),
      // FakeStore API'de stok alanı bulunmadığından oy sayısı 0 olan ürünler temsili olarak stok dışı sayılır
      stoktaVarMi: ((json['rating']?['count'] as num?)?.toInt() ?? 10) > 0,
    // Urun inşa çağrısının kapanışı
    );
  // fromJson fabrika metodunun kapanış parantezi
  }

  // Mevcut ürün nesnesini kopyalayıp sadece istenen alanları güncelleyen yardımcı metot
  Urun copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    // Yeni id (verilmezse eskisi korunur)
    int? id,
    // Yeni başlık (verilmezse eskisi korunur)
    String? baslik,
    // Yeni fiyat (verilmezse eskisi korunur)
    double? fiyat,
    // Yeni açıklama (verilmezse eskisi korunur)
    String? aciklama,
    // Yeni kategori (verilmezse eskisi korunur)
    Kategori? kategori,
    // Yeni resim URL (verilmezse eskisi korunur)
    String? resimUrl,
    // Yeni değerlendirme bilgisi (verilmezse eskisi korunur)
    Degerlendirme? degerlendirme,
    // Yeni stok durumu (verilmezse eskisi korunur)
    bool? stoktaVarMi,
  // copyWith parametre listesi kapanışı
  }) {
    // Güncellenmiş alanlarla yeni bir Urun nesnesi üretir
    return Urun(
      // Verilmişse yeni id'yi, verilmemişse mevcut id'yi kullanır
      id: id ?? this.id, // id alanına değer aktarıyoruz
      // Verilmişse yeni başlığı, verilmemişse mevcut başlığı kullanır
      baslik: baslik ?? this.baslik, // baslik alanına değer aktarıyoruz
      // Verilmişse yeni fiyatı, verilmemişse mevcut fiyatı kullanır
      fiyat: fiyat ?? this.fiyat, // fiyat alanına değer aktarıyoruz
      // Verilmişse yeni açıklamayı, verilmemişse mevcut açıklamayı kullanır
      aciklama: aciklama ?? this.aciklama, // aciklama alanına değer aktarıyoruz
      // Verilmişse yeni kategoriyi, verilmemişse mevcut kategoriyi kullanır
      kategori: kategori ?? this.kategori, // kategori alanına değer aktarıyoruz
      // Verilmişse yeni resim linkini, verilmemişse mevcut resim linkini kullanır
      resimUrl: resimUrl ?? this.resimUrl, // resimUrl alanına değer aktarıyoruz
      // Verilmişse yeni değerlendirmeyi, verilmemişse mevcut değerlendirmeyi kullanır
      degerlendirme: degerlendirme ?? this.degerlendirme, // degerlendirme alanına değer aktarıyoruz
      // Verilmişse yeni stok durumunu, verilmemişse mevcut stok durumunu kullanır
      stoktaVarMi: stoktaVarMi ?? this.stoktaVarMi, // stoktaVarMi alanına değer aktarıyoruz
    // Urun nesnesi üretimi kapanışı
    );
  // copyWith metodunun kapanış parantezi
  }
// Urun sınıfının kapanış parantezi
}
