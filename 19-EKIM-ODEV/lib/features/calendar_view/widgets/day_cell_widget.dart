import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Takvim gün hücresi bileşeni (ThemeExtension stillerine ve etkinlik duygu emojisine duyarlı).
class DayCellWidget extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isCurrentMonth;
  final bool hasEntries;
  final String? mood;
  final VoidCallback onTap;

  const DayCellWidget({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isCurrentMonth,
    required this.hasEntries,
    this.mood,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary
              : (isCurrentMonth ? context.colors.surface : Colors.transparent),
          borderRadius: BorderRadius.circular(style.borderRadius / 2),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : (isCurrentMonth
                    ? style.borderColor.withValues(alpha: 0.3)
                    : Colors.transparent),
            width: isSelected ? style.borderWidth : 1.0,
          ),
          boxShadow: isSelected ? style.cardShadow : const [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13.0,
                color: isSelected
                    ? context.colors.onPrimary
                    : (isCurrentMonth
                        ? context.colors.onSurface
                        : context.colors.onSurface.withValues(alpha: 0.3)),
              ),
            ),
            if (mood != null)
              Text(
                mood!,
                style: const TextStyle(fontSize: 10.0),
              )
            else if (hasEntries)
              Container(
                margin: const EdgeInsets.only(top: 2),
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
  }
}
