import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

//ARKA PLANDA DİNLEYEBİLMEMİZ İÇİN HER ZAMAN EN ÜSTE TOP LEVEL OLMAK ZORUNDADIR . pragma herşeyden bağımısız telefonu arka planda çalışmamızı sağlar.izinleride aldık requestPermission dan sonra ön tarafa tada dinlemek için bekleyebiliriz.

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Arka planda bildirim geldi: ${message.notification?.title}");
}

class BildirimServisi {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> baslat() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Kullanıcı Bildirim iznini verdi");
    }
    final token = await _fcm.getToken();
    print(
      'Cihazın FCM tokenı: $token',
    ); //sınıfın dışındada okunması için pragma tanımlayacağız
  }
}
