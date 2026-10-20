import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';

/// Seçili gün için hızlı mod seçimi ve günlük oluşturma kartı.
class QuickDayActionWidget extends StatelessWidget {
  final DateTime selectedDay;
  final String? selectedCreationMood;
  final ValueChanged<String> onMoodSelected;
  final VoidCallback onCreateEntry;
  final bool filterOnlyDay;
  final VoidCallback onToggleDayFilter;

  static const List<String> moods = ['😊', '✨', '☕', '🔥', '🌧️', '🌙'];

  const QuickDayActionWidget({
    super.key,
    required this.selectedDay,
    required this.selectedCreationMood,
    required this.onMoodSelected,
    required this.onCreateEntry,
    required this.filterOnlyDay,
    required this.onToggleDayFilter,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, size: 20, color: context.colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedDay.toJournalDate(),
                  style: style.headerFont.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: onToggleDayFilter,
                borderRadius: BorderRadius.circular(style.borderRadius / 2),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        filterOnlyDay
                            ? Icons.filter_alt
                            : Icons.filter_alt_outlined,
                        size: 16,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        filterOnlyDay ? 'Yalnızca Bu Gün' : 'Tüm Ay',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: moods.map((m) {
                      final isChosen = selectedCreationMood == m;
                      return GestureDetector(
                        onTap: () => onMoodSelected(m),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isChosen
                                ? context.colors.primary.withValues(alpha: 0.18)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isChosen
                                  ? context.colors.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Text(m, style: const TextStyle(fontSize: 20.0)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: onCreateEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(style.borderRadius / 2),
                    side: BorderSide(
                      color: style.borderColor,
                      width: style.borderWidth,
                    ),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text(
                  'Günlük Yaz',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
