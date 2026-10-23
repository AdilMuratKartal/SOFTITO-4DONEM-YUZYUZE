import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/pomodoro_controller.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key});

  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> {
  late final PomodoroController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PomodoroController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Odaklanma & Pomodoro'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Mod Seçimi
              ValueListenableBuilder<PomodoroMode>(
                valueListenable: _controller.modeNotifier,
                builder: (context, mode, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Odaklan (25dk)'),
                        selected: mode == PomodoroMode.focus,
                        selectedColor: AppColors.pomodoroWork.withValues(alpha: 0.2),
                        onSelected: (_) => _controller.setMode(PomodoroMode.focus),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Kısa Mola (5dk)'),
                        selected: mode == PomodoroMode.shortBreak,
                        selectedColor: AppColors.pomodoroShortBreak.withValues(alpha: 0.2),
                        onSelected: (_) => _controller.setMode(PomodoroMode.shortBreak),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Uzun (15dk)'),
                        selected: mode == PomodoroMode.longBreak,
                        selectedColor: AppColors.pomodoroLongBreak.withValues(alpha: 0.2),
                        onSelected: (_) => _controller.setMode(PomodoroMode.longBreak),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Bağlı Alışkanlık
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_rounded, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Bağlı: 5 Sayfa Kitap Oku',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Dairesel Sayaç Kadranı
              ValueListenableBuilder<int>(
                valueListenable: _controller.remainingSecondsNotifier,
                builder: (context, seconds, _) {
                  return ValueListenableBuilder<PomodoroMode>(
                    valueListenable: _controller.modeNotifier,
                    builder: (context, mode, _) {
                      final total = mode == PomodoroMode.focus
                          ? 25 * 60
                          : (mode == PomodoroMode.shortBreak ? 5 * 60 : 15 * 60);
                      final progress = total > 0 ? (seconds / total) : 0.0;

                      final color = mode == PomodoroMode.focus
                          ? AppColors.pomodoroWork
                          : (mode == PomodoroMode.shortBreak
                              ? AppColors.pomodoroShortBreak
                              : AppColors.pomodoroLongBreak);

                      return Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 220,
                              height: 220,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 10,
                                backgroundColor: AppColors.borderLight,
                                valueColor: AlwaysStoppedAnimation<Color>(color),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTime(seconds),
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mode == PomodoroMode.focus
                                      ? 'ODAKLANMA'
                                      : (mode == PomodoroMode.shortBreak ? 'KISA MOLA' : 'UZUN MOLA'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),

              // Döngü Noktaları
              ValueListenableBuilder<int>(
                valueListenable: _controller.completedCyclesNotifier,
                builder: (context, cycles, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      final isDone = i < (cycles % 4);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone ? AppColors.secondary : AppColors.borderLight,
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 36),

              // Kontrol Butonları
              ValueListenableBuilder<bool>(
                valueListenable: _controller.isRunningNotifier,
                builder: (context, isRunning, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        iconSize: 26,
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: () => _controller.reset(),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 140,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRunning ? AppColors.secondary : AppColors.primary,
                          ),
                          icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white),
                          label: Text(
                            isRunning ? 'DURDUR' : 'BAŞLAT',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _controller.toggleStartPause(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton.filledTonal(
                        iconSize: 26,
                        icon: const Icon(Icons.skip_next_rounded),
                        onPressed: () => _controller.setMode(PomodoroMode.shortBreak),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
