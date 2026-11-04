import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class YerelBildirimController {
  static final FlutterLocalNotificationsPlugin _yerelBildirim =
      FlutterLocalNotificationsPlugin();

  static Future<void> kurulum() async {
    //Android ayarlar
    const androidAyarlar = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    ); //logo resimleri var app/src/main/run/ßmipmap
    const iosAyarlar = DarwinInitializationSettings();
    const ayarlar = InitializationSettings(
      android: androidAyarlar,
      iOS: iosAyarlar,
    );
    await _yerelBildirim.initialize(settings: ayarlar);
  }

  static Future<void> bildirimGoster(RemoteMessage message) async {
    const androidDetay = AndroidNotificationDetails(
      'softito_kanal_id',
      'Softito Bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const detaylar = NotificationDetails(android: androidDetay);
    await _yerelBildirim.show(
      id: message.hashCode, //message.messageId var o değilde bu olması gerekiyor. o mesajın ıd'sidir. normal id'yi hash olarak gönderiyor.
      title: message.notification?.title ?? 'Yeni Bildirim',
      body: message.notification?.body ?? '',
      notificationDetails: detaylar,
    );
  }
}

//flutter çalışırken ios ve android ayrı derleyip çalıştırıyor, bizde burda ios ve android için ayrı ayrı ayar kodları yazıyoruz.
//static kullanımı ise sınıfın öğrneğini oluşturmadan ismi ile metod kullanabiliyoruz mesela YerelBildirimController.kurulum() diye. Genellikle uygulamanın her yerinde kullanabileceğimiz sabit değişkenler ve metodlar için static kullanırız. işlevi aynı yapıcak bir işlem yapucak aynı metod üzerinden yapcak o yüznde. Ek olarak gene sınıfın objesini oluşturup kullanabilirdik ama static kullanmak daha pratik olabilioyr yukarıdaki gibi gene instance'si ile sınıflara ulaşabiliriz.
//neden importance ve priorty de girdik ikisinide ? -> ikside birbiriyle bağlantılı android için android
