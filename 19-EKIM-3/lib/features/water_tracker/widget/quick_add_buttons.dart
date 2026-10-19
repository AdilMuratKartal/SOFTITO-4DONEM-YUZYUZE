import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';

/// Hızlı Su Ekleme Butonları Bileşeni
class QuickAddButtons extends StatelessWidget {
  final WaterTrackerController controller;

  const QuickAddButtons({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAddButton(context, 200, 'Bardak'),
        const SizedBox(width: 8),
        _buildAddButton(context, 330, 'Kutu'),
        const SizedBox(width: 8),
        _buildAddButton(context, 500, 'Şişe'),
        const SizedBox(width: 8),
        _buildCustomButton(context),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context, int amount, String label) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: () => controller.addWater(amount, note: label),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.local_drink_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                '+$amount',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                'ml',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: () => _showCustomInputDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                'Özel',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                'Giriş',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomInputDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Özel Miktar Ekle'),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Örn: 400',
              suffixText: 'ml',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(textController.text);
                if (value != null && value > 0) {
                  controller.addWater(value, note: 'Özel Miktar');
                }
                Navigator.pop(ctx);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}
