import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../entry_editor/models/journal_entry_model.dart';
import '../../entry_editor/view/entry_editor_view.dart';
import '../../timeline/widgets/entry_card_widget.dart';
import '../controllers/calendar_controller.dart';
import '../widgets/day_cell_widget.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
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
        title: Text(AppStrings.calendarTitle, style: style.headerFont),
      ),
      floatingActionButton: _buildCalendarFab(style),
      body: Column(
        children: [
          _buildMonthHeader(),
          _buildWeekDays(),
          _buildCalendarGrid(),
          const Divider(height: 16),
          _buildSelectedDayHeader(style),
          Expanded(child: _buildEntriesListForDay()),
        ],
      ),
    );
  }

  Widget _buildCalendarFab(dynamic style) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EntryEditorView(
              targetDate: _controller.selectedDateNotifier.value,
            ),
          ),
        );
      },
      backgroundColor: context.colors.primary,
      foregroundColor: context.colors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.borderRadius),
        side: BorderSide(color: style.borderColor, width: style.borderWidth),
      ),
      icon: const Icon(Icons.add),
      label: const Text('Bu Güne Yaz'),
    );
  }

  Widget _buildMonthHeader() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.focusedDateNotifier,
      builder: (context, date, _) {
        final months = [
          'Ocak',
          'Şubat',
          'Mart',
          'Nisan',
          'Mayıs',
          'Haziran',
          'Temmuz',
          'Ağustos',
          'Eylül',
          'Ekim',
          'Kasım',
          'Aralık'
        ];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _controller.changeMonth(-1),
              ),
              Text(
                '${months[date.month - 1]} ${date.year}',
                style: context.journalStyle.headerFont.copyWith(fontSize: 18.0),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _controller.changeMonth(1),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeekDays() {
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((d) {
          return SizedBox(
            width: 40,
            child: Text(
              d,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: context.colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.focusedDateNotifier,
      builder: (context, focused, _) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: _controller.selectedDateNotifier,
          builder: (context, selected, _) {
            final firstDayOfMonth = DateTime(focused.year, focused.month, 1);
            final startingWeekday = firstDayOfMonth.weekday; // 1: Pzt, 7: Paz
            final daysInMonth =
                DateTime(focused.year, focused.month + 1, 0).day;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.1,
              ),
              itemCount: 35, // 5 hafta görünümü
              itemBuilder: (context, index) {
                final dayNumber = index - (startingWeekday - 1) + 1;
                final isCurrentMonth = dayNumber >= 1 && dayNumber <= daysInMonth;

                final cellDate = isCurrentMonth
                    ? DateTime(focused.year, focused.month, dayNumber)
                    : (dayNumber < 1
                        ? DateTime(focused.year, focused.month, dayNumber)
                        : DateTime(
                            focused.year, focused.month + 1, dayNumber - daysInMonth));

                final isSelected = cellDate.isSameDay(selected);
                final hasEntries = _controller.hasEntriesOnDay(cellDate);
                final mood = _controller.getMoodForDay(cellDate);

                return DayCellWidget(
                  date: cellDate,
                  isSelected: isSelected,
                  isCurrentMonth: isCurrentMonth,
                  hasEntries: hasEntries,
                  mood: mood,
                  onTap: () => _controller.selectDate(cellDate),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedDayHeader(dynamic style) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.selectedDateNotifier,
      builder: (context, selected, _) {
        final count = _controller.getEntryCountForDay(selected);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selected.toJournalDate(),
                style: style.headerFont.copyWith(fontSize: 14.0),
              ),
              Text(
                count > 0 ? '$count Etkinlik / Günlük' : 'Kayıt Yok',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEntriesListForDay() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.selectedDateNotifier,
      builder: (context, selected, _) {
        return ValueListenableBuilder<List<JournalEntry>>(
          valueListenable: _controller.entriesForSelectedDateNotifier,
          builder: (context, entries, _) {
            if (entries.isEmpty) {
              return Center(
                child: Text(
                  'Bu tarihte kayıtlı etkinlik bulunmuyor.\n"Bu Güne Yaz" butonuyla ekleyebilirsiniz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return EntryCardWidget(
                  entry: entry,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EntryEditorView(initialEntry: entry),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
