// Immutable (değişmezlik) anotasyonu ve temel sınıflar için foundation paketini içe aktarıyoruz
import 'package:flutter/foundation.dart';
// Kiralama periyot türlerini (günlük, haftalık, aylık) içe aktarıyoruz
import 'rental_period_type.dart';

/// TakeGO Araç İlan Modeli (CarModel)
///
/// Sistemdeki tüm kiralık araçların verilerini taşıyan,
/// `@immutable` ve tip güvenli ana veri modelidir.
@immutable
class CarModel { // CarModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  // ---------------------------------------------------------------------------
  // MODEL ALANLARI (Properties)
  // ---------------------------------------------------------------------------

  /// Aracın benzersiz kimlik numarası (Örn: 'car-101')
  final String id; // String türünden id adlı değişkenimiz

  /// Araç üretici markası (Örn: 'Tesla', 'BMW', 'Volvo')
  final String brand; // String türünden brand adlı değişkenimiz

  /// Araç model adı ve paket detayı (Örn: 'Model Y Long Range')
  final String model; // String türünden model adlı değişkenimiz

  /// Üretim model yılı (Örn: 2024)
  final int year; // int türünden year adlı değişkenimiz

  /// Araç tescil plakası (Örn: '34 TGO 101')
  final String plate; // String türünden plate adlı değişkenimiz

  /// Benzin deposu veya batarya şarj yüzdesi (%0 - %100)
  final int fuelPercent; // int türünden fuelPercent adlı değişkenimiz

  /// Aracın %100 elektrikli olup olmadığı bilgisi (true: elektrikli, false: içten yanmalı)
  final bool isElectric; // bool türünden isElectric adlı değişkenimiz

  /// Şanzıman türü ('Otomatik' veya 'Manuel')
  final String transmission; // String türünden transmission adlı değişkenimiz

  /// Araç yolcu koltuk kapasitesi (Varsayılan: 5 kişi)
  final int seatCount; // int türünden seatCount adlı değişkenimiz

  /// Günlük kiralama birim fiyatı (TL)
  final double dailyPrice; // double türünden dailyPrice adlı değişkenimiz

  /// Haftalık kiralama birim fiyatı (TL)
  final double weeklyPrice; // double türünden weeklyPrice adlı değişkenimiz

  /// Aylık kiralama birim fiyatı (TL)
  final double monthlyPrice; // double türünden monthlyPrice adlı değişkenimiz

  /// Kiralanabilirliğin başladığı ilk tarih
  final DateTime availableFrom; // DateTime türünden availableFrom adlı değişkenimiz

  /// Kiralanabilirliğin sona erdiği son tarih
  final DateTime availableTo; // DateTime türünden availableTo adlı değişkenimiz

  /// Aracın teslim alınacağı ilçe ve şehir lokasyonu (Örn: 'Kadıköy, İstanbul')
  final String location; // String türünden location adlı değişkenimiz

  /// Kullanıcının konumuna olan yaklaşık mesafe (km cinsinden)
  final double distanceKm; // double türünden distanceKm adlı değişkenimiz

  /// Araç görselinin URL bağlantısı (Opsiyonel / Nullable)
  final String? imageUrl; // String? türünden imageUrl adlı değişkenimiz

  /// Araç donanım özellikleri listesi (Örn: ['Otopilot', 'Cam Tavan'])
  final List<String> features; // List<String> türünden features adlı değişkenimiz

  /// Araç sahibi açıklaması ve kiralama notları
  final String description; // String türünden description adlı değişkenimiz

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// CarModel kurucusu (const destekli değişmez yapı)
  const CarModel({ // Genel, sabit sınıf constructor'ı
    // Zorunlu benzersiz ID
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu araç markası
    required this.brand, // brand parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu araç modeli
    required this.model, // model parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu üretim yılı
    required this.year, // year parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu plaka bilgisi
    required this.plate, // plate parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu yakıt / şarj yüzdesi
    required this.fuelPercent, // fuelPercent parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu elektrikli araç durumu
    required this.isElectric, // isElectric parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu şanzıman tipi
    required this.transmission, // transmission parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Koltuk sayısı (varsayılan: 5)
    this.seatCount = 5, // seatCount alanına değer aktarıyoruz
    // Zorunlu günlük fiyat
    required this.dailyPrice, // dailyPrice parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu haftalık fiyat
    required this.weeklyPrice, // weeklyPrice parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu aylık fiyat
    required this.monthlyPrice, // monthlyPrice parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu müsaitlik başlangıç tarihi
    required this.availableFrom, // availableFrom parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu müsaitlik bitiş tarihi
    required this.availableTo, // availableTo parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zorunlu teslim konumu
    required this.location, // location parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Yakınlık mesafesi (varsayılan: 1.0 km)
    this.distanceKm = 1.0, // distanceKm alanına değer aktarıyoruz
    // Opsiyonel fotoğraf bağlantısı
    this.imageUrl, // imageUrl alanına değer aktarıyoruz
    // Donanım listesi (varsayılan boş liste)
    this.features = const [], // features alanına değer aktarıyoruz
    // Açıklama metni (varsayılan tanıtım metni)
    this.description = 'TakeGO güvencesiyle anında kiralanabilir araç.', // description alanına değer aktarıyoruz
  });

  // ---------------------------------------------------------------------------
  // YARDIMCI HESAPLAMA METOTLARI
  // ---------------------------------------------------------------------------

  /// Seçili kiralama periyoduna (günlük, haftalık, aylık) göre birim fiyatı döner
  double priceForPeriod(RentalPeriodType period) {
    // Periyot tipine göre uygun fiyat alanını seçiyoruz
    switch (period) {
      // Günlük periyot seçildiyse günlük fiyatı dön
      case RentalPeriodType.daily:
        return dailyPrice;
      // Haftalık periyot seçildiyse haftalık fiyatı dön
      case RentalPeriodType.weekly:
        return weeklyPrice;
      // Aylık periyot seçildiyse aylık fiyatı dön
      case RentalPeriodType.monthly:
        return monthlyPrice;
    }
  }

  /// Marka ve modeli birleşik başlık metni olarak döndürür (Örn: 'Tesla Model Y')
  String get fullName {
    // Marka ve model metinlerini birleştirip döndürüyoruz
    return '$brand $model';
  }

  // ---------------------------------------------------------------------------
  // COPYWITH (Değişmezlik Kuralı Gereği)
  // ---------------------------------------------------------------------------

  /// Mevcut modelin belirli alanlarını güncelleyerek yeni bir kopya üretir
  CarModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    String? brand,
    String? model,
    int? year,
    String? plate,
    int? fuelPercent,
    bool? isElectric,
    String? transmission,
    int? seatCount,
    double? dailyPrice,
    double? weeklyPrice,
    double? monthlyPrice,
    DateTime? availableFrom,
    DateTime? availableTo,
    String? location,
    double? distanceKm,
    String? imageUrl,
    List<String>? features,
    String? description,
  }) {
    // Parametre olarak verilen yeni değeri, yoksa mevcut nesnedeki değeri alarak yeni nesne döndürüyoruz
    return CarModel(
      // ID güncellemesi veya mevcut ID
      id: id ?? this.id, // id alanına değer aktarıyoruz
      // Marka güncellemesi veya mevcut marka
      brand: brand ?? this.brand, // brand alanına değer aktarıyoruz
      // Model güncellemesi veya mevcut model
      model: model ?? this.model, // model alanına değer aktarıyoruz
      // Yıl güncellemesi veya mevcut yıl
      year: year ?? this.year, // year alanına değer aktarıyoruz
      // Plaka güncellemesi veya mevcut plaka
      plate: plate ?? this.plate, // plate alanına değer aktarıyoruz
      // Yakıt güncellemesi veya mevcut yakıt
      fuelPercent: fuelPercent ?? this.fuelPercent, // fuelPercent alanına değer aktarıyoruz
      // Elektrikli durumu güncellemesi
      isElectric: isElectric ?? this.isElectric, // isElectric alanına değer aktarıyoruz
      // Şanzıman güncellemesi
      transmission: transmission ?? this.transmission, // transmission alanına değer aktarıyoruz
      // Koltuk sayısı güncellemesi
      seatCount: seatCount ?? this.seatCount, // seatCount alanına değer aktarıyoruz
      // Günlük fiyat güncellemesi
      dailyPrice: dailyPrice ?? this.dailyPrice, // dailyPrice alanına değer aktarıyoruz
      // Haftalık fiyat güncellemesi
      weeklyPrice: weeklyPrice ?? this.weeklyPrice, // weeklyPrice alanına değer aktarıyoruz
      // Aylık fiyat güncellemesi
      monthlyPrice: monthlyPrice ?? this.monthlyPrice, // monthlyPrice alanına değer aktarıyoruz
      // Başlangıç tarihi güncellemesi
      availableFrom: availableFrom ?? this.availableFrom, // availableFrom alanına değer aktarıyoruz
      // Bitiş tarihi güncellemesi
      availableTo: availableTo ?? this.availableTo, // availableTo alanına değer aktarıyoruz
      // Konum güncellemesi
      location: location ?? this.location, // location alanına değer aktarıyoruz
      // Mesafe güncellemesi
      distanceKm: distanceKm ?? this.distanceKm, // distanceKm alanına değer aktarıyoruz
      // Resim URL güncellemesi
      imageUrl: imageUrl ?? this.imageUrl, // imageUrl alanına değer aktarıyoruz
      // Özellikler listesi güncellemesi
      features: features ?? this.features, // features alanına değer aktarıyoruz
      // Açıklama güncellemesi
      description: description ?? this.description, // description alanına değer aktarıyoruz
    );
  }

  // ---------------------------------------------------------------------------
  // SERİLEŞTİRME (JSON Dönüşümleri)
  // ---------------------------------------------------------------------------

  /// Map (JSON) verisinden tip güvenli CarModel nesnesi türeten fabrika kurucusu
  factory CarModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    // JSON anahtarlarını kontrol edip güvenli varsayılan değerlerle nesneyi oluşturuyoruz
    return CarModel(
      // JSON'daki id veya boş metin
      id: json['id'] as String? ?? '',
      // JSON'daki brand veya boş metin
      brand: json['brand'] as String? ?? '',
      // JSON'daki model veya boş metin
      model: json['model'] as String? ?? '',
      // JSON'daki yıl veya varsayılan 2024
      year: json['year'] as int? ?? 2024,
      // JSON'daki plaka veya boş metin
      plate: json['plate'] as String? ?? '',
      // JSON'daki yakıt veya varsayılan %100
      fuelPercent: json['fuelPercent'] as int? ?? 100,
      // JSON'daki elektrikli mi değeri
      isElectric: json['isElectric'] as bool? ?? false,
      // JSON'daki vites türü
      transmission: json['transmission'] as String? ?? 'Otomatik',
      // JSON'daki koltuk sayısı
      seatCount: json['seatCount'] as int? ?? 5,
      // JSON'daki günlük fiyat
      dailyPrice: (json['dailyPrice'] as num?)?.toDouble() ?? 0.0,
      // JSON'daki haftalık fiyat
      weeklyPrice: (json['weeklyPrice'] as num?)?.toDouble() ?? 0.0,
      // JSON'daki aylık fiyat
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble() ?? 0.0,
      // Başlangıç tarihi ayrıştırması
      availableFrom: json['availableFrom'] != null
          ? DateTime.parse(json['availableFrom'] as String)
          : DateTime.now(),
      // Bitiş tarihi ayrıştırması
      availableTo: json['availableTo'] != null
          ? DateTime.parse(json['availableTo'] as String)
          : DateTime.now().add(const Duration(days: 30)),
      // Teslim lokasyonu
      location: json['location'] as String? ?? 'İstanbul',
      // Mesafe bilgisi
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 1.0,
      // Fotoğraf bağlantısı
      imageUrl: json['imageUrl'] as String?,
      // Donanım listesi ayrıştırması
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      // Açıklama metni
      description: json['description'] as String? ?? '',
    );
  }

  /// CarModel nesnesini harici depolama için Map (JSON) yapısına çevirir
  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    // Nesnenin tüm alanlarını Map anahtar-değer ikililerine dönüştürüyoruz
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'plate': plate,
      'fuelPercent': fuelPercent,
      'isElectric': isElectric,
      'transmission': transmission,
      'seatCount': seatCount,
      'dailyPrice': dailyPrice,
      'weeklyPrice': weeklyPrice,
      'monthlyPrice': monthlyPrice,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
      'location': location,
      'distanceKm': distanceKm,
      'imageUrl': imageUrl,
      'features': features,
      'description': description,
    };
  }

  // İki CarModel nesnesinin ID bazında eşitliğini karşılaştıran operatör
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  bool operator ==(Object other) {
    // Aynı bellek referansı veya aynı ID'ye sahip nesneler eşittir
    return identical(this, other) ||
        other is CarModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  // Nesnenin hash kodunu ID üzerinden üreten getter
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  int get hashCode {
    // ID alanının hash kodunu döndürüyoruz
    return id.hashCode;
  }
}
