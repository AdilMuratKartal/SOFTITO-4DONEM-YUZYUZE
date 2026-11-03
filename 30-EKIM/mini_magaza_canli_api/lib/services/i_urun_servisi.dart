// Urun veri modelini bu arayüzde kullanabilmek için içe aktarır
import '../models/urun.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

// Ürün servisi işlemlerini tanımlayan soyut sözleşme (interface) sınıfı
abstract class IUrunServisi { // IUrunServisi arayüzü (interface - sözleşme), bu servisi uygulayanların zorunlu metodlarını belirler
  // Tüm ürünlerin listesini asenkron olarak sunucudan veya bellekten getiren metot
  Future<List<Urun>> urunleriGetir();

  // Belirli bir ID'ye sahip tek bir ürünü asenkron olarak getiren metot
  Future<Urun?> urunGetirById(int id);
// IUrunServisi soyut sınıfının kapanış parantezi
}
