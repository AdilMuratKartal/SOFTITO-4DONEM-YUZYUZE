import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DailyCalendarStrip extends StatelessWidget {
  final ValueNotifier<DateTime> selectedDateNotifier;
  final ValueChanged<DateTime> onDateSelected;

  const DailyCalendarStrip({
    super.key,
    required this.selectedDateNotifier,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Haftanın başlangıcı (Pazartesi)
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekDays = List.generate(7, (i) => monday.add(Duration(days: i)));

    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDateNotifier,
      builder: (context, selectedDate, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDays.map((date) {
            final isSelected = date.year == selectedDate.year &&
                date.month == selectedDate.month &&
                date.day == selectedDate.day;
            final isToday = date.year == now.year &&
                date.month == now.month &&
                date.day == now.day;

            const trDays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
            final dayName = trDays[date.weekday - 1];

            return GestureDetector(
              onTap: () => onDateSelected(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isToday
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isToday
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : AppColors.borderLight),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      dayName.length > 3 ? dayName.substring(0, 3) : dayName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isToday ? AppColors.primary : AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
