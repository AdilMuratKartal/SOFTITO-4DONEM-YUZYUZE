import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takego/core/theme/theme_controller.dart';
import 'package:takego/features/car_detail/controller/car_detail_controller.dart';
import 'package:takego/features/car_listing/controller/car_listing_controller.dart';
import 'package:takego/features/car_listing/models/car_model.dart';
import 'package:takego/features/car_listing/models/rental_period_type.dart';
import 'package:takego/features/car_listing/widget/car_card_widget.dart';
import 'package:takego/features/create_listing/controller/create_listing_controller.dart';
import 'package:takego/features/smart_key_assistant/controller/smart_key_controller.dart';
import 'package:takego/main.dart';

void main() {
  group('1. ThemeController Unit Tests', () {
    late ThemeController themeController;

    setUp(() {
      themeController = ThemeController();
    });

    tearDown(() {
      themeController.dispose();
    });

    test('Varsayılan tema koyu mod (OLED Dark) olmalıdır', () {
      expect(themeController.currentMode, equals(ThemeMode.dark));
      expect(themeController.isDarkMode, isTrue);
    });

    test('toggleTheme aydınlık ve karanlık mod arasında geçiş yapmalıdır', () {
      themeController.toggleTheme();
      expect(themeController.currentMode, equals(ThemeMode.light));
      expect(themeController.isDarkMode, isFalse);

      themeController.toggleTheme();
      expect(themeController.currentMode, equals(ThemeMode.dark));
    });
  });

  group('2. CarListingController Unit Tests', () {
    late CarListingController controller;

    setUp(() {
      controller = CarListingController()..init();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta mock araçlar ve günlük periyot yüklenmelidir', () {
      expect(controller.displayedCarsNotifier.value.isNotEmpty, isTrue);
      expect(controller.selectedPeriod.value, equals(RentalPeriodType.daily));
    });

    test('changePeriod kiralama periyodunu güncellemelidir', () {
      controller.changePeriod(RentalPeriodType.weekly);
      expect(controller.selectedPeriod.value, equals(RentalPeriodType.weekly));
    });

    test('updateSearchQuery marka ve modele göre filtreleme yapmalıdır', () {
      controller.updateSearchQuery('Tesla');
      expect(
        controller.displayedCarsNotifier.value.every((c) => c.brand.contains('Tesla')),
        isTrue,
      );
    });

    test('toggleElectricFilter sadece elektrikli araçları getirmelidir', () {
      controller.toggleElectricFilter();
      expect(controller.electricOnlyNotifier.value, isTrue);
      expect(
        controller.displayedCarsNotifier.value.every((c) => c.isElectric),
        isTrue,
      );
    });
  });

  group('3. CarDetailController Price Calculation Tests', () {
    final sampleCar = CarModel(
      id: 'test-car',
      brand: 'Tesla',
      model: 'Model Y',
      year: 2024,
      plate: '34 TST 01',
      fuelPercent: 90,
      isElectric: true,
      transmission: 'Otomatik',
      dailyPrice: 2000.0,
      weeklyPrice: 12000.0,
      monthlyPrice: 45000.0,
      availableFrom: DateTime.now(),
      availableTo: DateTime.now().add(const Duration(days: 30)),
      location: 'İstanbul',
    );

    test('Günlük ve haftalık toplam tutarlar doğru hesaplanmalıdır', () {
      final detailController = CarDetailController(car: sampleCar);

      // 1 günlük hesaplama: 2000 + 150 (kasko) + 100 (hizmet bedeli %5) = 2250 ₺
      expect(detailController.baseAmount, equals(2000.0));
      expect(detailController.insuranceAmount, equals(150.0));
      expect(detailController.serviceFee, equals(100.0));
      expect(detailController.totalAmount, equals(2250.0));

      // 2 güne çıkarıldığında: 4000 + 300 + 200 = 4500 ₺
      detailController.setDuration(2);
      expect(detailController.baseAmount, equals(4000.0));
      expect(detailController.totalAmount, equals(4500.0));

      detailController.dispose();
    });
  });

  group('4. SmartKeyController Actions Tests', () {
    late SmartKeyController controller;

    setUp(() {
      controller = SmartKeyController()..init();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Kapı kilidi açıldığında sürüş sayacı başlamalıdır', () {
      expect(controller.isCarUnlocked.value, isFalse);

      controller.toggleCarLock();
      expect(controller.isCarUnlocked.value, isTrue);
      expect(controller.isDrivingNotifier.value, isTrue);

      controller.toggleCarLock();
      expect(controller.isCarUnlocked.value, isFalse);
    });

    test('finishDriveSession sürüşü sonlandırıp özet dönmelidir', () {
      controller.toggleCarLock(); // Aç
      final summary = controller.finishDriveSession();

      expect(summary.containsKey('minutes'), isTrue);
      expect(summary.containsKey('fuelPercentUsed'), isTrue);
      expect(controller.isCarUnlocked.value, isFalse);
    });
  });

  group('5. CreateListingController Form Tests', () {
    late CreateListingController controller;

    setUp(() {
      controller = CreateListingController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Eksik bilgi girildiğinde hata mesajı dönmelidir', () {
      final result = controller.submitListing();
      expect(result, isNull);
      expect(controller.errorMessageNotifier.value, isNotNull);
    });

    test('Geçerli bilgiler girildiğinde CarModel üretilmelidir', () {
      controller.brandController.text = 'Audi';
      controller.modelController.text = 'A4';
      controller.yearController.text = '2023';
      controller.plateController.text = '34 AUD 04';
      controller.dailyPriceController.text = '1800';

      final car = controller.submitListing();
      expect(car, isNotNull);
      expect(car!.brand, equals('Audi'));
      expect(car.dailyPrice, equals(1800.0));
    });
  });

  group('6. UI & Widget Fixed Image Tests', () {
    testWidgets('İlan kartı sabit 16:9 AspectRatio ile çizilmelidir', (tester) async {
      final sampleCar = CarModel(
        id: 'c1',
        brand: 'BMW',
        model: '320i',
        year: 2024,
        plate: '34 BMW 01',
        fuelPercent: 80,
        isElectric: false,
        transmission: 'Otomatik',
        dailyPrice: 2500.0,
        weeklyPrice: 15000.0,
        monthlyPrice: 50000.0,
        availableFrom: DateTime.now(),
        availableTo: DateTime.now().add(const Duration(days: 10)),
        location: 'Kadıköy',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarCardWidget(
              car: sampleCar,
              selectedPeriod: RentalPeriodType.daily,
            ),
          ),
        ),
      );

      // AspectRatio widget'ını bul ve 16:9 olduğunu doğrula
      final aspectRatioFinder = find.byType(AspectRatio);
      expect(aspectRatioFinder, findsOneWidget);

      final AspectRatio ar = tester.widget(aspectRatioFinder);
      expect(ar.aspectRatio, equals(16 / 9));

      // Kart içeriğini doğrula
      expect(find.text('BMW 320i'), findsOneWidget);
      expect(find.text('2500 ₺ / Gün'), findsOneWidget);
    });

    testWidgets('TakeGoApp ana gezinme sekmesi hatasız açılmalıdır', (tester) async {
      final themeController = ThemeController();

      await tester.pumpWidget(TakeGoApp(themeController: themeController));
      await tester.pump();

      // Üst barda TakeGO logosunu kontrol et
      expect(find.text('TakeGO'), findsOneWidget);

      // Alt gezinti sekmelerini doğrula
      expect(find.text('İlanlar'), findsOneWidget);
      expect(find.text('İlan Ver'), findsNWidgets(2)); // Hem FAB hem NavigationBar etiketi
      expect(find.text('Kokpit'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      themeController.dispose();
    });
  });
}
