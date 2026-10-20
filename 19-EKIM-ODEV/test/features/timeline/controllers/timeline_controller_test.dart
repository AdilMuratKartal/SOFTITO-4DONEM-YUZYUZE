import 'package:flutter_test/flutter_test.dart';
import 'package:ijournal/core/services/storage_service.dart';
import 'package:ijournal/features/entry_editor/models/journal_entry_model.dart';
import 'package:ijournal/features/timeline/controllers/timeline_controller.dart';

void main() {
  group('TimelineController Tests', () {
    late TimelineController controller;

    setUp(() async {
      await StorageService.instance.init();
      controller = TimelineController();
      await controller.init();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta veriler yüklenmiş olmalıdır', () {
      expect(controller.filteredEntriesNotifier.value.isNotEmpty, isTrue);
    });

    test('selectMonth ve selectDay çağrıldığında tarihler güncellenmelidir', () {
      controller.selectMonth(5); // Mayıs
      expect(controller.selectedMonthNotifier.value, 5);

      final newDate = DateTime(controller.selectedYearNotifier.value, 5, 12);
      controller.selectDay(newDate);
      expect(controller.selectedDayNotifier.value, newDate);
    });

    test('selectCreationMood seçilen ruh halini günceller', () {
      controller.selectCreationMood('🔥');
      expect(controller.selectedMoodForCreationNotifier.value, '🔥');
    });

    test('Arama filtresi doğru çalışmalıdır', () {
      controller.updateSearch('Kahve');
      expect(
        controller.filteredEntriesNotifier.value
            .every((e) => e.title.contains('Kahve') || e.content.contains('Kahve')),
        isTrue,
      );
    });

    test('Duygu filtresi doğru çalışmalıdır', () {
      controller.setMoodFilter('✨');
      expect(
        controller.filteredEntriesNotifier.value.every((e) => e.mood == '✨'),
        isTrue,
      );
    });

    test('Yeni öğe eklendiğinde filtre güncellenmelidir', () async {
      final entry = JournalEntry(
        id: 'test_123',
        title: 'Birim Test Günlüğü',
        content: 'Test içeriği',
        createdAt: DateTime.now(),
        mood: '💡',
      );

      await StorageService.instance.saveEntry(entry);
      expect(
        controller.filteredEntriesNotifier.value.any((e) => e.id == 'test_123'),
        isTrue,
      );
    });
  });
}
