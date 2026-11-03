import '../models/kategori.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../models/urun.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz


abstract class IUrunServisi{ // IUrunServisi arayüzü (interface - sözleşme), bu servisi uygulayanların zorunlu metodlarını belirler
    Future<List<Urun>> tumUrunleriGetir();
    Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori);
    Future<List<Urun>> adaGoreAra(String aramaMetni);
}

