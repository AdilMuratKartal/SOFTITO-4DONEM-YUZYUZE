import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../entry_editor/models/journal_entry_model.dart';
import '../../entry_editor/view/entry_editor_view.dart';
import '../controllers/timeline_controller.dart';
import '../models/timeline_filter_model.dart';
import '../widgets/entry_card_widget.dart';
import '../widgets/horizontal_day_strip_widget.dart';
import '../widgets/month_selector_bar_widget.dart';
import '../widgets/quick_day_action_widget.dart';
import '../widgets/search_bar_widget.dart';

/// Günlük Akışı Ekranı (Timeline View) - Ay ve Gün Seçimi, Hızlı Mod ve Günlük Oluşturma.
class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late final TimelineController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimelineController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.timelineTitle, style: style.headerFont),
      ),
      floatingActionButton: _buildFab(style),
      body: Column(
        children: [
          _buildMonthSelector(),
          _buildDayStrip(),
          _buildQuickActionCard(),
          _buildSearchBar(),
          Expanded(child: _buildEntriesList()),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return ValueListenableBuilder<int>(
      valueListenable: _controller.selectedMonthNotifier,
      builder: (context, selectedMonth, _) {
        return MonthSelectorBarWidget(
          selectedMonth: selectedMonth,
          onMonthSelected: _controller.selectMonth,
        );
      },
    );
  }

  Widget _buildDayStrip() {
    return ValueListenableBuilder<int>(
      valueListenable: _controller.selectedMonthNotifier,
      builder: (context, month, _) {
        return ValueListenableBuilder<int>(
          valueListenable: _controller.selectedYearNotifier,
          builder: (context, year, _) {
            return ValueListenableBuilder<DateTime>(
              valueListenable: _controller.selectedDayNotifier,
              builder: (context, selectedDay, _) {
                return HorizontalDayStripWidget(
                  year: year,
                  month: month,
                  selectedDay: selectedDay,
                  onDaySelected: _controller.selectDay,
                  hasEntriesOnDate: _controller.hasEntriesOnDate,
                  getMoodForDate: _controller.getMoodForDate,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQuickActionCard() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.selectedDayNotifier,
      builder: (context, selectedDay, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: _controller.selectedMoodForCreationNotifier,
          builder: (context, creationMood, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: _controller.filterOnlySelectedDayNotifier,
              builder: (context, filterOnlyDay, _) {
                return QuickDayActionWidget(
                  selectedDay: selectedDay,
                  selectedCreationMood: creationMood,
                  onMoodSelected: _controller.selectCreationMood,
                  filterOnlyDay: filterOnlyDay,
                  onToggleDayFilter: _controller.toggleDayFilter,
                  onCreateEntry: () {
                    _navigateToEditor(
                      null,
                      targetDate: selectedDay,
                      initialMood: creationMood,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return ValueListenableBuilder<TimelineFilterModel>(
      valueListenable: _controller.filterNotifier,
      builder: (context, filter, _) {
        return SearchBarWidget(
          onSearchChanged: _controller.updateSearch,
          selectedMood: filter.selectedMood,
          onMoodSelected: _controller.setMoodFilter,
        );
      },
    );
  }

  Widget _buildEntriesList() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isLoadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<List<JournalEntry>>(
          valueListenable: _controller.filteredEntriesNotifier,
          builder: (context, entries, _) {
            if (entries.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return EntryCardWidget(
                  entry: entry,
                  onTap: () => _navigateToEditor(entry),
                  onDelete: () => _controller.deleteEntry(entry.id),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFab(dynamic style) {
    return FloatingActionButton(
      onPressed: () => _navigateToEditor(
        null,
        targetDate: _controller.selectedDayNotifier.value,
        initialMood: _controller.selectedMoodForCreationNotifier.value,
      ),
      backgroundColor: context.colors.primary,
      foregroundColor: context.colors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.borderRadius),
        side: BorderSide(color: style.borderColor, width: style.borderWidth),
      ),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 64,
            color: context.colors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noEntriesFound,
            style: context.journalStyle.headerFont.copyWith(
              fontSize: 16.0,
              color: context.colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seçilen güne/aya ait günlük bulunamadı.\nYukarıdaki "Günlük Yaz" butonuna dokunarak ekleyin!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.0,
              color: context.colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditor(
    JournalEntry? entry, {
    DateTime? targetDate,
    String? initialMood,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EntryEditorView(
          initialEntry: entry,
          targetDate: targetDate,
          initialMood: initialMood,
        ),
      ),
    );
  }
}
