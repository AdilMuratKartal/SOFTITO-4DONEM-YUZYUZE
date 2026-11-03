import 'kategori.dart';

class Urun { // Urun sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
    final int id; // int türünden id adlı değişkenimiz
    final String baslik; // String türünden baslik adlı değişkenimiz
    final String aciklama; // String türünden aciklama adlı değişkenimiz
    final double fiyat; // double türünden fiyat adlı değişkenimiz
    final String resimUrl; // String türünden resimUrl adlı değişkenimiz
    final Kategori kategori; // Kategori türünden kategori adlı değişkenimiz
    final int stokAdedi; // int türünden stokAdedi adlı değişkenimiz
    final bool favoriMi; // bool türünden favoriMi adlı değişkenimiz

    const Urun({ // Genel, sabit sınıf constructor'ı
        required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.baslik, // baslik parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.aciklama, // aciklama parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.fiyat, // fiyat parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.resimUrl, // resimUrl parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.kategori, // kategori parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.stokAdedi, // stokAdedi parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        this.favoriMi = false, //tek bu alanı değiştiriyoruz copyWith için bir tanede aynısından favori olanı alıcaz
    }); 

    Urun copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
        int? id,
        String? baslik,
        String? aciklam,
        double? fiyat,
        String? resimUrl,
        Kategori? kategori,
        int? stokAdedi,
        bool? favoriMi
    }){
        return Urun(
            id: id?? this.id, // id alanına değer aktarıyoruz
            baslik: baslik?? this.baslik, // baslik alanına değer aktarıyoruz
            aciklama: aciklama?? this.aciklama, // aciklama alanına değer aktarıyoruz
            fiyat: fiyat?? this.fiyat, // fiyat alanına değer aktarıyoruz
            resimUrl: resimUrl?? this.resimUrl, // resimUrl alanına değer aktarıyoruz
            kategori: kategori?? this.kategori, // kategori alanına değer aktarıyoruz
            stokAdedi: stokAdedi?? this.stokAdedi, // stokAdedi alanına değer aktarıyoruz
            favoriMi: favoriMi?? this.favoriMi, // favoriMi alanına değer aktarıyoruz
        );
    }

    @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
    String toString(){
        return "Urun(id: $id,baslik: $baslik,fiyat: $fiyat ₺,favoriMi: $favoriMi)";
    }
}