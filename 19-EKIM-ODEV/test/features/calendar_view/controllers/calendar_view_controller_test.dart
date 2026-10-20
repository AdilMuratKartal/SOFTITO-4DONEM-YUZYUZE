import 'package:flutter_test/flutter_test.dart';
import 'package:ijournal/core/services/storage_service.dart';
import 'package:ijournal/features/calendar_view/controllers/calendar_controller.dart';

void main() {
  group('CalendarController Tests', () {
    late CalendarController controller;

    setUp(() async {
      await StorageService.instance.init();
      controller = CalendarController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Bugünün tarihi seçili başlamalıdır', () {
      final now = DateTime.now();
      expect(controller.selectedDateNotifier.value.year, now.year);
      expect(controller.selectedDateNotifier.value.month, now.month);
      expect(controller.selectedDateNotifier.value.day, now.day);
    });

    test('selectDate çağrıldığında tarih güncellenmelidir', () {
      final target = DateTime(2026, 10, 15);
      controller.selectDate(target);

      expect(controller.selectedDateNotifier.value, target);
    });

    test('changeMonth ay değerini artırıp azaltmalıdır', () {
      final current = controller.focusedDateNotifier.value;
      controller.changeMonth(1);

      expect(controller.focusedDateNotifier.value.month, (current.month % 12) + 1);
    });
  });
}
