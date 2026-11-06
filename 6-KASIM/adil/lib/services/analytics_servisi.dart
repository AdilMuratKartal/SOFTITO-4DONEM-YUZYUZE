import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsServisi {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> ekranGoruntulendi(String ekranAdi) async {
    await _analytics.logScreenView(screenName: ekranAdi);
  }

  Future<void> olayGonder({
    required String olayAdi,
    Map<String, Object>? parametreler, //her ekrandan farklı parametre gelebilir bilemezsin burda direk log event kullanıyoruz. istediğimiz sayfadan buraya log atabiliyoruz. objeyi bir string olarak bildiğimiz için Object kullanıyoruz. öbür türlü tipi dynamic olsa sürekli tip dönüşümleri yapman gerekecekti farklı parametreli göndermen gerekecekti. mesela 24 parametreli girmen vs. gerekiyor gibi. 1 tane olan parametre göndersek bile mesela {sayfaKey: 124411, parametre1: 12, parametre2: } gibi yollamamız gerekirdi. ama bu sayede 124411 gibi sayıları doğrudan görebiliyoruz. sayfa keylerini de integer olarak görmüş oluyoruz. bu sayede analytics ekranlarında bunları rahatlıkla filtreleyebiliyoruz.
  }) async {
    await _analytics.logEvent(name: olayAdi, parameters: parametreler);
  }

  Future<void> kullaniciOzelligiBelirli({
    required String anahtar,
    required String deger,
  }) async {
    await _analytics.setUserProperty(name: anahtar, value: deger);
  }
}
