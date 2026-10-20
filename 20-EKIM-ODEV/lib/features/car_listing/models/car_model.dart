// Immutable (değişmezlik) anotasyonu ve temel sınıflar için foundation paketini içe aktarıyoruz
import 'package:flutter/foundation.dart';
// Kiralama periyot türlerini (günlük, haftalık, aylık) içe aktarıyoruz
import 'rental_period_type.dart';

/// TakeGO Araç İlan Modeli (CarModel)
///
/// Sistemdeki tüm kiralık araçların verilerini taşıyan,
/// `@immutable` ve tip güvenli ana veri modelidir.
@immutable
class CarModel {
  // ---------------------------------------------------------------------------
  // MODEL ALANLARI (Properties)
  // ---------------------------------------------------------------------------

  /// Aracın benzersiz kimlik numarası (Örn: 'car-101')
  final String id;

  /// Araç üretici markası (Örn: 'Tesla', 'BMW', 'Volvo')
  final String brand;

  /// Araç model adı ve paket detayı (Örn: 'Model Y Long Range')
  final String model;

  /// Üretim model yılı (Örn: 2024)
  final int year;

  /// Araç tescil plakası (Örn: '34 TGO 101')
  final String plate;

  /// Benzin deposu veya batarya şarj yüzdesi (%0 - %100)
  final int fuelPercent;

  /// Aracın %100 elektrikli olup olmadığı bilgisi (true: elektrikli, false: içten yanmalı)
  final bool isElectric;

  /// Şanzıman türü ('Otomatik' veya 'Manuel')
  final String transmission;

  /// Araç yolcu koltuk kapasitesi (Varsayılan: 5 kişi)
  final int seatCount;

  /// Günlük kiralama birim fiyatı (TL)
  final double dailyPrice;

  /// Haftalık kiralama birim fiyatı (TL)
  final double weeklyPrice;

  /// Aylık kiralama birim fiyatı (TL)
  final double monthlyPrice;

  /// Kiralanabilirliğin başladığı ilk tarih
  final DateTime availableFrom;

  /// Kiralanabilirliğin sona erdiği son tarih
  final DateTime availableTo;

  /// Aracın teslim alınacağı ilçe ve şehir lokasyonu (Örn: 'Kadıköy, İstanbul')
  final String location;

  /// Kullanıcının konumuna olan yaklaşık mesafe (km cinsinden)
  final double distanceKm;

  /// Araç görselinin URL bağlantısı (Opsiyonel / Nullable)
  final String? imageUrl;

  /// Araç donanım özellikleri listesi (Örn: ['Otopilot', 'Cam Tavan'])
  final List<String> features;

  /// Araç sahibi açıklaması ve kiralama notları
  final String description;

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// CarModel kurucusu (const destekli değişmez yapı)
  const CarModel({
    // Zorunlu benzersiz ID
    required this.id,
    // Zorunlu araç markası
    required this.brand,
    // Zorunlu araç modeli
    required this.model,
    // Zorunlu üretim yılı
    required this.year,
    // Zorunlu plaka bilgisi
    required this.plate,
    // Zorunlu yakıt / şarj yüzdesi
    required this.fuelPercent,
    // Zorunlu elektrikli araç durumu
    required this.isElectric,
    // Zorunlu şanzıman tipi
    required this.transmission,
    // Koltuk sayısı (varsayılan: 5)
    this.seatCount = 5,
    // Zorunlu günlük fiyat
    required this.dailyPrice,
    // Zorunlu haftalık fiyat
    required this.weeklyPrice,
    // Zorunlu aylık fiyat
    required this.monthlyPrice,
    // Zorunlu müsaitlik başlangıç tarihi
    required this.availableFrom,
    // Zorunlu müsaitlik bitiş tarihi
    required this.availableTo,
    // Zorunlu teslim konumu
    required this.location,
    // Yakınlık mesafesi (varsayılan: 1.0 km)
    this.distanceKm = 1.0,
    // Opsiyonel fotoğraf bağlantısı
    this.imageUrl,
    // Donanım listesi (varsayılan boş liste)
    this.features = const [],
    // Açıklama metni (varsayılan tanıtım metni)
    this.description = 'TakeGO güvencesiyle anında kiralanabilir araç.',
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
  CarModel copyWith({
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
      id: id ?? this.id,
      // Marka güncellemesi veya mevcut marka
      brand: brand ?? this.brand,
      // Model güncellemesi veya mevcut model
      model: model ?? this.model,
      // Yıl güncellemesi veya mevcut yıl
      year: year ?? this.year,
      // Plaka güncellemesi veya mevcut plaka
      plate: plate ?? this.plate,
      // Yakıt güncellemesi veya mevcut yakıt
      fuelPercent: fuelPercent ?? this.fuelPercent,
      // Elektrikli durumu güncellemesi
      isElectric: isElectric ?? this.isElectric,
      // Şanzıman güncellemesi
      transmission: transmission ?? this.transmission,
      // Koltuk sayısı güncellemesi
      seatCount: seatCount ?? this.seatCount,
      // Günlük fiyat güncellemesi
      dailyPrice: dailyPrice ?? this.dailyPrice,
      // Haftalık fiyat güncellemesi
      weeklyPrice: weeklyPrice ?? this.weeklyPrice,
      // Aylık fiyat güncellemesi
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      // Başlangıç tarihi güncellemesi
      availableFrom: availableFrom ?? this.availableFrom,
      // Bitiş tarihi güncellemesi
      availableTo: availableTo ?? this.availableTo,
      // Konum güncellemesi
      location: location ?? this.location,
      // Mesafe güncellemesi
      distanceKm: distanceKm ?? this.distanceKm,
      // Resim URL güncellemesi
      imageUrl: imageUrl ?? this.imageUrl,
      // Özellikler listesi güncellemesi
      features: features ?? this.features,
      // Açıklama güncellemesi
      description: description ?? this.description,
    );
  }

  // ---------------------------------------------------------------------------
  // SERİLEŞTİRME (JSON Dönüşümleri)
  // ---------------------------------------------------------------------------

  /// Map (JSON) verisinden tip güvenli CarModel nesnesi türeten fabrika kurucusu
  factory CarModel.fromJson(Map<String, dynamic> json) {
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
  Map<String, dynamic> toJson() {
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
  @override
  bool operator ==(Object other) {
    // Aynı bellek referansı veya aynı ID'ye sahip nesneler eşittir
    return identical(this, other) ||
        other is CarModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  // Nesnenin hash kodunu ID üzerinden üreten getter
  @override
  int get hashCode {
    // ID alanının hash kodunu döndürüyoruz
    return id.hashCode;
  }
}
