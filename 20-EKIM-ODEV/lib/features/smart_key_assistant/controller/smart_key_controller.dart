// Zamanlayıcı (Timer) işlemleri için dart:async kütüphanesini içe aktarıyoruz
import 'dart:async';
// Flutter foundation kütüphanesi: ValueNotifier ve reaktif temel sınıfları barındırır
import 'package:flutter/foundation.dart';
// Asistan mesaj veri modelini içe aktarıyoruz
import '../models/assistant_message_model.dart';

/// TakeGO Akıllı Dijital Anahtar ve Yol Asistanı Denetleyicisi (SmartKeyController)
///
/// Fiziksel anahtar olmadan kapıları açıp kilitleme, farları yakarak
/// otoparkta aracı bulma, bagajı açma, canlı sürüş sayacı ve
/// akıllı yol asistanı diyaloglarını [ValueNotifier] ile yönetir.
class SmartKeyController {
  // ---------------------------------------------------------------------------
  // DİJİTAL KİLİT VE ARAÇ DONANIM DURUMLARI (ValueNotifier)
  // ---------------------------------------------------------------------------

  /// Araç kapılarının açık (true) veya kilitli (false) olduğunu tutan ValueNotifier
  final ValueNotifier<bool> isCarUnlocked = ValueNotifier<bool>(false);

  /// Farların otoparkta bulma amacıyla yanıp sönme durumunu tutan ValueNotifier
  final ValueNotifier<bool> isHeadlightsFlashing = ValueNotifier<bool>(false);

  /// Araç bagaj kapağının açık (true) veya kapalı (false) olduğunu tutan ValueNotifier
  final ValueNotifier<bool> isTrunkOpen = ValueNotifier<bool>(false);

  /// Canlı aktif sürüş süresini saniye cinsinden tutan ValueNotifier
  final ValueNotifier<int> activeDriveSeconds = ValueNotifier<int>(0);

  /// Aracın aktif olarak hareket halinde olup olmadığını belirten ValueNotifier
  final ValueNotifier<bool> isDrivingNotifier = ValueNotifier<bool>(false);

  /// Yol asistanı sohbet mesajları listesini dinleyicilere ulaştıran ValueNotifier
  final ValueNotifier<List<AssistantMessageModel>> messagesNotifier =
      ValueNotifier<List<AssistantMessageModel>>([]);

  /// Sürüş süresini saniye saniye arttıran arka plan periyodik zamanlayıcısı
  Timer? _driveTimer;

  // ---------------------------------------------------------------------------
  // BAŞLATMA (Initialization)
  // ---------------------------------------------------------------------------

  /// Asistan ilk açıldığında hoş geldiniz karşılama mesajını ekler
  void init() {
    // Mesaj listesi halihazırda boş ise ilk mesajı oluşturuyoruz
    if (messagesNotifier.value.isEmpty) {
      // Karşılama mesajı nesnesi oluşturuluyor
      messagesNotifier.value = [
        AssistantMessageModel(
          // Mesajın benzersiz kimliği
          id: 'welcome',
          // Kullanıcıyı karşılayan bilgilendirici asistan metni
          text:
              'Merhaba! Ben TakeGO Yol Asistanı. Aracınız, kiralama detayları veya sürüş hakkında merak ettiğiniz her şeyi bana sorabilirsiniz.',
          // Mesajın kullanıcıdan değil yapay zeka asistanından geldiğini belirtiyoruz
          isUser: false,
          // Mesajın üretildiği anki zaman damgası
          timestamp: DateTime.now(),
        ),
      ];
    }
  }

  // ---------------------------------------------------------------------------
  // DİJİTAL KOKPİT EYLEMLERİ (Digital Key Actions)
  // ---------------------------------------------------------------------------

  /// Kapı kilitlerini açar veya kilitler; açıldığında sürüş sayacını başlatır
  void toggleCarLock() {
    // Mevcut kilit durumunun tersini atıyoruz (true -> false veya false -> true)
    isCarUnlocked.value = !isCarUnlocked.value;

    // Eğer kapılar açıldıysa sürüş sayacını tetikliyoruz
    if (isCarUnlocked.value) {
      // Sürüş zamanlayıcısını başlat
      startDriveTimer();
    } else {
      // Kapılar kilitlendiyse sürüş zamanlayıcısını duraklat
      stopDriveTimer();
    }
  }

  /// Otoparkta aracı bulmak için farları 3 saniye boyunca yakıp söndürür
  void flashHeadlights() {
    // Farları açık konuma getiriyoruz
    isHeadlightsFlashing.value = true;

    // 3 saniye sonra farları otomatik kapatmak için bir kerelik Timer kuruyoruz
    Timer(const Duration(seconds: 3), () {
      // 3 saniye dolunca farları kapat
      isHeadlightsFlashing.value = false;
    });
  }

  /// Bagaj kapağını açar veya kapatır
  void toggleTrunk() {
    // Bagaj durumunu tersine çeviriyoruz (Açıksa kapat, kapalıysa aç)
    isTrunkOpen.value = !isTrunkOpen.value;
  }

  /// Sürüş sayacını sıfırdan veya kaldığı yerden başlatır
  void startDriveTimer() {
    // Sürüş durumunu aktif (true) yapıyoruz
    isDrivingNotifier.value = true;
    // Var olan eski bir sayaç varsa önce iptal ediyoruz
    _driveTimer?.cancel();

    // Her 1 saniyede bir tetiklenen periyodik zamanlayıcı kuruyoruz
    _driveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Aktif sürüş saniyesini 1 artırıyoruz
      activeDriveSeconds.value++;
    });
  }

  /// Sürüş sayacını duraklatır
  void stopDriveTimer() {
    // Sürüş durumunu pasif (false) yapıyoruz
    isDrivingNotifier.value = false;
    // Çalışmakta olan zamanlayıcıyı durduruyoruz
    _driveTimer?.cancel();
  }

  /// Sürüşü tamamen bitirir ve özet istatistiklerini hesaplayıp döner
  Map<String, dynamic> finishDriveSession() {
    // Geçen toplam süreyi saniye olarak alıyoruz
    final seconds = activeDriveSeconds.value;
    // Saniyeyi dakikaya çevirip yukarı yuvarlıyoruz
    final minutes = (seconds / 60).ceil();
    // Süreye göre harcanan tahmini benzin/şarj yüzdesini hesaplıyoruz (Min: %1, Max: %15)
    final fuelUsed = (seconds * 0.05).clamp(1.0, 15.0);

    // Sürüş sayacını durdur
    stopDriveTimer();
    // Aracı otomatik olarak kilitle
    isCarUnlocked.value = false;
    // Saniyeyi sıfırla
    activeDriveSeconds.value = 0;

    // Özet istatistiklerini harita (Map) olarak döndürüyoruz
    return {
      // Toplam saniye
      'seconds': seconds,
      // Toplam dakika (minimum 1 dakika)
      'minutes': minutes == 0 ? 1 : minutes,
      // Kullanılan tahmini depo yüzdesi
      'fuelPercentUsed': fuelUsed.toStringAsFixed(1),
    };
  }

  // ---------------------------------------------------------------------------
  // AKILLI YOL ASİSTANI SORU-CEVAP MANTIĞI
  // ---------------------------------------------------------------------------

  /// Kullanıcının sorduğu soruya uygun akıllı hazır cevabı anında üretir
  void askAssistant(String question) {
    // Kullanıcının sorusunu temsil eden yeni bir AssistantMessageModel nesnesi oluşturuluyor
    final userMsg = AssistantMessageModel(
      // Benzersiz zaman bazlı ID
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      // Sorunun ham metni
      text: question,
      // Mesajın kullanıcıya ait olduğunu belirtiyoruz
      isUser: true,
      // Gönderim zamanı
      timestamp: DateTime.now(),
    );

    // Kullanıcı mesajını mevcut listeye ekliyoruz
    messagesNotifier.value = [...messagesNotifier.value, userMsg];

    // Akıllı cevap metnini kural motorundan üretiyoruz
    final answerText = _generateSmartAnswer(question);

    // Asistanın yanıtını temsil eden mesaj nesnesini oluşturuyoruz
    final botMsg = AssistantMessageModel(
      // Benzersiz ID
      id: 'bot-${DateTime.now().millisecondsSinceEpoch}',
      // Cevabın metni
      text: answerText,
      // Asistan mesajı olduğunu belirtiyoruz
      isUser: false,
      // Zaman damgası
      timestamp: DateTime.now(),
    );

    // Gerçekçi bir yazma hissi vermek için 300 milisaniye sonra cevabı ekrana yansıtıyoruz
    Timer(const Duration(milliseconds: 300), () {
      // Asistan cevabını listeye ekle
      messagesNotifier.value = [...messagesNotifier.value, botMsg];
    });
  }

  /// Sıkça sorulan sorulara göre otomotiv cevabı üreten yardımcı metot
  String _generateSmartAnswer(String q) {
    // Arama için soruyu küçük harflere çeviriyoruz
    final query = q.toLowerCase();

    // Yakıt kapağı ile ilgili anahtar kelimeleri denetliyoruz
    if (query.contains('yakıt') || query.contains('depo') || query.contains('kapak')) {
      return 'Yakıt kapağı, kapı kilitleri açıkken kapağın üzerine hafifçe bastırılarak açılır. Elektrikli modellerde şarj soketi sol arka çamurluktadır.';
    }
    // Süre uzatma ile ilgili soruları denetliyoruz
    else if (query.contains('uzat') || query.contains('haftalık') || query.contains('günlük')) {
      return 'Kiralama sürenizi TakeGO uygulamasındaki "Rezervasyonlarım" sekmesinden araç müsaitse tek tıkla dilediğiniz gün kadar uzatabilirsiniz.';
    }
    // Otopark ve park kuralları sorularını denetliyoruz
    else if (query.contains('park') || query.contains('yasak') || query.contains('otopark')) {
      return 'İSPARK noktalarında TakeGO kullanıcıları için ilk 2 saat ücretsiz park hakkı mevcuttur. Park yasağı olan sarı çizgilere bırakmayınız.';
    }
    // Acil durum ve arıza sorularını denetliyoruz
    else if (query.contains('arıza') || query.contains('kaza') || query.contains('acil')) {
      return 'Acil durumlarda araç içindeki SOS düğmesine basabilir veya 7/24 TakeGO Destek Hattı olan 0850 500 00 00 numarasını arayabilirsiniz.';
    }

    // Eşleşmeyen diğer sorular için varsayılan akıllı yönlendirme cevabı
    return 'Talebiniz kaydedildi. "$q" konusuyla ilgili TakeGO saha ekibimiz dijital asistan üzerinden size her an yardımcı olmaya hazırdır.';
  }

  // ---------------------------------------------------------------------------
  // BELLEK TEMİZLİĞİ
  // ---------------------------------------------------------------------------

  /// Bellek sızıntılarını önlemek için tüm bildirim ve zamanlayıcı kaynaklarını serbest bırakır
  void dispose() {
    // Zamanlayıcıyı iptal et
    _driveTimer?.cancel();
    // Kilit durum dinleyicisini serbest bırak
    isCarUnlocked.dispose();
    // Far durumu dinleyicisini serbest bırak
    isHeadlightsFlashing.dispose();
    // Bagaj durumu dinleyicisini serbest bırak
    isTrunkOpen.dispose();
    // Sürüş saniyesi dinleyicisini serbest bırak
    activeDriveSeconds.dispose();
    // Sürüş durumu dinleyicisini serbest bırak
    isDrivingNotifier.dispose();
    // Mesaj listesi dinleyicisini serbest bırak
    messagesNotifier.dispose();
  }
}
