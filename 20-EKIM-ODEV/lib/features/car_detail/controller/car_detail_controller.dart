// Flutter temel sınıfları ve ValueNotifier için foundation paketini içe aktarıyoruz
import 'package:flutter/foundation.dart';
// İncelenen araç modelini içe aktarıyoruz
import '../../car_listing/models/car_model.dart';
// Kiralama periyodu enum tipini (günlük, haftalık, aylık) içe aktarıyoruz
import '../../car_listing/models/rental_period_type.dart';

/// TakeGO İlan İnceleme ve Fiyat Hesaplama Denetleyicisi (CarDetailController)
///
/// Seçilen aracın detayları, kiralama periyodu (Günlük/Haftalık/Aylık),
/// süre birimi (kaç gün/hafta/ay) ve opsiyonel kasko seçimini
/// [ValueNotifier] ile dinamik olarak hesaplar.
class CarDetailController {
  /// İncelenmekte olan araç modeli referansı
  final CarModel car;

  // ---------------------------------------------------------------------------
  // REAKTİF DURUM TANIMLARI (ValueNotifier)
  // ---------------------------------------------------------------------------

  /// Kullanıcının seçtiği kiralama periyodu bildiricisi (Günlük / Haftalık / Aylık)
  final ValueNotifier<RentalPeriodType> selectedPeriodNotifier;

  /// Kiralama süresi adedi bildiricisi (Varsayılan: 1 birim, örn: 1 gün veya 1 hafta)
  final ValueNotifier<int> durationUnitsNotifier = ValueNotifier<int>(1);

  /// Tam kapsamlı kasko/sigorta koruma paketi tercihi bildiricisi (Varsayılan: Açık)
  final ValueNotifier<bool> fullInsuranceNotifier = ValueNotifier<bool>(true);

  // ---------------------------------------------------------------------------
  // KURUCU (Constructor)
  // ---------------------------------------------------------------------------

  /// CarDetailController kurucusu: İncelenecek aracı ve başlangıç periyodunu alır
  CarDetailController({
    // Zorunlu araç referansı
    required this.car,
    // Başlangıç periyodu (varsayılan: Günlük)
    RentalPeriodType initialPeriod = RentalPeriodType.daily,
  })  : // Seçili periyot bildiricisini başlangıç değeriyle başlatıyoruz
        selectedPeriodNotifier =
            ValueNotifier<RentalPeriodType>(initialPeriod);

  // ---------------------------------------------------------------------------
  // DİNAMİK FİYAT VE TUTAR HESAPLAMALARI (Getters)
  // ---------------------------------------------------------------------------

  /// Seçili periyoda ait birim kiralama fiyatı (TL cinsinden)
  double get unitPrice {
    // Modelin priceForPeriod fonksiyonunu seçili periyotla çağırıyoruz
    return car.priceForPeriod(selectedPeriodNotifier.value);
  }

  /// Taban kiralama tutarı: Birim Fiyat x Seçilen Süre Adedi
  double get baseAmount {
    // Birim fiyatı süre adediyle çarpıyoruz
    return unitPrice * durationUnitsNotifier.value;
  }

  /// Seçilen periyoda ve süreye göre tam kapsamlı kasko bedeli
  double get insuranceAmount {
    // Kasko seçili değilse bedel 0 TL'dir
    if (!fullInsuranceNotifier.value) {
      return 0.0;
    }

    // Seçili periyoda göre birim kasko bedelini süre ile çarpıyoruz
    switch (selectedPeriodNotifier.value) {
      // Günlük kiralama için günlük 150 TL kasko
      case RentalPeriodType.daily:
        return 150.0 * durationUnitsNotifier.value;
      // Haftalık kiralama için haftalık 850 TL avantajlı kasko
      case RentalPeriodType.weekly:
        return 850.0 * durationUnitsNotifier.value;
      // Aylık kiralama için aylık 2500 TL kasko paketi
      case RentalPeriodType.monthly:
        return 2500.0 * durationUnitsNotifier.value;
    }
  }

  /// Platform hizmet bedeli: Taban tutar üzerinden %5 servis komisyonu
  double get serviceFee {
    // Taban kiralama tutarının yüzde 5'ini hesaplıyoruz
    return baseAmount * 0.05;
  }

  /// Kullanıcının ödeyeceği her şey dahil nihai toplam tutar
  double get totalAmount {
    // Taban tutar, kasko bedeli ve servis ücretini topluyoruz
    return baseAmount + insuranceAmount + serviceFee;
  }

  // ---------------------------------------------------------------------------
  // DURUM GÜNCELLEME EYLEMLERİ
  // ---------------------------------------------------------------------------

  /// Kiralama periyodunu değiştirir (Günlük / Haftalık / Aylık)
  void setPeriod(RentalPeriodType period) {
    // Yeni periyot mevcut olandan farklıysa değeri güncelliyoruz
    if (selectedPeriodNotifier.value != period) {
      // Yeni periyodu atayarak fiyat dökümünü tetikliyoruz
      selectedPeriodNotifier.value = period;
    }
  }

  /// Kiralama süresini artırır veya azaltır (Sınırlar: 1 ile 60 birim arası)
  void setDuration(int units) {
    // Sürenin geçerli aralıkta olduğunu kontrol ediyoruz
    if (units >= 1 && units <= 60) {
      // Süre bildiricisini güncelliyoruz
      durationUnitsNotifier.value = units;
    }
  }

  /// Kasko tercihini açar veya kapatır (true <-> false)
  void toggleInsurance() {
    // Mevcut kasko durumunun tersini atıyoruz
    fullInsuranceNotifier.value = !fullInsuranceNotifier.value;
  }

  // ---------------------------------------------------------------------------
  // BELLEK TEMİZLİĞİ
  // ---------------------------------------------------------------------------

  /// Sayfa kapandığında dinleyicileri bellekten temizler
  void dispose() {
    // Seçili periyot dinleyicisini serbest bırak
    selectedPeriodNotifier.dispose();
    // Süre adedi dinleyicisini serbest bırak
    durationUnitsNotifier.dispose();
    // Kasko tercihi dinleyicisini serbest bırak
    fullInsuranceNotifier.dispose();
  }
}
