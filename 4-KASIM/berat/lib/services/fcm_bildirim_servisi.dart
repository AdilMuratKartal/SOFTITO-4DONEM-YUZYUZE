import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {} //arka planda mesaj yakalıyor

class FcmBildirimServisi {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();
  late String? apnsToken;

  Future<void> baslat({
    required Function(RemoteMessage message) onMesajGeldi,
  }) async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
    apnsToken = await _fcm.getAPNSToken();

    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );

    await _localPlugin.initialize(initSettings);
    FirebaseMessaging.onMessage.listen((message) {
      _yerelBildirimGoster(message);
      onMesajGeldi(message);
    });
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  }

  Future<String?> tokenAl() async {
    try {
      return await _fcm.getToken();
    } catch (_) {
      return null;
    }
  }

  Future<void> konuyaAboneOl(String konu) async {
    await _fcm.subscribeToTopic(konu);
  }

  Future<void> konudanAyril(String konu) async {
    await _fcm.unsubscribeFromTopic(konu);
  }

  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'softit_fcm_channel_id',
      'Softito bildirimleri',
      channelDescription: 'Fcm Push Bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Yeni Bildirim',
      message.notification?.body ?? '',
      details,
    );
  }
}
