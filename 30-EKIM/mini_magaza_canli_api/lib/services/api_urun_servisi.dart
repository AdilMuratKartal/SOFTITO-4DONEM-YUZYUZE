// JSON verilerini Dart nesnelerine dönüştürmek ve UTF-8 karakter çözümü için gerekli kütüphane
import 'dart:convert'; // JSON çözümleme (jsonDecode) ve dönüştürme işlemleri için bu paketi ekliyoruz
// İnternet üzerinden HTTP istekleri (GET, POST vb.) yapmayı sağlayan resmi paket
import 'package:http/http.dart' as http; // İnternet üzerinden REST API istekleri (GET, POST vb.) atabilmek için http paketini ekliyoruz
// Çözümlenen verilerin aktarılacağı Urun modelini içe aktarır
import '../models/urun.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
// Uygulanacak sözleşmeyi (interface) sağlayan soyut sınıfı içe aktarır
import 'i_urun_servisi.dart';

// FakeStore REST API ile gerçek internet iletişimi kuran somut servis sınıfı
class ApiUrunServisi implements IUrunServisi { // ApiUrunServisi sınıfı, sözleşmedeki metodları gerçek hayata uyarlayıp kodladığımız sınıftır
  // FakeStore API temel uç nokta adresi (base URL)
  static const String _baseUrl = 'https://fakestoreapi.com';
  // Ağ isteğinin en fazla ne kadar süre yanıt bekleyeceğini belirleyen zaman aşımı süresi
  static const Duration _zamanAsimi = Duration(seconds: 10);

  // Soyut arayüzden gelen tüm ürünleri getirme metodunun somutlaştırılması
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // Sunucudan ürün listesini asenkron olarak çeken metot
  Future<List<Urun>> urunleriGetir() async {
    // try bloğu ağ veya dönüşüm sırasında oluşabilecek hataları yakalamak için açılır
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      // Hedef REST API endpoint adresini Uri nesnesine dönüştürür
      final uri = Uri.parse('$_baseUrl/products');
      // Sunucuya HTTP GET isteği gönderir ve 10 saniyelik zaman aşımı koruması uygular
      final yanit = await http.get(uri).timeout(_zamanAsimi); // Canlı API sunucusuna asenkron GET isteği atıp cevabı bekliyoruz

      // Sunucunun HTTP 200 OK (Başarılı) kodu dönüp dönmediğini kontrol eder
      if (yanit.statusCode == 200) {
        // Türkçe ve özel karakterlerin bozulmasını önlemek için gövde baytlarını UTF-8 formatında çözer
        final cozulmusGovde = utf8.decode(yanit.bodyBytes);
        // JSON metnini Dart'ın dinamik List koleksiyonuna ayrıştırır
        final List<dynamic> jsonListesi = jsonDecode(cozulmusGovde) as List<dynamic>; // Gelen ham JSON metnini çözüp Dart nesnelerine/listelerine dönüştürüyoruz

        // Her bir JSON haritasını Urun.fromJson ile Urun nesnesine çevirip liste olarak döndürür
        return jsonListesi
            // Listedeki her öğeyi Map<String, dynamic> olarak işler
            .map((oge) => Urun.fromJson(oge as Map<String, dynamic>))
            // Elde edilen Iterable koleksiyonunu standart Dart Listesine dönüştürür
            .toList();
      // Sunucu 200 dışında bir durum kodu (404, 500 vb.) döndüğünde çalışır
      } else {
        // Hata durumunu açıklayan bir istisna fırlatır
        throw Exception('Sunucu hatası: HTTP ${yanit.statusCode}');
      // if-else bloğu kapanışı
      }
    // Herhangi bir ağ kopması, zaman aşımı veya format hatasını yakalar
    } catch (hata) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      // Hatayı UI katmanının (ekranın) yakalayıp kullanıcıya gösterebilmesi için tekrar fırlatır
      rethrow; // Hatayı yakaladıktan sonra üst katmana fırlatıp haber veriyoruz
    // try-catch bloğu kapanışı
    }
  // urunleriGetir metodu kapanış parantezi
  }

  // Soyut arayüzden gelen tek bir ürünü ID ile getirme metodunun somutlaştırılması
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  // Belirtilen ID'ye sahip ürünü sunucudan asenkron olarak çeken metot
  Future<Urun?> urunGetirById(int id) async {
    // Hata yönetimi için try bloğu açılır
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      // Ürünün spesifik endpoint adresini (örnek: /products/1) Uri nesnesine dönüştürür
      final uri = Uri.parse('$_baseUrl/products/$id');
      // Sunucuya zaman aşımı korumalı HTTP GET isteği gönderir
      final yanit = await http.get(uri).timeout(_zamanAsimi); // Canlı API sunucusuna asenkron GET isteği atıp cevabı bekliyoruz

      // İstek başarılı olduysa
      if (yanit.statusCode == 200) {
        // Yanıt gövdesini UTF-8 olarak çözer
        final cozulmusGovde = utf8.decode(yanit.bodyBytes);
        // JSON metnini Map yapısına ayrıştırır
        final Map<String, dynamic> jsonHaritasi = jsonDecode(cozulmusGovde) as Map<String, dynamic>; // Gelen ham JSON metnini çözüp Dart nesnelerine/listelerine dönüştürüyoruz
        // JSON haritasını Urun nesnesine çevirerek döndürür
        return Urun.fromJson(jsonHaritasi);
      // Ürün bulunamadıysa veya sunucu hatası varsa
      } else {
        // Bulunamadığında null döndürür
        return null;
      // if-else kapanışı
      }
    // Hata yakalama bloğu
    } catch (hata) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      // Hata durumunda güvenle null döndürür
      return null;
    // try-catch kapanışı
    }
  // urunGetirById metodu kapanış parantezi
  }
// ApiUrunServisi sınıfının kapanış parantezi
}
