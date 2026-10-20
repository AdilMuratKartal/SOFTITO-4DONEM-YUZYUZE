import 'package:flutter/foundation.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/services/storage_service.dart';
import '../../entry_editor/models/journal_entry_model.dart';

class CalendarController {
  final ValueNotifier<DateTime> focusedDateNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<DateTime> selectedDateNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<List<JournalEntry>> entriesForSelectedDateNotifier =
      ValueNotifier<List<JournalEntry>>([]);

  VoidCallback? _storageListener;

  CalendarController() {
    _storageListener = () => updateEntriesForSelectedDate();
    StorageService.instance.entriesNotifier.addListener(_storageListener!);
    updateEntriesForSelectedDate();
  }

  void selectDate(DateTime date) {
    selectedDateNotifier.value = date;
    updateEntriesForSelectedDate();
  }

  void changeMonth(int offset) {
    final current = focusedDateNotifier.value;
    focusedDateNotifier.value =
        DateTime(current.year, current.month + offset, 1);
  }

  void updateEntriesForSelectedDate() {
    final selected = selectedDateNotifier.value;
    final all = StorageService.instance.getAllEntries();

    entriesForSelectedDateNotifier.value =
        all.where((entry) => entry.createdAt.isSameDay(selected)).toList();
  }

  bool hasEntriesOnDay(DateTime day) {
    return StorageService.instance
        .getAllEntries()
        .any((e) => e.createdAt.isSameDay(day));
  }

  String? getMoodForDay(DateTime day) {
    final entries = StorageService.instance
        .getAllEntries()
        .where((e) => e.createdAt.isSameDay(day))
        .toList();
    if (entries.isNotEmpty && entries.first.mood != null) {
      return entries.first.mood;
    }
    return null;
  }

  int getEntryCountForDay(DateTime day) {
    return StorageService.instance
        .getAllEntries()
        .where((e) => e.createdAt.isSameDay(day))
        .length;
  }

  void dispose() {
    if (_storageListener != null) {
      StorageService.instance.entriesNotifier
          .removeListener(_storageListener!);
    }
    focusedDateNotifier.dispose();
    selectedDateNotifier.dispose();
    entriesForSelectedDateNotifier.dispose();
  }
}
