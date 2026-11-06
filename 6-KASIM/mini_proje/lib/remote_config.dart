//uzaktan config mesela e-ticaret sitelerinde kasım cuma indirimleri gibi kampayanlar gelmesi banner çıkması uygulama çıkıyor. ne yapıyoruz yazıyoruz gösterme durumunu kod güncellemeden uzaktan değiştirip çalıştırabiliyoruz. true yaptık açılıyor gibi.

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigServisi {
  final FirebaseRemoteConfig _rc = FirebaseRemoteConfig.instance;

  Future<void> baslat() async {
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(
          seconds: 10,
        ), //ilk çekilen veri 10 saniye bekle
        minimumFetchInterval: Duration
            .zero, //cache önbellek süresimizi hiç bekletmemiz gerekiyor.
      ),
    );

    //internet olmadığında bu cache nasıl olur
    await _rc.setDefaults(const {
      'kampanya_aktif': false,
      'kampanya_metni': 'Bugun beratta kampanya var 3 kere ders anlatacakmıs',
      'zorunlu_surum': '1.0.1',
    });

    //uzaktaki verileri çek diyoruz
    await _rc.fetchAndActivate();
  }

  bool get kampanyaAktifMi => _rc.getBool('kampanya_aktif');
  String get kampanyaMetni => _rc.getString('kampanya_metni');
  String get zorunluSurum => _rc.getString('zorunlu_surum'); //guvenlik ve benzeri durumlarında direk uygulamayı kullanamamasını açamamısını sağlarız force update yaptırıyoruz. mesela backend'i değiştirdin farklı endpoint te güncelleme atman lazım eski backend'de gidemiyorlar, uygulamaya istediğimiz zorunlu surumu söylüyoruz, ve yükle diyoruz kullanman için bu sayede kullanıcılara tek tek bildirim atmadan bu gibi durumlarla başa çıkıyoruz. banka olur yeni özellik getirir onlarıda kullanması için sürümünü yükseltsinler.
}
