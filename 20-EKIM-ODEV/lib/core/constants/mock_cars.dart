// Araç veri modelini içe aktarıyoruz
import '../../features/car_listing/models/car_model.dart';

/// TakeGO Başlangıç Bellek İçi Araç Veri Havuzu (In-Memory Mock Cars)
///
/// Gerçek sunucu bağlantısı olmadığında uygulamanın ilk açılışta
/// zengin bir araç vitrini sunması için kullanılan başlangıç listesidir.
/// Yeni ilan eklendiğinde dinamik olarak bu listeye tip güvenli eklenir.
final List<CarModel> initialMockCars = [
  // 1. Araç: Tesla Model Y (Elektrikli SUV)
  CarModel(
    id: 'car-101',
    brand: 'Tesla',
    model: 'Model Y Long Range',
    year: 2024,
    plate: '34 TGO 101',
    fuelPercent: 88,
    isElectric: true,
    transmission: 'Otomatik',
    seatCount: 5,
    dailyPrice: 2850.0,
    weeklyPrice: 17500.0,
    monthlyPrice: 64000.0,
    availableFrom: DateTime.now(),
    availableTo: DateTime.now().add(const Duration(days: 45)),
    location: 'Kadıköy, İstanbul',
    distanceKm: 0.8,
    features: const [
      'Otopilot',
      'Cam Tavan',
      'Kablosuz Şarj',
      'Isıtmalı Koltuklar',
    ],
    description:
        'Sıfır ayarında, uzun menzilli elektrikli SUV. Şehir içi ve uzun yol için dijital anahtarla anında teslim.',
  ),

  // 2. Araç: BMW 320i M Sport (Benzinli Sedan)
  CarModel(
    id: 'car-102',
    brand: 'BMW',
    model: '320i M Sport Edition',
    year: 2023,
    plate: '34 TGO 202',
    fuelPercent: 65,
    isElectric: false,
    transmission: 'Otomatik',
    seatCount: 5,
    dailyPrice: 2400.0,
    weeklyPrice: 14800.0,
    monthlyPrice: 53000.0,
    availableFrom: DateTime.now(),
    availableTo: DateTime.now().add(const Duration(days: 30)),
    location: 'Levent, İstanbul',
    distanceKm: 2.1,
    features: const [
      'Harman Kardon Ses',
      'M Sport Direksiyon',
      'Hayalet Gösterge',
      'Sunroof',
    ],
    description:
        'Dinamik sürüş performansı ve prestij arayanlar için temiz, bakımlı M Sport donanımlı sedan.',
  ),

  // 3. Araç: Volvo EX30 Ultra (Kompakt Elektrikli)
  CarModel(
    id: 'car-103',
    brand: 'Volvo',
    model: 'EX30 Twin Motor Ultra',
    year: 2024,
    plate: '34 TGO 303',
    fuelPercent: 94,
    isElectric: true,
    transmission: 'Otomatik',
    seatCount: 5,
    dailyPrice: 2150.0,
    weeklyPrice: 13200.0,
    monthlyPrice: 47000.0,
    availableFrom: DateTime.now().add(const Duration(days: 1)),
    availableTo: DateTime.now().add(const Duration(days: 60)),
    location: 'Beşiktaş, İstanbul',
    distanceKm: 1.4,
    features: const [
      'Pilot Assist',
      'Harman Kardon Soundbar',
      '360 Derece Kamera',
    ],
    description:
        'İskandinav zarafeti ve yüksek güvenlik. Şehir içi pratik park ve seri elektrikli hızlanma.',
  ),

  // 4. Araç: Renault Megane E-Tech (Elektrikli Hatchback)
  CarModel(
    id: 'car-104',
    brand: 'Renault',
    model: 'Megane E-Tech Iconic',
    year: 2024,
    plate: '34 TGO 404',
    fuelPercent: 78,
    isElectric: true,
    transmission: 'Otomatik',
    seatCount: 5,
    dailyPrice: 1650.0,
    weeklyPrice: 10200.0,
    monthlyPrice: 38000.0,
    availableFrom: DateTime.now(),
    availableTo: DateTime.now().add(const Duration(days: 20)),
    location: 'Ataşehir, İstanbul',
    distanceKm: 3.5,
    features: const [
      'OpenR Link Ekran',
      'Şerit Takip Asistanı',
      'Hızlı Şarj Desteği',
    ],
    description:
        'Ekonomik ve teknolojik elektrikli sürüş deneyimi. Geniş bagaj hacmi ve modern kokpit.',
  ),

  // 5. Araç: Mercedes-Benz EQE (Lüks Elektrikli Sedan)
  CarModel(
    id: 'car-105',
    brand: 'Mercedes-Benz',
    model: 'EQE 350+ AMG Line',
    year: 2024,
    plate: '34 TGO 505',
    fuelPercent: 90,
    isElectric: true,
    transmission: 'Otomatik',
    seatCount: 5,
    dailyPrice: 3800.0,
    weeklyPrice: 23500.0,
    monthlyPrice: 85000.0,
    availableFrom: DateTime.now().add(const Duration(days: 2)),
    availableTo: DateTime.now().add(const Duration(days: 90)),
    location: 'Sarıyer, İstanbul',
    distanceKm: 4.8,
    features: const [
      'MBUX Hyperscreen',
      'Hava Süspansiyonu',
      'Burmester 3D Ses',
      'Masajlı Koltuklar',
    ],
    description:
        'Üst düzey lüks ve sessizlik. Özel iş seyahatleri veya prestijli davetler için mükemmel seçim.',
  ),

  // 6. Araç: Porsche Taycan 4S (Elektrikli Spor)
  CarModel(
    id: 'car-106',
    brand: 'Porsche',
    model: 'Taycan 4S Performance Plus',
    year: 2023,
    plate: '34 TGO 606',
    fuelPercent: 82,
    isElectric: true,
    transmission: 'Otomatik',
    seatCount: 4,
    dailyPrice: 5200.0,
    weeklyPrice: 32000.0,
    monthlyPrice: 115000.0,
    availableFrom: DateTime.now(),
    availableTo: DateTime.now().add(const Duration(days: 15)),
    location: 'Zorlu Center, İstanbul',
    distanceKm: 2.8,
    features: const [
      'Performans Bataryası',
      'Sport Chrono Paket',
      'Dinamik Şasi Kontrolü',
    ],
    description:
        'Adrenalin ve saf elektrik gücü bir arada. Pist genlerine sahip süper spor otomobil.',
  ),
];
