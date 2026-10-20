import 'package:flutter_test/flutter_test.dart';
import 'package:ijournal/features/entry_editor/controllers/entry_editor_controller.dart';

void main() {
  group('EntryEditorController Tests', () {
    late EntryEditorController controller;

    setUp(() {
      controller = EntryEditorController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç değerleri doğru atanmalıdır', () {
      expect(controller.titleNotifier.value, isEmpty);
      expect(controller.contentNotifier.value, isEmpty);
      expect(controller.selectedMoodNotifier.value, '😊');
      expect(controller.tagsNotifier.value, isEmpty);
      expect(controller.isSavingNotifier.value, isFalse);
    });

    test('updateTitle ve updateContent doğru güncellenmelidir', () {
      controller.updateTitle('Harika Bir Gün');
      controller.updateContent('Bugün iJournal ile günlük tuttum.');

      expect(controller.titleNotifier.value, 'Harika Bir Gün');
      expect(controller.contentNotifier.value, 'Bugün iJournal ile günlük tuttum.');
    });

    test('addTag ve removeTag doğru çalışmalıdır', () {
      controller.addTag('#flutter');
      expect(controller.tagsNotifier.value, contains('flutter'));

      controller.removeTag('flutter');
      expect(controller.tagsNotifier.value, isNot(contains('flutter')));
    });

    test('Boş başlık ve içerikle saveEntry başarısız olmalıdır', () async {
      final success = await controller.saveEntry();
      expect(success, isFalse);
      expect(controller.errorMessageNotifier.value, isNotNull);
    });
  });
}
