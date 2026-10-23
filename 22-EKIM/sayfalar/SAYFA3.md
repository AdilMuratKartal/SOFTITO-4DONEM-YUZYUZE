# Sayfa 3: Pomodoro & Odaklanma Sayacı Ekranı (sayfalar/SAYFA3.md)

## 1. Ekran Amacı ve Özeti

Kullanıcının süre gerektiren mikro-alışkanlıklarını (kitap okuma, müzik aleti egzersizi, meditasyon, ders/kodlama çalışma) disiplinli aralıklarla tamamlamasını sağlayan **Pomodoro Odaklanma Modülü**dür. 

Bu ekran yalnızca bağımsız bir kronometre değil; doğrudan **Sayfa 1'deki mikro-alışkanlıklarla entegre** çalışır. Oturum tamamlandığında bağlı alışkanlığın günlük ilerlemesi otomatik artırılır, kullanıcıya XP kazandırılır ve seri (streak) tetiklenir.

---

## 2. Arayüz Hiyerarşisi ve Bileşen Yerleşimi

```text
+-----------------------------------------------------------------------+
|  Odaklanma & Pomodoro                                   [ ⚙️ Ayarlar ]|
+-----------------------------------------------------------------------+
|  Mod Seçimi:                                                          |
|  [ (🔥) Odaklan (25dk) ]   [ (☕) Kısa Mola (5dk) ]  [ (🌴) Uzun (15dk) ]|
+-----------------------------------------------------------------------+
|  Bağlı Alışkanlık:                                                    |
|  [ 📖 Kitap Oku (5 Sayfa / 25 Dk)  ▼ ]  (Değiştir / Bağımsız Yap)    |
+-----------------------------------------------------------------------+
|                                                                       |
|                           ╭───────────────╮                           |
|                      ╭────╯               ╰────╮                      |
|                     │       ODAKLANMA          │                      |
|                    │          24:58             │                     |
|                     │       Döngü 2 / 4        │                      |
|                      ╰────╮               ╭────╯                      |
|                           ╰───────────────╯                           |
|                                                                       |
|  Döngü İlerlemesi:  ( ● )  ( ● )  ( ○ )  ( ○ )   ->  1 Uzun Mola      |
+-----------------------------------------------------------------------+
|  Kontroller:                                                          |
|        [ 🔄 Sıfırla ]       [ ▶ BAŞLAT ]       [ ⏭️ Pas Geç ]         |
+-----------------------------------------------------------------------+
|  Günün Odaklanma Özeti:                                               |
|  ⏱️ Toplam: 50 Dk  •  🎯 2 Oturum  •  ⚡ +60 XP Kazanıldı             |
+-----------------------------------------------------------------------+
```

### 2.1. Üst Mod Değiştirici (Mode Selector)
- **Odaklanma (Focus - 25 Dk):** `AppColors.pomodoroWork` vurgusu.
- **Kısa Mola (Short Break - 5 Dk):** `AppColors.pomodoroShortBreak` dinlendirici yeşil vurgusu.
- **Uzun Mola (Long Break - 15 Dk):** `AppColors.pomodoroLongBreak` açık mavi vurgusu.
- *Not:* Kullanıcı ayarlarından bu süreler isteğe göre özelleştirilebilir (örn: 50 dk / 10 dk).

### 2.2. Alışkanlık Bağlama Seçicisi (Habit Linker Dropdown/Chip)
- Kullanıcı dilerse sayacı bağımsız çalıştırabilir veya bugünkü süre bazlı bir mikro-alışkanlığına (Örn: "Gitar Pratiği") bağlayabilir.
- Sayaç sıfıra ulaştığında:
  1. Başarı sesi / titreşimi (`HapticFeedback.vibrate()`) çalar.
  2. Bağlı alışkanlık otomatik olarak "Bugün Tamamlandı" veya sayaçlı ise ilgili süre kadar güncellenir.
  3. Profil seviyesine `+30 XP` eklenir.

### 2.3. Dairesel Zamanlayıcı Kadranı (Circular Timer Dial)
- Dış çember: Gri sınır çizgisi (`AppColors.borderLight`).
- İç çember: Kalan zamana göre saat yönünde azalan dinamik renkli ilerleme yayı.
- Kadran içi: Büyük dijital sayaç metni (`38px bold monospaced`), aktif mod adı ve döngü sayısı.

### 2.4. Döngü Takip Göstergesi (Cycle Dots)
- Klasik 4 seanslık Pomodoro döngüsünü temsil eden 4 dairesel nokta.
- Her tamamlanan odak seansında bir nokta dolar. 4. seans bittiğinde sistem kullanıcıya otomatik olarak "Uzun Mola" önerir.

---

## 3. Durum Yönetimi (State Architecture)

Clean UI prensibine uygun olarak mantık ve zamanlayıcı akışı `ValueNotifier` tabanlı bir controller içinde yönetilir:

### 3.1. `PomodoroController` (`features/controllers/pomodoro_controller.dart`)

- `ValueNotifier<int> remainingSecondsNotifier`: Kalan saniyeyi tutar (Örn: 1500 sn).
- `ValueNotifier<bool> isRunningNotifier`: Sayacın aktif çalışıp çalışmadığını tutar.
- `ValueNotifier<PomodoroMode> activeModeNotifier`: `.focus`, `.shortBreak`, `.longBreak` modunu tutar.
- `ValueNotifier<int> completedCyclesNotifier`: Tamamlanan seans adedini tutar (0 - 4 arası).
- `ValueNotifier<String?> linkedHabitIdNotifier`: Sayacın bağlı olduğu alışkanlık ID'si.

**Metotlar:**
- `startTimer()`: `Timer.periodic(1 sec)` başlatır, her saniye `remainingSecondsNotifier.value--` yapar.
- `pauseTimer()`: Zamanlayıcıyı duraklatır.
- `resetTimer()`: Mevcut modun varsayılan süresine geri döndürür.
- `switchMode(PomodoroMode mode)`: Modu ve süreyi günceller.
- `skipSession()`: Mevcut oturumu tamamlanmış saymadan bir sonraki mola/odak adımına geçirir.
- `onTimerFinished()`: Oturum bittiğinde haptik titreşimi çalar, döngüyü artırır, bağlı alışkanlığa tamamlama sinyali gönderir.

---

## 4. Veri Modelleri

### 4.1. `PomodoroSessionModel` (`features/models/pomodoro_session_model.dart`)

```dart
enum PomodoroMode { focus, shortBreak, longBreak }

class PomodoroSessionModel {
  final String id;
  final String? linkedHabitId;
  final PomodoroMode mode;
  final int plannedMinutes;
  final int completedSeconds;
  final bool isSuccessfullyFinished;
  final DateTime completedAt;

  const PomodoroSessionModel({
    required this.id,
    this.linkedHabitId,
    required this.mode,
    required this.plannedMinutes,
    required this.completedSeconds,
    required this.isSuccessfullyFinished,
    required this.completedAt,
  });

  factory PomodoroSessionModel.fromJson(Map<String, dynamic> json) {
    return PomodoroSessionModel(
      id: json['id'],
      linkedHabitId: json['linkedHabitId'],
      mode: PomodoroMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => PomodoroMode.focus,
      ),
      plannedMinutes: json['plannedMinutes'] ?? 25,
      completedSeconds: json['completedSeconds'] ?? 0,
      isSuccessfullyFinished: json['isSuccessfullyFinished'] ?? false,
      completedAt: DateTime.parse(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'linkedHabitId': linkedHabitId,
      'mode': mode.name,
      'plannedMinutes': plannedMinutes,
      'completedSeconds': completedSeconds,
      'isSuccessfullyFinished': isSuccessfullyFinished,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
```

---

## 5. View Kod İskeleti (`features/views/pomodoro_view.dart`)

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../models/pomodoro_session_model.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key});

  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> {
  // Controller State Değerleri
  final ValueNotifier<int> _remainingSeconds = ValueNotifier<int>(25 * 60);
  final ValueNotifier<bool> _isRunning = ValueNotifier<bool>(false);
  final ValueNotifier<PomodoroMode> _activeMode = ValueNotifier<PomodoroMode>(PomodoroMode.focus);
  final ValueNotifier<int> _completedCycles = ValueNotifier<int>(0);

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _remainingSeconds.dispose();
    _isRunning.dispose();
    _activeMode.dispose();
    _completedCycles.dispose();
    super.dispose();
  }

  void _startTimer() {
    _isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
      } else {
        _onComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _isRunning.value = false;
  }

  void _resetTimer() {
    _pauseTimer();
    _setModeDuration(_activeMode.value);
  }

  void _setModeDuration(PomodoroMode mode) {
    _activeMode.value = mode;
    switch (mode) {
      case PomodoroMode.focus:
        _remainingSeconds.value = 25 * 60;
        break;
      case PomodoroMode.shortBreak:
        _remainingSeconds.value = 5 * 60;
        break;
      case PomodoroMode.longBreak:
        _remainingSeconds.value = 15 * 60;
        break;
    }
  }

  void _onComplete() {
    _pauseTimer();
    HapticFeedback.vibrate();

    if (_activeMode.value == PomodoroMode.focus) {
      _completedCycles.value = (_completedCycles.value + 1) % 4;
      // Otomatik mola önerisi
      if (_completedCycles.value == 0) {
        _setModeDuration(PomodoroMode.longBreak);
      } else {
        _setModeDuration(PomodoroMode.shortBreak);
      }
    } else {
      _setModeDuration(PomodoroMode.focus);
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Color _getCurrentColor(PomodoroMode mode) {
    switch (mode) {
      case PomodoroMode.focus:
        return AppColors.pomodoroWork;
      case PomodoroMode.shortBreak:
        return AppColors.pomodoroShortBreak;
      case PomodoroMode.longBreak:
        return AppColors.pomodoroLongBreak;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Odaklanma Sayacı'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              _buildModeSelector(),
              const SizedBox(height: 20),
              _buildLinkedHabitBanner(),
              const Spacer(),
              _buildDialTimer(),
              const SizedBox(height: 24),
              _buildCycleDots(),
              const Spacer(),
              _buildActionControls(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return ValueListenableBuilder<PomodoroMode>(
      valueListenable: _activeMode,
      builder: (context, activeMode, _) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              _buildModeOption('Odaklan', PomodoroMode.focus, activeMode),
              _buildModeOption('Kısa Mola', PomodoroMode.shortBreak, activeMode),
              _buildModeOption('Uzun Mola', PomodoroMode.longBreak, activeMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeOption(String label, PomodoroMode mode, PomodoroMode activeMode) {
    final isSelected = mode == activeMode;
    final color = _getCurrentColor(mode);

    return Expanded(
      child: GestureDetector(
        onTap: () => _setModeDuration(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLinkedHabitBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Row(
            children: [
              Icon(Icons.link_rounded, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Bağlı: 5 Sayfa Kitap Oku',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildDialTimer() {
    return ValueListenableBuilder<PomodoroMode>(
      valueListenable: _activeMode,
      builder: (context, mode, _) {
        final currentColor = _getCurrentColor(mode);

        return ValueListenableBuilder<int>(
          valueListenable: _remainingSeconds,
          builder: (context, seconds, _) {
            return Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).cardTheme.color,
                  border: Border.all(color: currentColor.withOpacity(0.3), width: 8),
                  boxShadow: [
                    BoxShadow(
                      color: currentColor.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mode == PomodoroMode.focus ? 'ODAKLANMA' : 'MOLA ZAMANI',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        color: currentColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(seconds),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCycleDots() {
    return ValueListenableBuilder<int>(
      valueListenable: _completedCycles,
      builder: (context, cycles, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isFilled = index < cycles;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? AppColors.pomodoroWork : AppColors.borderLight,
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildActionControls() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isRunning,
      builder: (context, running, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
              tooltip: 'Sıfırla',
              onPressed: _resetTimer,
            ),
            GestureDetector(
              onTap: running ? _pauseTimer : _startTimer,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: running ? AppColors.secondary : AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: (running ? AppColors.secondary : AppColors.primary).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 38,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.skip_next_rounded, color: AppColors.textSecondary),
              tooltip: 'Oturumu Geç',
              onPressed: _onComplete,
            ),
          ],
        );
      },
    );
  }
}
```