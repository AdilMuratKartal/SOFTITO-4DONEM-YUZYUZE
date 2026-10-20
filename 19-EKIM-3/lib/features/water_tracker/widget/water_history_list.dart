import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';
import '../models/water_entry_model.dart';

/// Su Tüketim Geçmişi Listesi Bileşeni
class WaterHistoryList extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterHistoryList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme),
        const SizedBox(height: 10),
        _buildList(theme),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Bugünkü İçimler',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        ValueListenableBuilder<List<WaterEntryModel>>(
          valueListenable: controller.historyNotifier,
          builder: (context, history, _) {
            if (history.isEmpty) return const SizedBox.shrink();
            return TextButton(
              onPressed: () => controller.reset(),
              child: const Text('Temizle'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildList(ThemeData theme) {
    return ValueListenableBuilder<List<WaterEntryModel>>(
      valueListenable: controller.historyNotifier,
      builder: (context, history, _) {
        if (history.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(
                    Icons.opacity_outlined,
                    size: 36,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Henüz su kaydı bulunmuyor.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final entry = history[index];
            return _buildEntryCard(context, theme, entry);
          },
        );
      },
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    ThemeData theme,
    WaterEntryModel entry,
  ) {
    final timeStr =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.water_drop_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.amountMl} ml',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  entry.note ?? 'Hızlı Ekleme',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16),
            color: theme.colorScheme.error,
            onPressed: () => controller.removeEntry(entry.id),
          ),
        ],
      ),
    );
  }
}
