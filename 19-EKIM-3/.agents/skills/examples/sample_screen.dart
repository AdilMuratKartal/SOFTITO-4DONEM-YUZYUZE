import 'package:flutter/material.dart';

// ==============================================================================
// ÖRNEK REFERANS EKRAN: Clean UI & Reaktif State Mimarisi
// Standart: project.md ve SKILL.md kurallarına tam uyumlu altın standart şablon.
// ==============================================================================

// -----------------------------------------------------------------------------
// 1. MODEL KATMANI (Immutable, copyWith, fromJson, toJson)
// -----------------------------------------------------------------------------
@immutable
class StepLogModel {
  final String id;
  final int stepCount;
  final double caloriesBurned;
  final DateTime recordedAt;

  const StepLogModel({
    required this.id,
    required this.stepCount,
    required this.caloriesBurned,
    required this.recordedAt,
  });

  StepLogModel copyWith({
    String? id,
    int? stepCount,
    double? caloriesBurned,
    DateTime? recordedAt,
  }) {
    return StepLogModel(
      id: id ?? this.id,
      stepCount: stepCount ?? this.stepCount,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  factory StepLogModel.fromJson(Map<String, dynamic> json) {
    return StepLogModel(
      id: json['id'] as String? ?? '',
      stepCount: (json['stepCount'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
      recordedAt: json['recordedAt'] != null
          ? DateTime.tryParse(json['recordedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'stepCount': stepCount,
      'caloriesBurned': caloriesBurned,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }
}

// -----------------------------------------------------------------------------
// 2. CONTROLLER KATMANI (ValueNotifier, İş Mantığı, Dispose)
// -----------------------------------------------------------------------------
class StepTrackerController {
  final ValueNotifier<int> totalStepsNotifier = ValueNotifier<int>(0);
  final ValueNotifier<List<StepLogModel>> logsNotifier =
      ValueNotifier<List<StepLogModel>>(<StepLogModel>[]);

  final int dailyGoalSteps = 10000;

  int get totalSteps => totalStepsNotifier.value;
  List<StepLogModel> get logs => logsNotifier.value;
  double get progressRatio => (totalSteps / dailyGoalSteps).clamp(0.0, 1.0);

  /// Hızlı adım ekleme
  void addSteps(int count) {
    if (count <= 0) return;
    totalStepsNotifier.value += count;

    final newLog = StepLogModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      stepCount: count,
      caloriesBurned: count * 0.04, // Yaklaşık adım başına kalori
      recordedAt: DateTime.now(),
    );

    logsNotifier.value = List<StepLogModel>.from(logsNotifier.value)..insert(0, newLog);
  }

  /// Kayıt silme
  void removeLog(String id) {
    final removed = logsNotifier.value.firstWhere((log) => log.id == id,
        orElse: () => const StepLogModel(id: '', stepCount: 0, caloriesBurned: 0, recordedAt: null as dynamic));
    if (removed.id.isNotEmpty) {
      totalStepsNotifier.value = (totalStepsNotifier.value - removed.stepCount).clamp(0, 999999);
      logsNotifier.value = logsNotifier.value.where((log) => log.id != id).toList();
    }
  }

  /// Günlük sıfırlama
  void reset() {
    totalStepsNotifier.value = 0;
    logsNotifier.value = <StepLogModel>[];
  }

  /// Bellek sızıntısını önlemek için dispose şarttır
  void dispose() {
    totalStepsNotifier.dispose();
    logsNotifier.dispose();
  }
}

// -----------------------------------------------------------------------------
// 3. WIDGET KATMANI (40 Satırı Geçmeyen Atomik Bileşenler)
// -----------------------------------------------------------------------------
class StepProgressCard extends StatelessWidget {
  final int totalSteps;
  final int goalSteps;
  final double progressRatio;

  const StepProgressCard({
    super.key,
    required this.totalSteps,
    required this.goalSteps,
    required this.progressRatio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Günlük Adım', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 6),
              Text(
                '$totalSteps / $goalSteps',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          CircularProgressIndicator(
            value: progressRatio,
            strokeWidth: 6,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. VIEW KATMANI (StatelessWidget + ValueListenableBuilder)
// -----------------------------------------------------------------------------
class SampleStepTrackerView extends StatelessWidget {
  final StepTrackerController controller;

  const SampleStepTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adım Takibi (Referans Ekran)'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressSection(),
              const SizedBox(height: 16),
              _buildActionSection(),
              const SizedBox(height: 20),
              _buildLogListSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return ValueListenableBuilder<int>(
      valueListenable: controller.totalStepsNotifier,
      builder: (context, totalSteps, _) {
        return StepProgressCard(
          totalSteps: totalSteps,
          goalSteps: controller.dailyGoalSteps,
          progressRatio: controller.progressRatio,
        );
      },
    );
  }

  Widget _buildActionSection() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.directions_walk_rounded),
            label: const Text('+1000 Adım'),
            onPressed: () => controller.addSteps(1000),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.directions_run_rounded),
            label: const Text('+3000 Adım'),
            onPressed: () => controller.addSteps(3000),
          ),
        ),
      ],
    );
  }

  Widget _buildLogListSection() {
    return ValueListenableBuilder<List<StepLogModel>>(
      valueListenable: controller.logsNotifier,
      builder: (context, logs, _) {
        if (logs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('Henüz adım kaydı girilmedi.'),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline_rounded),
                title: Text('+${log.stepCount} Adım'),
                subtitle: Text('~${log.caloriesBurned.toStringAsFixed(1)} kcal yakıldı'),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () => controller.removeLog(log.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
