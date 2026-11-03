import 'dart:convert'; // JSON çözümleme (jsonDecode) ve dönüştürme işlemleri için bu paketi ekliyoruz

import 'package:http/http.dart'; // İnternet üzerinden REST API istekleri (GET, POST vb.) atabilmek için http paketini ekliyoruz

class UrunModel{ // UrunModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
    final int id; // int türünden id adlı değişkenimiz
    final String baslik; // String türünden baslik adlı değişkenimiz
    final double fiyat; // double türünden fiyat adlı değişkenimiz
    final String resimUrl; // String türünden resimUrl adlı değişkenimiz
    final String kategori; // String türünden kategori adlı değişkenimiz
    
    const UrunModel({ // Genel, sabit sınıf constructor'ı
        required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.baslik, // baslik parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.fiyat, // fiyat parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.resimUrl, // resimUrl parametresinin verilmesinin zorunlu olduğunu söylüyoruz
        required this.kategori, // kategori parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    });
    
    factory UrunModel.fromJson(Map<String,dynamic> json){ // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
        return UrunModel(
            id: json['id'] as int? ?? 0,
            baslik: json['title'] as String? ?? 'İsimsiz Ürün',
            fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
            resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150',
            kategori: json['category'] as String? ?? 'Genel',
        );
    }

}