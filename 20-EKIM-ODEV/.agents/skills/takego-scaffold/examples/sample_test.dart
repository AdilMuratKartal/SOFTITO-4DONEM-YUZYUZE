// ==============================================================================
// TakeGO Altın Standart Birim ve Widget Test Örneği (sample_test.dart)
//
// Bu dosya; TakeGO mimarisindeki ValueNotifier durum testleri, sabit 16:9
// resim boyutu widget testleri ve gece/gündüz tema uyumu testlerinin
// nasıl yazılacağını gösteren eksiksiz bir örnektir.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sample_screen.dart';

void main() {
  group('SampleCarListingController Unit Tests', () {
    late SampleCarListingController controller;

    setUp(() {
      controller = SampleCarListingController()..init();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta mock araçlar yüklenmiş olmalıdır', () {
      expect(controller.carsNotifier.value.isNotEmpty, isTrue);
      expect(controller.selectedPeriod.value, equals(RentalPeriodType.daily));
      expect(controller.isCarUnlocked.value, isFalse);
      expect(controller.activeDriveSeconds.value, equals(0));
    });

    test('changePeriod seçili periyodu değiştirmelidir', () {
      controller.changePeriod(RentalPeriodType.weekly);
      expect(controller.selectedPeriod.value, equals(RentalPeriodType.weekly));

      controller.changePeriod(RentalPeriodType.monthly);
      expect(controller.selectedPeriod.value, equals(RentalPeriodType.monthly));
    });

    test('addNewListing yeni aracı listenin başına eklemelidir', () {
      final newCar = CarModel(
        id: 'test-car',
        brand: 'Porsche',
        model: 'Taycan 4S',
        year: 2024,
        plate: '34 TGO 999',
        fuelPercent: 99,
        isElectric: true,
        transmission: 'Otomatik',
        dailyPrice: 5000.0,
        weeklyPrice: 30000.0,
        monthlyPrice: 110000.0,
        availableFrom: DateTime.now(),
        availableTo: DateTime.now().add(const Duration(days: 15)),
        location: 'Zorlu Center, İstanbul',
      );

      final initialCount = controller.carsNotifier.value.length;
      controller.addNewListing(newCar);

      expect(controller.carsNotifier.value.length, equals(initialCount + 1));
      expect(controller.carsNotifier.value.first.id, equals('test-car'));
    });

    test('toggleLock kapı kilidi durumunu tersine çevirmelidir', () {
      expect(controller.isCarUnlocked.value, isFalse);

      controller.toggleLock();
      expect(controller.isCarUnlocked.value, isTrue);

      controller.toggleLock();
      expect(controller.isCarUnlocked.value, isFalse);
    });

    test('toggleTheme karanlık ve aydınlık mod arasında geçiş yapmalıdır', () {
      expect(controller.themeModeNotifier.value, equals(ThemeMode.dark));

      controller.toggleTheme();
      expect(controller.themeModeNotifier.value, equals(ThemeMode.light));

      controller.toggleTheme();
      expect(controller.themeModeNotifier.value, equals(ThemeMode.dark));
    });
  });

  group('SampleCarCardWidget UI & Fixed Dimension Tests', () {
    final testCar = CarModel(
      id: 'test-car-1',
      brand: 'Audi',
      model: 'e-tron GT',
      year: 2024,
      plate: '34 AUD 01',
      fuelPercent: 75,
      isElectric: true,
      transmission: 'Otomatik',
      dailyPrice: 3500.0,
      weeklyPrice: 22000.0,
      monthlyPrice: 80000.0,
      availableFrom: DateTime(2024, 10, 20),
      availableTo: DateTime(2024, 11, 20),
      location: 'Maslak, İstanbul',
      distanceKm: 1.5,
    );

    testWidgets('İlan kartı sabit 16:9 görsel alanı içermelidir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: SampleCarCardWidget(
              car: testCar,
              selectedPeriod: RentalPeriodType.daily,
            ),
          ),
        ),
      );

      // 16:9 AspectRatio widget'ının varlığını kontrol et
      final aspectRatioFinder = find.byType(AspectRatio);
      expect(aspectRatioFinder, findsOneWidget);

      final AspectRatio aspectRatioWidget = tester.widget(aspectRatioFinder);
      expect(aspectRatioWidget.aspectRatio, equals(16 / 9));

      // Marka ve model metninin doğru render edildiğini doğrula
      expect(find.text('Audi e-tron GT'), findsOneWidget);

      // Benzin/şarj rozetini doğrula
      expect(find.text('%75 Depo'), findsOneWidget);

      // Günlük birim fiyatını doğrula
      expect(find.text('3500 ₺ / Gün'), findsOneWidget);
    });

    testWidgets('Haftalık periyot seçildiğinde fiyat etiketi güncellenmelidir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SampleCarCardWidget(
              car: testCar,
              selectedPeriod: RentalPeriodType.weekly,
            ),
          ),
        ),
      );

      // Haftalık birim fiyatını doğrula
      expect(find.text('22000 ₺ / Hafta'), findsOneWidget);
    });

    testWidgets('Karta tıklandığında onTap callback tetiklenmelidir', (tester) async {
      var isTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SampleCarCardWidget(
              car: testCar,
              selectedPeriod: RentalPeriodType.daily,
              onTap: () {
                isTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SampleCarCardWidget));
      expect(isTapped, isTrue);
    });
  });
}
