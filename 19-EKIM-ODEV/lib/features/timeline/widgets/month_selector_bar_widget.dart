import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Temaya duyarlı 12 Ay Seçici Yatay Çubuk bileşeni.
class MonthSelectorBarWidget extends StatelessWidget {
  final int selectedMonth;
  final ValueChanged<int> onMonthSelected;

  static const List<String> monthNames = [
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
    'Aralık',
  ];

  const MonthSelectorBarWidget({
    super.key,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 12,
        itemBuilder: (context, index) {
          final monthIndex = index + 1;
          final isSelected = selectedMonth == monthIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(monthNames[index]),
              selected: isSelected,
              onSelected: (_) => onMonthSelected(monthIndex),
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13.0,
                color: isSelected
                    ? context.colors.onPrimary
                    : context.colors.onSurface,
              ),
              selectedColor: context.colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(style.borderRadius / 2),
                side: BorderSide(
                  color: isSelected
                      ? context.colors.primary
                      : style.borderColor.withValues(alpha: 0.3),
                  width: isSelected ? style.borderWidth : 1.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
