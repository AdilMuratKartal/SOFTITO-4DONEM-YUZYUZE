import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';

/// Seçilen ayın günlerini yatay listeleyen ve etkinlik durumunu gösteren çubuk.
class HorizontalDayStripWidget extends StatelessWidget {
  final int year;
  final int month;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final bool Function(DateTime) hasEntriesOnDate;
  final String? Function(DateTime) getMoodForDate;

  const HorizontalDayStripWidget({
    super.key,
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.onDaySelected,
    required this.hasEntriesOnDate,
    required this.getMoodForDate,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;
    final totalDays = DateTime(year, month + 1, 0).day;
    final dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: totalDays,
        itemBuilder: (context, index) {
          final dayNumber = index + 1;
          final date = DateTime(year, month, dayNumber);
          final isSelected = date.isSameDay(selectedDay);
          final hasEntries = hasEntriesOnDate(date);
          final mood = getMoodForDate(date);
          final weekdayName = dayNames[date.weekday - 1];

          return GestureDetector(
            onTap: () => onDaySelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 52,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? context.colors.primary : context.colors.surface,
                borderRadius: BorderRadius.circular(style.borderRadius / 1.5),
                border: Border.all(
                  color: isSelected
                      ? context.colors.primary
                      : style.borderColor.withValues(alpha: 0.35),
                  width: isSelected ? style.borderWidth : 1.0,
                ),
                boxShadow: isSelected ? style.cardShadow : const [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekdayName,
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? context.colors.onPrimary.withValues(alpha: 0.8)
                          : context.colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? context.colors.onPrimary
                          : context.colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (mood != null)
                    Text(mood, style: const TextStyle(fontSize: 12.0))
                  else if (hasEntries)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? context.colors.onPrimary
                            : context.colors.secondary,
                      ),
                    )
                  else
                    const SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
