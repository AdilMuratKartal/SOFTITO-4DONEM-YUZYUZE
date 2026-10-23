import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/pomodoro_controller.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      _buildModeChip('Odaklan (25dk)', mode == PomodoroMode.focus, AppColors.primary, () => _controller.setMode(PomodoroMode.focus), isDark),
                      const SizedBox(width: 8),
                      _buildModeChip('Kısa Mola (5dk)', mode == PomodoroMode.shortBreak, AppColors.moodGood, () => _controller.setMode(PomodoroMode.shortBreak), isDark),
                      const SizedBox(width: 8),
                      _buildModeChip('Uzun (15dk)', mode == PomodoroMode.longBreak, AppColors.tertiary, () => _controller.setMode(PomodoroMode.longBreak), isDark),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Bağlı Alışkanlık Kartı
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Bağlı: 5 Sayfa Kitap Oku',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.onSurface : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Dairesel Sayaç Kadranı (Display Timer)
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
                          ? AppColors.primary
                          : (mode == PomodoroMode.shortBreak
                              ? AppColors.moodGood
                              : AppColors.tertiary);

                      return Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 230,
                              height: 230,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 10,
                                backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
                                valueColor: AlwaysStoppedAnimation<Color>(color),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTime(seconds),
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.02,
                                    color: isDark ? AppColors.onSurface : AppColors.textLight,
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
                          color: isDone
                              ? AppColors.secondary
                              : (isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight),
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
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? AppColors.surfaceContainerHigh : null,
                          foregroundColor: isDark ? AppColors.onSurface : null,
                        ),
                        iconSize: 26,
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: () => _controller.reset(),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRunning ? AppColors.secondary : AppColors.primary,
                          foregroundColor: isRunning ? AppColors.onSecondary : AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          if (isRunning) {
                            _controller.pause();
                          } else {
                            _controller.start();
                          }
                        },
                        child: Row(
                          children: [
                            Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 26),
                            const SizedBox(width: 8),
                            Text(
                              isRunning ? 'DURAKLAT' : 'BAŞLAT',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
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

  Widget _buildModeChip(String label, bool isSelected, Color activeColor, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark ? AppColors.surfaceContainer : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppColors.onPrimary
                : (isDark ? AppColors.onSurface : AppColors.textLight),
          ),
        ),
      ),
    );
  }
}
