import 'package:flutter/material.dart';
import '../controller/water_reminder_controller.dart';

/// Su Hatırlatıcı Zamanlayıcı Kartı Bileşeni
class WaterReminderTimer extends StatelessWidget {
  final WaterReminderController reminderController;

  const WaterReminderTimer({
    super.key,
    required this.reminderController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = theme.cardTheme.color ?? theme.colorScheme.surface;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 14),
          _buildTimerDisplay(context, theme),
          const SizedBox(height: 14),
          _buildControls(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              color: theme.colorScheme.tertiary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Su Hatırlatıcı Zamanlayıcı',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: reminderController.isRunningNotifier,
          builder: (context, isRunning, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (isRunning ? theme.colorScheme.secondary : Colors.grey)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isRunning ? 'Aktif' : 'Durduruldu',
                style: TextStyle(
                  color: isRunning ? theme.colorScheme.secondary : Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimerDisplay(BuildContext context, ThemeData theme) {
    return ValueListenableBuilder<int>(
      valueListenable: reminderController.remainingSecondsNotifier,
      builder: (context, seconds, _) {
        final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
        final remainingSec = (seconds % 60).toString().padLeft(2, '0');

        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '$minutes:$remainingSec',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        _buildDurationPickerButton(context, theme),
        const SizedBox(width: 10),
        Expanded(child: _buildStartPauseButton(context, theme)),
        const SizedBox(width: 10),
        IconButton.outlined(
          icon: const Icon(Icons.refresh_rounded, size: 20),
          onPressed: () => reminderController.resetTimer(),
          tooltip: 'Sıfırla',
        ),
      ],
    );
  }

  Widget _buildDurationPickerButton(BuildContext context, ThemeData theme) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      icon: const Icon(Icons.edit_calendar_rounded, size: 16),
      label: const Text('Süre'),
      onPressed: () => _showDurationSelector(context),
    );
  }

  Widget _buildStartPauseButton(BuildContext context, ThemeData theme) {
    return ValueListenableBuilder<bool>(
      valueListenable: reminderController.isRunningNotifier,
      builder: (ctx, isRunning, _) {
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isRunning
                ? theme.colorScheme.error
                : theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          icon: Icon(
            isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 20,
          ),
          label: Text(isRunning ? 'Durdur' : 'Başlat'),
          onPressed: () {
            if (isRunning) {
              reminderController.pauseTimer();
            } else {
              reminderController.startTimer(
                onFinished: () => _showAlarmDialog(context),
              );
            }
          },
        );
      },
    );
  }

  void _showDurationSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hatırlatıcı Süresini Belirleyin',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _presetChip(ctx, '10 Saniye (Test)', 10),
                    _presetChip(ctx, '15 Dakika', 15 * 60),
                    _presetChip(ctx, '30 Dakika', 30 * 60),
                    _presetChip(ctx, '45 Dakika', 45 * 60),
                    _presetChip(ctx, '60 Dakika', 60 * 60),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _presetChip(BuildContext context, String label, int seconds) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        reminderController.setDuration(seconds);
        Navigator.pop(context);
      },
    );
  }

  void _showAlarmDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          icon: const Icon(
            Icons.notifications_active_rounded,
            color: Color(0xFF00F0FF),
            size: 48,
          ),
          title: const Text(
            '💧 Su İçme Vakti!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Belirlediğiniz süre doldu. Vücudunuzun hidrasyonunu korumak için lütfen bir bardak su için!',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                reminderController.acknowledgeCompletion();
                Navigator.pop(ctx);
              },
              child: const Text('Tamam, İçtim!'),
            ),
          ],
        );
      },
    );
  }
}
