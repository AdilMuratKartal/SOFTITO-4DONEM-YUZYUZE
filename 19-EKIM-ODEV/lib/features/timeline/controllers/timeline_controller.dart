import 'package:flutter/foundation.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/services/storage_service.dart';
import '../../entry_editor/models/journal_entry_model.dart';
import '../models/timeline_filter_model.dart';

class TimelineController {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<List<JournalEntry>> filteredEntriesNotifier =
      ValueNotifier<List<JournalEntry>>([]);
  final ValueNotifier<TimelineFilterModel> filterNotifier =
      ValueNotifier<TimelineFilterModel>(const TimelineFilterModel());

  // Ay ve Gün Seçimi Durumları
  final ValueNotifier<int> selectedMonthNotifier =
      ValueNotifier<int>(DateTime.now().month);
  final ValueNotifier<int> selectedYearNotifier =
      ValueNotifier<int>(DateTime.now().year);
  final ValueNotifier<DateTime> selectedDayNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<String?> selectedMoodForCreationNotifier =
      ValueNotifier<String?>('😊');
  final ValueNotifier<bool> filterOnlySelectedDayNotifier =
      ValueNotifier<bool>(false);

  VoidCallback? _storageListener;

  TimelineController() {
    _storageListener = () {
      applyFilter();
    };
    StorageService.instance.entriesNotifier.addListener(_storageListener!);
    init();
  }

  Future<void> init() async {
    isLoadingNotifier.value = true;
    try {
      await StorageService.instance.init();
      applyFilter();
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  void selectMonth(int month) {
    selectedMonthNotifier.value = month;
    final currentDay = selectedDayNotifier.value;
    final maxDaysInMonth =
        DateTime(selectedYearNotifier.value, month + 1, 0).day;
    final newDayNumber =
        currentDay.day > maxDaysInMonth ? maxDaysInMonth : currentDay.day;

    selectedDayNotifier.value =
        DateTime(selectedYearNotifier.value, month, newDayNumber);
    applyFilter();
  }

  void selectDay(DateTime day) {
    selectedDayNotifier.value = day;
    if (day.month != selectedMonthNotifier.value) {
      selectedMonthNotifier.value = day.month;
      selectedYearNotifier.value = day.year;
    }
    applyFilter();
  }

  void selectCreationMood(String mood) {
    selectedMoodForCreationNotifier.value = mood;
  }

  void toggleDayFilter() {
    filterOnlySelectedDayNotifier.value =
        !filterOnlySelectedDayNotifier.value;
    applyFilter();
  }

  bool hasEntriesOnDate(DateTime date) {
    return StorageService.instance
        .getAllEntries()
        .any((e) => e.createdAt.isSameDay(date));
  }

  String? getMoodForDate(DateTime date) {
    final entries = StorageService.instance
        .getAllEntries()
        .where((e) => e.createdAt.isSameDay(date))
        .toList();
    if (entries.isNotEmpty && entries.first.mood != null) {
      return entries.first.mood;
    }
    return null;
  }

  void updateSearch(String query) {
    filterNotifier.value = filterNotifier.value.copyWith(searchQuery: query);
    applyFilter();
  }

  void setMoodFilter(String? mood) {
    filterNotifier.value = filterNotifier.value
        .copyWith(selectedMood: mood, clearMood: mood == null);
    applyFilter();
  }

  void setTagFilter(String? tag) {
    filterNotifier.value =
        filterNotifier.value.copyWith(selectedTag: tag, clearTag: tag == null);
    applyFilter();
  }

  void applyFilter() {
    final all = StorageService.instance.getAllEntries();
    final filter = filterNotifier.value;
    final selectedMonth = selectedMonthNotifier.value;
    final selectedYear = selectedYearNotifier.value;
    final selectedDay = selectedDayNotifier.value;
    final filterOnlyDay = filterOnlySelectedDayNotifier.value;

    final result = all.where((entry) {
      // 1. Ay filtresi
      if (entry.createdAt.year != selectedYear ||
          entry.createdAt.month != selectedMonth) {
        return false;
      }

      // 2. Gün filtresi (Aktif ise sadece o gün)
      if (filterOnlyDay && !entry.createdAt.isSameDay(selectedDay)) {
        return false;
      }

      // 3. Arama filtresi
      if (filter.searchQuery.isNotEmpty) {
        final q = filter.searchQuery.toLowerCase();
        final matchTitle = entry.title.toLowerCase().contains(q);
        final matchContent = entry.content.toLowerCase().contains(q);
        if (!matchTitle && !matchContent) return false;
      }

      // 4. Duygu filtresi
      if (filter.selectedMood != null && entry.mood != filter.selectedMood) {
        return false;
      }

      // 5. Etiket filtresi
      if (filter.selectedTag != null &&
          !entry.tags.contains(filter.selectedTag)) {
        return false;
      }

      return true;
    }).toList();

    filteredEntriesNotifier.value = result;
  }

  Future<void> deleteEntry(String id) async {
    await StorageService.instance.deleteEntry(id);
  }

  void dispose() {
    if (_storageListener != null) {
      StorageService.instance.entriesNotifier
          .removeListener(_storageListener!);
    }
    selectedMonthNotifier.dispose();
    selectedYearNotifier.dispose();
    selectedDayNotifier.dispose();
    selectedMoodForCreationNotifier.dispose();
    filterOnlySelectedDayNotifier.dispose();
    isLoadingNotifier.dispose();
    filteredEntriesNotifier.dispose();
    filterNotifier.dispose();
  }
}
