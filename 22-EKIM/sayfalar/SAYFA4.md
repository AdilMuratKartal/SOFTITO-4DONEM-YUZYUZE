# Sayfa 4: Grafik, Analiz ve İstatistik Ekranı (sayfalar/SAYFA4.md)

## 1. Ekran Amacı ve Özeti

Kullanıcının geçmiş mikro-alışkanlık performansını görselleştiren, motivasyonunu artıran ve davranışsal içgörüler sunan **Analiz ve İstatistik Modülü**dür. 

Bu ekran; haftalık/aylık alışkanlık tamamlama oranlarını (`fl_chart` Bar & Line grafikleri), GitHub katkı grafiği tarzındaki **Katkı Isı Haritası (Heatmap)** yapısını, kategori bazlı dağılımları ve en önemlisi **Duygu Durumu (Mood) ile Alışkanlıklar Arasındaki Korelasyonu** analiz ederek kullanıcıya kişiselleştirilmiş geri bildirimler sunar.

---

## 2. Arayüz Hiyerarşisi ve Bileşen Yerleşimi

```text
+-----------------------------------------------------------------------+
|  İstatistikler & Analiz                                  [ 📤 Paylaş ] |
+-----------------------------------------------------------------------+
|  Zaman Aralığı:    [ (✓) Bu Hafta ]    [ Bu Ay ]    [ Son 90 Gün ]   |
+-----------------------------------------------------------------------+
|  ÖZET KARTLARI (3'lü Mini Metrik Paneli):                             |
|  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐         |
|  │  %84 Başarı  │      │  🔥 18 Gün   │      │ ⏱️ 6.5 Saat  │         |
|  │  Tamamlama   │      │  En İyi Seri │      │  Odaklanma   │         |
|  └──────────────┘      └──────────────┘      └──────────────┘         |
+-----------------------------------------------------------------------+
|  HAFTALIK TAMAMLANMA ORANI (fl_chart Bar Chart):                      |
|   100% ┤     █           █                                            |
|    75% ┤  █  █     █     █     █                                      |
|    50% ┤  █  █  █  █     █  █  █                                      |
|     0% └──┴──┴──┴──┴──┴──┴──┴──┴──                                    |
|          Pzt Sal Çar Per Cum Cmt Paz  -> Ort: %78 Başarı              |
+-----------------------------------------------------------------------+
|  GİTHUB TARZI KATKI ISI HARİTASI (Habit Heatmap Grid):                |
|  Ekim 2026                                                            |
|  Pzt [ ][ ][■][■][ ][■][■]                                            |
|  Çar [ ][■][■][■][■][■][■]    Açık: 0-1 Görev  •  Koyu: 5+ Görev      |
|  Cum [■][■][■][ ][■][■][■]                                            |
+-----------------------------------------------------------------------+
|  MOOD & ALIŞKANLIK KORELASYONU (İçgörü Kutusu):                       |
|  ┌─────────────────────────────────────────────────────────────────┐  |
|  │ 💡 Önemli İçgörü:                                               │  |
|  │ "Günde 5 sayfa kitap okuduğun ve spor yaptığın günlerde         │  |
|  │  modun %73 oranında 'Harika 🤩' veya 'İyi 🙂' kaydedildi."      │  |
|  └─────────────────────────────────────────────────────────────────┘  |
+-----------------------------------------------------------------------+
|  KATEGORİ DAĞILIMI (Donut Chart & Yüzdeler):                          |
|  ◎ Spor: %35   ◎ Sağlık: %30   ◎ Zihin: %20   ◎ Müzik: %15            |
+-----------------------------------------------------------------------+
```

### 2.1. Zaman Aralığı Seçici (Timeframe Segmented Bar)
- `[ Bu Hafta, Bu Ay, Son 90 Gün ]` butonları.
- Seçilen periyoda göre aşağıdaki tüm grafik verileri, ortalama başarı ve odaklanma süreleri anında filtrelenir.

### 2.2. Performans Özet Kartları (Metric Cards)
- **Başarı Oranı:** Seçilen aralıkta hedeflenen toplam mikro-görevlerin tamamlanma yüzdesi.
- **En Uzun Seri (Best Streak):** Zinciri kırmadan devam edilen gün rekoru.
- **Toplam Odaklanma (Pomodoro):** Sayfa 3'teki sayaçtan biriken toplam odaklanma süresi.

### 2.3. Haftalık / Aylık Bar Grafiği (`fl_chart`)
- Dikey çubuklar (`BarChartGroupData`): Her gün için tamamlanan oran.
- Hedef çizgi (`HorizontalLine`): %80 başarı hedef çizgisi (kesikli çizgi).
- Çubuğa dokunulduğunda o günün tamamlanan alışkanlık detayını gösteren tooltip (`BarTouchTooltipData`).

### 2.4. Katkı Isı Haritası (Habit Heatmap Calendar)
- 7 satır (Haftanın günleri) ve geriye dönük sütunlardan oluşan kutucuk ızgarası.
- Renk yoğunluğu tamamlanan mikro-alışkanlık sayısına göre 4 seviyede koyulaşır:
  - `Seviye 0 (0 alışkanlık):` `AppColors.borderLight` (Karanlık modda `borderDark`)
  - `Seviye 1 (1-2 alışkanlık):` `AppColors.primary.withOpacity(0.3)`
  - `Seviye 2 (3-4 alışkanlık):` `AppColors.primary.withOpacity(0.65)`
  - `Seviye 3 (5+ alışkanlık):` `AppColors.primary` (Tam zümrüt yeşili)

### 2.5. Mood & Alışkanlık Korelasyon Analizi
- Sayfa 1'de girilen günlük modlar ile tamamlanan alışkanlıkları eşleştirir.
- Kullanıcının hangi alışkanlığı yaptığında ruh halinin daha yüksek olduğunu istatistiki olarak özetleyen dinamik metin kutusudur.

### 2.6. Kategori Dağılım Grafiği (Donut Chart - `PieChart`)
- 4 Temel Kategori (**Spor**, **Sağlık**, **Zihin**, **Müzik**) ve kullanıcının eklediği özel kategorilerin tamamlanma oranlarını dairesel pasta/halka grafikte (`fl_chart` `PieChart`) gösterir.
- Dilimlere dokunulduğunda (`PieTouchData`) ilgili kategorideki toplam tamamlanan mikro-alışkanlık sayısı vurgulanır.

---

## 3. Durum Yönetimi (State Architecture)

### 3.1. `AnalyticsController` (`features/controllers/analytics_controller.dart`)
- `ValueNotifier<TimeframeType> selectedTimeframeNotifier`: Aktif zaman aralığını tutar (`.week`, `.month`, `.quarter`).
- `ValueNotifier<AnalyticsSummaryModel?> summaryNotifier`: Hesaplanan başarı, seri ve odak özetini tutar.
- `ValueNotifier<List<DailyAnalyticsRecordModel>> dailyRecordsNotifier`: Günlük tamamlama ve mod kayıtlarını tutar.
- `ValueNotifier<bool> isLoadingNotifier`: Grafik hesaplaması sırasındaki yükleme durumunu kontrol eder.

**Metotlar:**
- `changeTimeframe(TimeframeType timeframe)`: Periyodu değiştirir ve veri listesini yeniden hesaplar.
- `loadAnalyticsData()`: Depolanan geçmiş verileri çeker, korelasyon analizini hesaplar.
- `calculateMoodCorrelation()`: Tamamlanan alışkanlıklar ile kaydedilen mod puanları arasındaki ilişkiyi metne dönüştürür.

---

## 4. Veri Modelleri

### 4.1. `DailyAnalyticsRecordModel` (`features/models/daily_analytics_record_model.dart`)

```dart
class DailyAnalyticsRecordModel {
  final DateTime date;
  final int totalHabits;
  final int completedHabits;
  final int pomodoroMinutes;
  final String? moodKey; // 'great', 'good', 'neutral', 'bad', 'terrible'

  const DailyAnalyticsRecordModel({
    required this.date,
    required this.totalHabits,
    required this.completedHabits,
    required this.pomodoroMinutes,
    this.moodKey,
  });

  double get completionRate => totalHabits == 0 ? 0.0 : (completedHabits / totalHabits);

  int get heatmapIntensityLevel {
    if (completedHabits == 0) return 0;
    if (completedHabits <= 2) return 1;
    if (completedHabits <= 4) return 2;
    return 3;
  }

  factory DailyAnalyticsRecordModel.fromJson(Map<String, dynamic> json) {
    return DailyAnalyticsRecordModel(
      date: DateTime.parse(json['date']),
      totalHabits: json['totalHabits'] ?? 0,
      completedHabits: json['completedHabits'] ?? 0,
      pomodoroMinutes: json['pomodoroMinutes'] ?? 0,
      moodKey: json['moodKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalHabits': totalHabits,
      'completedHabits': completedHabits,
      'pomodoroMinutes': pomodoroMinutes,
      'moodKey': moodKey,
    };
  }
}
```

### 4.2. `AnalyticsSummaryModel` (`features/models/analytics_summary_model.dart`)

```dart
enum TimeframeType { week, month, quarter }

class AnalyticsSummaryModel {
  final double averageCompletionRate;
  final int bestStreakDays;
  final int totalFocusMinutes;
  final String keyInsight;
  final Map<String, double> categoryDistribution;

  const AnalyticsSummaryModel({
    required this.averageCompletionRate,
    required this.bestStreakDays,
    required this.totalFocusMinutes,
    required this.keyInsight,
    required this.categoryDistribution,
  });
}
```

---

## 5. View Kod İskeleti (`features/views/analytics_view.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/analytics_controller.dart';
import '../models/analytics_summary_model.dart';
import '../models/daily_analytics_record_model.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  late final AnalyticsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnalyticsController();
    _controller.loadAnalyticsData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('İstatistik & Analiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Haftalık Raporu Paylaş',
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeframeFilter(),
              const SizedBox(height: 16),
              _buildSummaryCards(isDark),
              const SizedBox(height: 20),
              _buildSectionTitle('Haftalık Tamamlama Dağılımı'),
              const SizedBox(height: 10),
              _buildBarChartCard(isDark),
              const SizedBox(height: 20),
              _buildSectionTitle('Katkı Isı Haritası (Heatmap)'),
              const SizedBox(height: 10),
              _buildHeatmapCard(isDark),
              const SizedBox(height: 20),
              _buildSectionTitle('Alışkanlık & Ruh Hali Korelasyonu'),
              const SizedBox(height: 10),
              _buildInsightCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTimeframeFilter() {
    return ValueListenableBuilder<TimeframeType>(
      valueListenable: _controller.selectedTimeframeNotifier,
      builder: (context, timeframe, _) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              _buildFilterOption('Bu Hafta', TimeframeType.week, timeframe),
              _buildFilterOption('Bu Ay', TimeframeType.month, timeframe),
              _buildFilterOption('Son 90 Gün', TimeframeType.quarter, timeframe),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, TimeframeType type, TimeframeType active) {
    final isSelected = type == active;
    return Expanded(
      child: GestureDetector(
        onTap: () => _controller.changeTimeframe(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(bool isDark) {
    return Row(
      children: [
        _buildMetricItem('%84', 'Tamamlama', Icons.check_circle_rounded, AppColors.primary, isDark),
        const SizedBox(width: 10),
        _buildMetricItem('18 Gün', 'En İyi Seri', Icons.local_fire_department_rounded, AppColors.secondary, isDark),
        const SizedBox(width: 10),
        _buildMetricItem('6.5 Sa', 'Odaklanma', Icons.timer_rounded, AppColors.info, isDark),
      ],
    );
  }

  Widget _buildMetricItem(String val, String label, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              val,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartCard(bool isDark) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Center(
        // fl_chart kütüphanesinin BarChart widget'ı burada render edilir
        child: Text(
          'fl_chart Bar Grafik Alanı (% Tamamlanma)',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildHeatmapCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Son 4 Haftalık Tutarlılık',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          // 7 satırlı, 12 sütunlu mini kutucuk ızgarası
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(28, (index) {
              final level = (index % 4);
              Color boxColor = isDark ? AppColors.borderDark : AppColors.borderLight;
              if (level == 1) boxColor = AppColors.primary.withOpacity(0.3);
              if (level == 2) boxColor = AppColors.primary.withOpacity(0.65);
              if (level == 3) boxColor = AppColors.primary;

              return Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Az', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              const SizedBox(width: 4),
              Container(width: 10, height: 10, color: AppColors.borderLight),
              const SizedBox(width: 4),
              Container(width: 10, height: 10, color: AppColors.primary.withOpacity(0.3)),
              const SizedBox(width: 4),
              Container(width: 10, height: 10, color: AppColors.primary.withOpacity(0.65)),
              const SizedBox(width: 4),
              Container(width: 10, height: 10, color: AppColors.primary),
              const SizedBox(width: 4),
              const Text('Çok', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Davranışsal İçgörü',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Günde 5 sayfa kitap okuduğun ve egzersiz yaptığın günlerde duygu durumun %73 oranında "Harika 🤩" veya "İyi 🙂" kaydedildi.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```