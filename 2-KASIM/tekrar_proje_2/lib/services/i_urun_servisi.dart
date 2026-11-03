import 'dart:convert'; // JSON çözümleme (jsonDecode) ve dönüştürme işlemleri için bu paketi ekliyoruz

import 'package:http/http.dart' as http; // İnternet üzerinden REST API istekleri (GET, POST vb.) atabilmek için http paketini ekliyoruz
import 'package:tekrar_proje_2/models/urun_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

//bu başka dosyaya atı interface bu
abstract class IUrunServisi { // IUrunServisi arayüzü (interface - sözleşme), bu servisi uygulayanların zorunlu metodlarını belirler
  Future<List<UrunModel>> urunleriGetir();
}

class CanliApiUrunServisi implements IUrunServisi { // CanliApiUrunServisi sınıfı, sözleşmedeki metodları gerçek hayata uyarlayıp kodladığımız sınıftır
  static const String _base_url = "https://fakestoreapi.com/products";

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Future<List<UrunModel>> urunleriGetir() async {
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      final yanit = await http
          .get(Uri.parse(_base_url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Ağ zaman aşımına uğradı');
            },
          );
      if (yanit.statusCode == 200) {
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>; // Gelen ham JSON metnini çözüp Dart nesnelerine/listelerine dönüştürüyoruz

        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Sunucu Hatası: ${yanit.statusCode}');
      }
    } catch (e) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      print('Ağ hatası:$e');
      rethrow; // Hatayı yakaladıktan sonra üst katmana fırlatıp haber veriyoruz
    }
  }
}
