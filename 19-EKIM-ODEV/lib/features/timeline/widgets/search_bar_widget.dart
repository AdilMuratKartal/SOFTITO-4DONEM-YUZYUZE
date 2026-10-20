import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';

/// Temaya duyarlı arama çubuğu ve duygu filtresi çubuğu.
class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final String? selectedMood;
  final ValueChanged<String?> onMoodSelected;

  static const List<String> moods = ['😊', '✨', '☕', '🔥', '🌧️', '🌙'];

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(style.borderRadius),
              border: Border.all(
                color: style.borderColor.withValues(alpha: 0.5),
                width: 1.0,
              ),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: Icon(Icons.search, color: context.colors.primary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text(AppStrings.allMoods),
                  selected: selectedMood == null,
                  onSelected: (_) => onMoodSelected(null),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(style.borderRadius / 2),
                  ),
                ),
                const SizedBox(width: 6),
                ...moods.map((m) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(m),
                      selected: selectedMood == m,
                      onSelected: (selected) =>
                          onMoodSelected(selected ? m : null),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(style.borderRadius / 2),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
