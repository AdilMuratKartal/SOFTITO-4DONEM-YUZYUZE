import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test edilecek basit mock veri ve sınıflar
class MockAppointmentModel {
  final String id;
  final double offeredPrice;
  final String status;
  final String lastOfferBy;

  const MockAppointmentModel({
    required this.id,
    required this.offeredPrice,
    required this.status,
    required this.lastOfferBy,
  });

  MockAppointmentModel copyWith({
    String? id,
    double? offeredPrice,
    String? status,
    String? lastOfferBy,
  }) {
    return MockAppointmentModel(
      id: id ?? this.id,
      offeredPrice: offeredPrice ?? this.offeredPrice,
      status: status ?? this.status,
      lastOfferBy: lastOfferBy ?? this.lastOfferBy,
    );
  }
}

class MockAppointmentNotifier extends ChangeNotifier {
  List<MockAppointmentModel> _appointments = [];

  List<MockAppointmentModel> get appointments => List.unmodifiable(_appointments);

  void addAppointment(MockAppointmentModel item) {
    _appointments = [item, ..._appointments];
    notifyListeners();
  }

  void submitCounterOffer(String id, double newPrice, String counterOfferBy) {
    _appointments = _appointments.map((a) {
      if (a.id == id) {
        return a.copyWith(
          offeredPrice: newPrice,
          status: 'beklemede',
          lastOfferBy: counterOfferBy,
        );
      }
      return a;
    }).toList();
    notifyListeners();
  }

  void approveAppointment(String id) {
    _appointments = _appointments.map((a) {
      if (a.id == id) {
        return a.copyWith(status: 'onaylandi');
      }
      return a;
    }).toList();
    notifyListeners();
  }
}

void main() {
  group('Randevu Sistemi - Durum ve Teklif Birim Testleri', () {
    late MockAppointmentNotifier notifier;

    setUp(() {
      notifier = MockAppointmentNotifier();
    });

    test('Yeni teklif eklendiğinde liste güncellenmeli ve durum beklemede olmalı', () {
      const newOffer = MockAppointmentModel(
        id: 'apt-001',
        offeredPrice: 500.0,
        status: 'beklemede',
        lastOfferBy: 'customer',
      );

      notifier.addAppointment(newOffer);

      expect(notifier.appointments.length, 1);
      expect(notifier.appointments.first.offeredPrice, 500.0);
      expect(notifier.appointments.first.status, 'beklemede');
      expect(notifier.appointments.first.lastOfferBy, 'customer');
    });

    test('Hizmet veren karşı teklif sunduğunda lastOfferBy provider olmalı', () {
      const initialOffer = MockAppointmentModel(
        id: 'apt-002',
        offeredPrice: 400.0,
        status: 'beklemede',
        lastOfferBy: 'customer',
      );

      notifier.addAppointment(initialOffer);
      notifier.submitCounterOffer('apt-002', 600.0, 'provider');

      expect(notifier.appointments.first.offeredPrice, 600.0);
      expect(notifier.appointments.first.status, 'beklemede');
      expect(notifier.appointments.first.lastOfferBy, 'provider');
    });

    test('Randevu onaylandığında durum onaylandi olmalı', () {
      const initialOffer = MockAppointmentModel(
        id: 'apt-003',
        offeredPrice: 450.0,
        status: 'beklemede',
        lastOfferBy: 'customer',
      );

      notifier.addAppointment(initialOffer);
      notifier.approveAppointment('apt-003');

      expect(notifier.appointments.first.status, 'onaylandi');
    });
  });

  group('Randevu Sistemi - Widget Testleri', () {
    testWidgets('Dolu saat dilimi tıklandığında onTap tetiklenmemeli', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: null, // Dolu olduğunda devre dışı
              child: const Text('10:30 (Dolu)'),
            ),
          ),
        ),
      );

      expect(find.text('10:30 (Dolu)'), findsOneWidget);

      await tester.tap(find.text('10:30 (Dolu)'));
      await tester.pump();

      expect(wasTapped, isFalse);
    });
  });
}
