import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Temaya duyarlı Duygu Durumu Seçici bileşeni.
class MoodPickerWidget extends StatelessWidget {
  final ValueListenable<String?> selectedMoodNotifier;
  final ValueChanged<String?> onMoodSelected;

  static const List<String> availableMoods = [
    '😊',
    '✨',
    '☕',
    '🔥',
    '🌧️',
    '🌙',
    '🌿',
    '💡'
  ];

  const MoodPickerWidget({
    super.key,
    required this.selectedMoodNotifier,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.cardShadow,
      ),
      child: ValueListenableBuilder<String?>(
        valueListenable: selectedMoodNotifier,
        builder: (context, currentMood, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableMoods.map((mood) {
                final isSelected = currentMood == mood;
                return GestureDetector(
                  onTap: () => onMoodSelected(isSelected ? null : mood),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.primary.withValues(alpha: 0.18)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? context.colors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      mood,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
