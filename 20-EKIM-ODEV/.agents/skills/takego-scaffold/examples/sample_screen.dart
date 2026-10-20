// ==============================================================================
// TakeGO Altın Standart Örnek Ekranı (Golden Standard Reference Screen)
//
// Bu dosya; TakeGO mimarisinin tüm temel kurallarını (Clean UI, ValueNotifier
// reaktif durum yönetimi, 16:9 sabit görsel oranı, dinamik periyot fiyatlaması,
// benzin göstergesi ve dijital anahtar entegrasyonu) tek bir yerde gösteren
// referans kod tabanıdır.
// ==============================================================================

import 'dart:async';
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// 1. MODELLER (models/car_model.dart & rental_period_type.dart)
// -----------------------------------------------------------------------------

enum RentalPeriodType {
  daily,
  weekly,
  monthly;

  String get label {
    switch (this) {
      case RentalPeriodType.daily:
        return 'Günlük';
      case RentalPeriodType.weekly:
        return 'Haftalık';
      case RentalPeriodType.monthly:
        return 'Aylık';
    }
  }

  String get unitSuffix {
    switch (this) {
      case RentalPeriodType.daily:
        return '₺ / Gün';
      case RentalPeriodType.weekly:
        return '₺ / Hafta';
      case RentalPeriodType.monthly:
        return '₺ / Ay';
    }
  }
}

@immutable
class CarModel {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final int fuelPercent; // %0 - %100 benzin / şarj seviyesi
  final bool isElectric;
  final String transmission; // 'Otomatik' veya 'Manuel'
  final int seatCount;
  final double dailyPrice;
  final double weeklyPrice;
  final double monthlyPrice;
  final DateTime availableFrom;
  final DateTime availableTo;
  final String location;
  final double distanceKm;
  final String? imageUrl;

  const CarModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.fuelPercent,
    required this.isElectric,
    required this.transmission,
    this.seatCount = 5,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.availableFrom,
    required this.availableTo,
    required this.location,
    this.distanceKm = 1.2,
    this.imageUrl,
  });

  double priceForPeriod(RentalPeriodType period) {
    switch (period) {
      case RentalPeriodType.daily:
        return dailyPrice;
      case RentalPeriodType.weekly:
        return weeklyPrice;
      case RentalPeriodType.monthly:
        return monthlyPrice;
    }
  }

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
  }) {
    return CarModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      fuelPercent: fuelPercent ?? this.fuelPercent,
      isElectric: isElectric ?? this.isElectric,
      transmission: transmission ?? this.transmission,
      seatCount: seatCount ?? this.seatCount,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      weeklyPrice: weeklyPrice ?? this.weeklyPrice,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      location: location ?? this.location,
      distanceKm: distanceKm ?? this.distanceKm,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

// -----------------------------------------------------------------------------
// 2. MOCK VERİLER (core/constants/mock_cars.dart)
// -----------------------------------------------------------------------------

final List<CarModel> sampleMockCars = [
  CarModel(
    id: 'car-1',
    brand: 'Tesla',
    model: 'Model Y Performance',
    year: 2024,
    plate: '34 TGO 100',
    fuelPercent: 88,
    isElectric: true,
    transmission: 'Otomatik',
    seatCount: 5,
    dailyPrice: 2850.0,
    weeklyPrice: 17500.0,
    monthlyPrice: 62000.0,
    availableFrom: DateTime.now(),
    availableTo: DateTime.now().add(const Duration(days: 45)),
    location: 'Kadıköy, İstanbul',
    distanceKm: 0.8,
  ),
  CarModel(
    id: 'car-2',
    brand: 'BMW',
    model: '320i M Sport',
    year: 2023,
    plate: '34 TGO 200',
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
    distanceKm: 2.4,
  ),
  CarModel(
    id: 'car-3',
    brand: 'Renault',
    model: 'Megane E-Tech',
    year: 2024,
    plate: '34 TGO 300',
    fuelPercent: 92,
    isElectric: true,
    transmission: 'Otomatik',
    seatCount: 5,
    dailyPrice: 1650.0,
    weeklyPrice: 10200.0,
    monthlyPrice: 38000.0,
    availableFrom: DateTime.now().add(const Duration(days: 1)),
    availableTo: DateTime.now().add(const Duration(days: 20)),
    location: 'Ataşehir, İstanbul',
    distanceKm: 3.1,
  ),
];

// -----------------------------------------------------------------------------
// 3. CONTROLLER (controller/car_listing_controller.dart)
// -----------------------------------------------------------------------------

class SampleCarListingController {
  // Reaktif Durumlar (ValueNotifier)
  final ValueNotifier<RentalPeriodType> selectedPeriod =
      ValueNotifier<RentalPeriodType>(RentalPeriodType.daily);

  final ValueNotifier<List<CarModel>> carsNotifier =
      ValueNotifier<List<CarModel>>([]);

  final ValueNotifier<bool> isCarUnlocked = ValueNotifier<bool>(false);
  final ValueNotifier<int> activeDriveSeconds = ValueNotifier<int>(0);
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  Timer? _driveTimer;

  void init() {
    carsNotifier.value = List.unmodifiable(sampleMockCars);
  }

  void changePeriod(RentalPeriodType period) {
    if (selectedPeriod.value != period) {
      selectedPeriod.value = period;
    }
  }

  void addNewListing(CarModel car) {
    carsNotifier.value = [car, ...carsNotifier.value];
  }

  void toggleLock() {
    isCarUnlocked.value = !isCarUnlocked.value;
    if (isCarUnlocked.value) {
      _startDriveTimer();
    } else {
      _stopDriveTimer();
    }
  }

  void _startDriveTimer() {
    _driveTimer?.cancel();
    activeDriveSeconds.value = 0;
    _driveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      activeDriveSeconds.value++;
    });
  }

  void _stopDriveTimer() {
    _driveTimer?.cancel();
  }

  void toggleTheme() {
    themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void dispose() {
    _driveTimer?.cancel();
    selectedPeriod.dispose();
    carsNotifier.dispose();
    isCarUnlocked.dispose();
    activeDriveSeconds.dispose();
    themeModeNotifier.dispose();
  }
}

// -----------------------------------------------------------------------------
// 4. SABİT GÖRSEL VE WIDGET KATMANI (widget/)
// -----------------------------------------------------------------------------

/// Kırmızı Çizgi Kuralı: İlan Kartı sabiti AspectRatio(16 / 9) veya height: 180.0
class SampleCarCardWidget extends StatelessWidget {
  final CarModel car;
  final RentalPeriodType selectedPeriod;
  final VoidCallback? onTap;

  const SampleCarCardWidget({
    super.key,
    required this.car,
    required this.selectedPeriod,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final price = car.priceForPeriod(selectedPeriod);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SABİT 16:9 GÖRSEL ALANI (RenderFlex Overflow Asla Yaşanmaz)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: colors.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        car.isElectric
                            ? Icons.electric_car_rounded
                            : Icons.directions_car_rounded,
                        size: 56,
                        color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  // Üst Sol: Yakıt / Batarya Göstergesi Rozeti
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _FuelBadge(
                      fuelPercent: car.fuelPercent,
                      isElectric: car.isElectric,
                    ),
                  ),
                  // Üst Sağ: Vites & Mesafe Rozeti
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${car.transmission} • ${car.distanceKm} km',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Araç Detay ve Fiyat Alanı
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${car.brand} ${car.model}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${price.toStringAsFixed(0)} ${selectedPeriod.unitSuffix}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Müsait: ${car.availableFrom.day}.${car.availableFrom.month} - ${car.availableTo.day}.${car.availableTo.month}',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        car.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Benzin veya Elektrik Seviyesi Rozeti
class _FuelBadge extends StatelessWidget {
  final int fuelPercent;
  final bool isElectric;

  const _FuelBadge({
    required this.fuelPercent,
    required this.isElectric,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isGood = fuelPercent >= 50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGood ? colors.secondary : colors.error,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isElectric ? Icons.bolt_rounded : Icons.local_gas_station_rounded,
            size: 15,
            color: isGood ? colors.secondary : colors.error,
          ),
          const SizedBox(width: 4),
          Text(
            '%$fuelPercent Depo',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. ANA EKRAN GÖRÜNÜMÜ (view/car_listing_view.dart)
// -----------------------------------------------------------------------------

class SampleCarListingView extends StatelessWidget {
  final SampleCarListingController controller;

  const SampleCarListingView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.electric_bolt_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'TakeGO',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
          ],
        ),
        actions: [
          // Gece / Gündüz Modu Değiştirici
          ValueListenableBuilder<ThemeMode>(
            valueListenable: controller.themeModeNotifier,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark ? 'Gündüz Moduna Geç' : 'Gece Moduna Geç',
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                ),
                onPressed: controller.toggleTheme,
              );
            },
          ),
          // Dijital Anahtar Asistanı Kısayolu
          IconButton(
            tooltip: 'Dijital Anahtar',
            icon: const Icon(Icons.key_rounded),
            onPressed: () => _openSmartKeySheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Periyot Filtre Seçici (SegmentedButton)
          ValueListenableBuilder<RentalPeriodType>(
            valueListenable: controller.selectedPeriod,
            builder: (context, period, _) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: SegmentedButton<RentalPeriodType>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: RentalPeriodType.daily,
                      label: Text('Günlük'),
                      icon: Icon(Icons.today_rounded),
                    ),
                    ButtonSegment(
                      value: RentalPeriodType.weekly,
                      label: Text('Haftalık'),
                      icon: Icon(Icons.view_week_rounded),
                    ),
                    ButtonSegment(
                      value: RentalPeriodType.monthly,
                      label: Text('Aylık'),
                      icon: Icon(Icons.calendar_month_rounded),
                    ),
                  ],
                  selected: {period},
                  onSelectionChanged: (selectedSet) {
                    controller.changePeriod(selectedSet.first);
                  },
                ),
              );
            },
          ),

          // Canlı İlan Listesi
          Expanded(
            child: ValueListenableBuilder<List<CarModel>>(
              valueListenable: controller.carsNotifier,
              builder: (context, cars, _) {
                if (cars.isEmpty) {
                  return const Center(child: Text('Kiralık araç bulunamadı.'));
                }
                return ValueListenableBuilder<RentalPeriodType>(
                  valueListenable: controller.selectedPeriod,
                  builder: (context, period, _) {
                    return ListView.builder(
                      itemCount: cars.length,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (context, index) {
                        final car = cars[index];
                        return SampleCarCardWidget(
                          car: car,
                          selectedPeriod: period,
                          onTap: () => _showCarQuickSummary(context, car, period),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateListingMock(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('İlan Ver'),
      ),
    );
  }

  void _showCarQuickSummary(
    BuildContext context,
    CarModel car,
    RentalPeriodType period,
  ) {
    final colors = Theme.of(context).colorScheme;
    final price = car.priceForPeriod(period);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${car.brand} ${car.model}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Plaka: ${car.plate} • %${car.fuelPercent} Depo • ${car.transmission}',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Periyot Tutarı:'),
                  Text(
                    '${price.toStringAsFixed(0)} ${period.unitSuffix}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openSmartKeySheet(context);
                  },
                  icon: const Icon(Icons.key_rounded),
                  label: const Text('Rezervasyon Yap & Dijital Anahtarı Al'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openSmartKeySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Dijital Kokpit Anahtarı',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: controller.isCarUnlocked,
                builder: (context, unlocked, _) {
                  return Column(
                    children: [
                      Icon(
                        unlocked
                            ? Icons.lock_open_rounded
                            : Icons.lock_outline_rounded,
                        size: 64,
                        color: unlocked
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        unlocked ? 'Araç Kilidi Açık' : 'Araç Kilitli',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: controller.toggleLock,
                        icon: Icon(
                          unlocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                        ),
                        label: Text(
                          unlocked ? 'Kapıları Kilitle' : 'Kapıları Aç & Sürüşe Başla',
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<int>(
                valueListenable: controller.activeDriveSeconds,
                builder: (context, seconds, _) {
                  if (seconds == 0) return const SizedBox.shrink();
                  final m = (seconds ~/ 60).toString().padLeft(2, '0');
                  final s = (seconds % 60).toString().padLeft(2, '0');
                  return Text(
                    'Aktif Sürüş Süresi: $m:$s',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openCreateListingMock(BuildContext context) {
    // Örnek hızlı ilan ekleme simülasyonu
    final newCar = CarModel(
      id: 'car-${DateTime.now().millisecondsSinceEpoch}',
      brand: 'Volvo',
      model: 'EX30 Ultra',
      year: 2024,
      plate: '34 TGO 444',
      fuelPercent: 95,
      isElectric: true,
      transmission: 'Otomatik',
      dailyPrice: 2200.0,
      weeklyPrice: 13500.0,
      monthlyPrice: 48000.0,
      availableFrom: DateTime.now(),
      availableTo: DateTime.now().add(const Duration(days: 60)),
      location: 'Beşiktaş, İstanbul',
    );

    controller.addNewListing(newCar);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Yeni ilan TakeGO vitrinine eklendi!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 6. ÖNİZLEME UYGULAMA GİRİŞİ (Preview Runner)
// -----------------------------------------------------------------------------

void main() {
  final controller = SampleCarListingController()..init();

  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: controller.themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TakeGO Örnek Ekran',
          themeMode: mode,
          // Clean Mobility Light Teması
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF6F8FA),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0066FF),
              secondary: Color(0xFF00D084),
              surface: Color(0xFFFFFFFF),
              surfaceContainerHighest: Color(0xFFE2E8F0),
              onSurface: Color(0xFF111827),
              onSurfaceVariant: Color(0xFF6B7280),
              outlineVariant: Color(0xFFE5E7EB),
            ),
          ),
          // OLED Cockpit Dark Teması
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0B0E14),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2F80ED),
              secondary: Color(0xFF10B981),
              surface: Color(0xFF161B26),
              surfaceContainerHighest: Color(0xFF1F2937),
              onSurface: Color(0xFFF9FAFB),
              onSurfaceVariant: Color(0xFF9CA3AF),
              outlineVariant: Color(0xFF242C3D),
            ),
          ),
          home: SampleCarListingView(controller: controller),
        );
      },
    ),
  );
}
