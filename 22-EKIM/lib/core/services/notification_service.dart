import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  /// Bildirim servisini ve saat dilimi altyapısını başlatır
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Timezone başlatma
      tz.initializeTimeZones();

      // Android Ayarları
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS & macOS Ayarları
      const DarwinInitializationSettings darwinSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Linux Ayarları
      const LinuxInitializationSettings linuxSettings =
          LinuxInitializationSettings(defaultActionName: 'Open notification');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
        linux: linuxSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('[Bildirim Tıklandı]: ${response.payload}');
        },
      );

      // İzin talepleri
      await requestPermissions();

      _isInitialized = true;
      debugPrint('[NotificationService] Başarıyla başlatıldı.');
    } catch (e) {
      debugPrint('[NotificationService Hata]: $e');
    }
  }

  /// Platforma göre bildirim izinlerini ister
  static Future<bool> requestPermissions() async {
    try {
      if (!kIsWeb && Platform.isMacOS) {
        final macosPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin>();
        final granted = await macosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      } else if (!kIsWeb && Platform.isIOS) {
        final iosPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        final granted = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      } else if (!kIsWeb && Platform.isAndroid) {
        final androidPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted = await androidPlugin?.requestNotificationsPermission();
        return granted ?? false;
      }
      return true;
    } catch (e) {
      debugPrint('[NotificationService İzin Hatası]: $e');
      return false;
    }
  }

  /// Anlık test bildirimi gönderir
  static Future<bool> showInstantNotification({
    required String title,
    required String body,
    int id = 9999,
    String? payload,
  }) async {
    try {
      if (!_isInitialized) await init();

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'aliskanlik_takibi_channel',
        'Alışkanlık Bildirimleri',
        channelDescription: 'Alışkanlık hatırlatıcı ve odaklanma bildirimleri',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      const DarwinNotificationDetails darwinDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );

      debugPrint('[NotificationService]: Anlık bildirim gönderildi -> $title');
      return true;
    } catch (e) {
      debugPrint('[NotificationService Bildirim Gönderilemedi]: $e');
      return false;
    }
  }

  /// Belirli bir saatte günlük tekrarlanan alışkanlık hatırlatıcısı kurar
  static Future<bool> scheduleHabitReminder({
    required String habitTitle,
    required String timeString, // Örn: "09:45"
    String? habitId,
  }) async {
    try {
      if (!_isInitialized) await init();

      final parts = timeString.split(':');
      if (parts.length != 2) return false;

      final hour = int.tryParse(parts[0]) ?? 9;
      final minute = int.tryParse(parts[1]) ?? 0;

      final notifId = (habitId != null)
          ? habitId.hashCode.abs() % 100000
          : DateTime.now().millisecondsSinceEpoch % 100000;

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'habit_reminders_channel',
        'Alışkanlık Hatırlatıcıları',
        channelDescription: 'Günlük saatlik alışkanlık alarmları',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );

      const DarwinNotificationDetails darwinDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id: notifId,
        title: '⏰ Alışkanlık Vakti: $habitTitle',
        body: 'Günün hedefini tamamlamak için harika bir an! Hedef saatine ulaşıldı ($timeString).',
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: habitId,
      );

      debugPrint('[NotificationService]: "$habitTitle" için $timeString saatine planlandı (ID: $notifId).');
      return true;
    } catch (e) {
      debugPrint('[NotificationService Zamanlama Hatası]: $e');
      return false;
    }
  }

  /// Belirli bir alışkanlığın bildirimini iptal eder
  static Future<void> cancelHabitReminder(String habitId) async {
    try {
      final notifId = habitId.hashCode.abs() % 100000;
      await _notificationsPlugin.cancel(id: notifId);
      debugPrint('[NotificationService]: Bildirim iptal edildi -> ID: $notifId (Habit: $habitId)');
    } catch (e) {
      debugPrint('[NotificationService İptal Hatası]: $e');
    }
  }

  /// Tüm bildirimleri temizler
  static Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('[NotificationService]: Tüm bildirimler iptal edildi.');
    } catch (e) {
      debugPrint('[NotificationService Hata]: $e');
    }
  }
}
