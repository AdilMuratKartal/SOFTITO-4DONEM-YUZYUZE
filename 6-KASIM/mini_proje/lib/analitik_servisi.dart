import 'package:firebase_analytics/firebase_analytics.dart';

class AnalitikServisi {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> ekranGoruntulendi(String ekranAdi) async {
    await _analytics.logScreenView(screenName: ekranAdi);
  }

  Future<void> butonTiklandi({
    required String butonId,
    required String kategori,
  }) async {
    await _analytics.logEvent(
      name: "buton_tiklama",
      parameters: {
        'buton_id': butonId,
        'kategori': kategori,
        'zaman': DateTime.now().toIso8601String(), //8601 ıso formatına göre string yapar. çeviri 08.12.2026 13:46:25 gibi normalde 08122026134625 gibi
      },
    ); //crash_analytics deki log() ile farkı: log da sayfanın bir bölümü spesifik iken kişi sayfa vs. alabilirken burda genel bilgileri tamamını kapsama durumları oluyor
  }

  Future<void> sepeteEklendi({
    required String urunId,
    required double fiyat,
  }) async {
    await _analytics.logEvent(
      name: 'sepete_ekle',
      parameters: {'urun_id': urunId, 'fiyat': fiyat, 'para_birimi': 'TL'},
    );
  } //kesin isterler. uygulama içinde hangi sayfaları gezindiğimize göre aksiyonlar alabiliriz. bunların kaç kşi oldupu nerede gezindiği vs analizi için.
}
