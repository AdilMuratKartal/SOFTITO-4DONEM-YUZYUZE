// Flutter Materyal kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Üretilecek araç verisi için CarModel sınıfını içe aktarıyoruz
import '../../car_listing/models/car_model.dart';

/// TakeGO Yeni Araç İlanı Verme Denetleyicisi (CreateListingController)
///
/// Bireysel araç sahiplerinin araç bilgilerini, kiralama periyot
/// fiyatlarını, müsaitlik tarih aralığını ve yakıt seviyesini
/// [ValueNotifier] ile reaktif olarak yönetir ve doğrular.
class CreateListingController {
  // ---------------------------------------------------------------------------
  // METİN ALANI DENETLEYİCİLERİ (TextEditingController)
  // ---------------------------------------------------------------------------

  /// Araç markası giriş kutusu kontrolcüsü (Örn: 'Tesla')
  final TextEditingController brandController = TextEditingController();

  /// Araç modeli giriş kutusu kontrolcüsü (Örn: 'Model Y')
  final TextEditingController modelController = TextEditingController();

  /// Model yılı giriş kutusu kontrolcüsü (Varsayılan: '2024')
  final TextEditingController yearController = TextEditingController(text: '2024');

  /// Tescil plakası giriş kutusu kontrolcüsü (Örn: '34 TGO 100')
  final TextEditingController plateController = TextEditingController();

  /// Teslimat lokasyonu giriş kutusu kontrolcüsü (Varsayılan: 'Kadıköy, İstanbul')
  final TextEditingController locationController = TextEditingController(text: 'Kadıköy, İstanbul');

  /// Günlük kiralama bedeli (TL) giriş kutusu kontrolcüsü
  final TextEditingController dailyPriceController = TextEditingController();

  /// Haftalık kiralama bedeli (TL) giriş kutusu kontrolcüsü
  final TextEditingController weeklyPriceController = TextEditingController();

  /// Aylık kiralama bedeli (TL) giriş kutusu kontrolcüsü
  final TextEditingController monthlyPriceController = TextEditingController();

  /// Araç açıklaması ve kiralama kuralları metin kutusu kontrolcüsü
  final TextEditingController descriptionController = TextEditingController();

  // ---------------------------------------------------------------------------
  // REAKTİF FORM DURUMLARI (ValueNotifier)
  // ---------------------------------------------------------------------------

  /// Aracın teslim edileceği anki depo veya şarj yüzdesi bildiricisi (Varsayılan: %80)
  final ValueNotifier<int> fuelPercentNotifier = ValueNotifier<int>(80);

  /// Aracın elektrikli olup olmadığı durum bildiricisi (true: elektrikli, false: yakıtlı)
  final ValueNotifier<bool> isElectricNotifier = ValueNotifier<bool>(false);

  /// Şanzıman türü bildiricisi ('Otomatik' veya 'Manuel', varsayılan: 'Otomatik')
  final ValueNotifier<String> transmissionNotifier = ValueNotifier<String>('Otomatik');

  /// Kiralama müsaitlik tarih aralığı bildiricisi (Bugünden itibaren 30 gün)
  final ValueNotifier<DateTimeRange> dateRangeNotifier = ValueNotifier<DateTimeRange>(
    // Başlangıç tarihi bugün, bitiş tarihi 30 gün sonrası
    DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 30)),
    ),
  );

  /// Form kaydetme ve sunucuya gönderme yüklenme durumu bildiricisi
  final ValueNotifier<bool> isSubmittingNotifier = ValueNotifier<bool>(false);

  /// Formda eksik veya hatalı bilgi olduğunda ekrana basılacak hata mesajı bildiricisi
  final ValueNotifier<String?> errorMessageNotifier = ValueNotifier<String?>(null);

  // ---------------------------------------------------------------------------
  // DOĞRULAMA VE İLAN OLUŞTURMA İŞLEMİ
  // ---------------------------------------------------------------------------

  /// Form verilerini kontrol eder, geçerliyse yeni CarModel nesnesi üretir
  CarModel? submitListing() {
    // 1. Önceki hata mesajını sıfırlıyoruz
    errorMessageNotifier.value = null;

    // 2. Metin kutularındaki verileri boşluklardan arındırarak alıyoruz
    final brand = brandController.text.trim();
    // Model metni
    final model = modelController.text.trim();
    // Plakayı büyük harfe çevirerek alıyoruz
    final plate = plateController.text.trim().toUpperCase();
    // Yıl verisini tam sayıya çeviriyoruz
    final year = int.tryParse(yearController.text.trim()) ?? 0;
    // Günlük fiyatı double değere çeviriyoruz
    final dailyPrice = double.tryParse(dailyPriceController.text.trim()) ?? 0.0;
    // Haftalık fiyat boşsa günlük fiyatın 6.5 katı olarak otomatik hesaplıyoruz
    final weeklyPrice = double.tryParse(weeklyPriceController.text.trim()) ?? (dailyPrice * 6.5);
    // Aylık fiyat boşsa günlük fiyatın 24 katı olarak otomatik hesaplıyoruz
    final monthlyPrice = double.tryParse(monthlyPriceController.text.trim()) ?? (dailyPrice * 24.0);
    // Lokasyon metni
    final location = locationController.text.trim();

    // 3. Marka ve model zorunluluğu kontrolü
    if (brand.isEmpty || model.isEmpty) {
      // Hata mesajını bildiriyoruz
      errorMessageNotifier.value = 'Lütfen araç marka ve modelini giriniz.';
      return null;
    }

    // 4. Plaka zorunluluğu kontrolü
    if (plate.isEmpty) {
      // Hata mesajını bildiriyoruz
      errorMessageNotifier.value = 'Lütfen araç plakasını belirtiniz.';
      return null;
    }

    // 5. Günlük fiyatın sıfırdan büyük olması kontrolü
    if (dailyPrice <= 0) {
      // Hata mesajını bildiriyoruz
      errorMessageNotifier.value = 'Lütfen geçerli bir günlük kiralama bedeli giriniz.';
      return null;
    }

    // 6. Model yılının geçerli bir otomotiv aralığında olması kontrolü
    if (year < 2000 || year > 2026) {
      // Hata mesajını bildiriyoruz
      errorMessageNotifier.value = 'Lütfen geçerli bir model yılı giriniz (2000-2026).';
      return null;
    }

    // 7. Tüm doğrulamalar geçildi: Tip güvenli yeni CarModel nesnesini oluşturuyoruz
    final newCar = CarModel(
      // Benzersiz zaman damgalı ID
      id: 'car-${DateTime.now().millisecondsSinceEpoch}',
      // Araç markası
      brand: brand,
      // Araç modeli
      model: model,
      // Model yılı
      year: year,
      // Plaka
      plate: plate,
      // Seçilen depo / şarj yüzdesi
      fuelPercent: fuelPercentNotifier.value,
      // Elektrikli mi tercihi
      isElectric: isElectricNotifier.value,
      // Şanzıman türü
      transmission: transmissionNotifier.value,
      // Günlük kiralama fiyatı
      dailyPrice: dailyPrice,
      // Haftalık kiralama fiyatı
      weeklyPrice: weeklyPrice,
      // Aylık kiralama fiyatı
      monthlyPrice: monthlyPrice,
      // Müsaitlik başlangıç tarihi
      availableFrom: dateRangeNotifier.value.start,
      // Müsaitlik bitiş tarihi
      availableTo: dateRangeNotifier.value.end,
      // Teslim lokasyonu (boşsa varsayılan İstanbul)
      location: location.isEmpty ? 'İstanbul' : location,
      // Varsayılan yakınlık mesafesi
      distanceKm: 0.5,
      // Açıklama metni (boşsa varsayılan metin)
      description: descriptionController.text.trim().isEmpty
          ? 'TakeGO platformu üzerinden paylaşıma açılan temiz araç.'
          : descriptionController.text.trim(),
    );

    // Başarıyla oluşturulan aracı döndürüyoruz
    return newCar;
  }

  // ---------------------------------------------------------------------------
  // BELLEK TEMİZLİĞİ
  // ---------------------------------------------------------------------------

  /// Form denetleyicileri ve dinleyicilerini serbest bırakır
  void dispose() {
    // Marka metin denetleyicisini temizle
    brandController.dispose();
    // Model metin denetleyicisini temizle
    modelController.dispose();
    // Yıl metin denetleyicisini temizle
    yearController.dispose();
    // Plaka metin denetleyicisini temizle
    plateController.dispose();
    // Lokasyon metin denetleyicisini temizle
    locationController.dispose();
    // Günlük fiyat denetleyicisini temizle
    dailyPriceController.dispose();
    // Haftalık fiyat denetleyicisini temizle
    weeklyPriceController.dispose();
    // Aylık fiyat denetleyicisini temizle
    monthlyPriceController.dispose();
    // Açıklama denetleyicisini temizle
    descriptionController.dispose();
    // Yakıt yüzdesi bildiricisini temizle
    fuelPercentNotifier.dispose();
    // Elektrikli bildiricisini temizle
    isElectricNotifier.dispose();
    // Şanzıman bildiricisini temizle
    transmissionNotifier.dispose();
    // Tarih aralığı bildiricisini temizle
    dateRangeNotifier.dispose();
    // Gönderim durumu bildiricisini temizle
    isSubmittingNotifier.dispose();
    // Hata mesajı bildiricisini temizle
    errorMessageNotifier.dispose();
  }
}
