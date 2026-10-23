import 'package:flutter/material.dart';
import '../models/roadmap_model.dart';
import '../models/habit_model.dart';
import 'habit_controller.dart';
import '../../core/services/storage_service.dart';

/// Yol Haritası (Roadmap) Modülü State Controller'ı
/// Single Source of Truth prensibiyle HabitController'ı sürekli dinler
/// ve arka planda basamak ilerlemelerini ve kilit açılmalarını anında senkronize eder.
class RoadmapController {
  final HabitController habitController;

  final ValueNotifier<List<RoadmapModel>> roadmapsNotifier =
      ValueNotifier<List<RoadmapModel>>([]);

  final ValueNotifier<RoadmapModel?> selectedRoadmapNotifier =
      ValueNotifier<RoadmapModel?>(null);

  final ValueNotifier<bool> isCompletedExpandedNotifier =
      ValueNotifier<bool>(false);

  RoadmapController({required this.habitController}) {
    // 4. Arka Plan Canlı Senkronizasyonu: HabitController'ı dinle
    habitController.habitsNotifier.addListener(_onHabitsChanged);
    loadRoadmaps();
  }

  /// Kayıtlı yol haritalarını SharedPreferences üzerinden yükler
  Future<void> loadRoadmaps() async {
    final loaded = await StorageService.loadRoadmaps();
    roadmapsNotifier.value = loaded;

    // Aktif ilk haritayı varsayılan seç
    final active = loaded.where((r) => !r.isCompleted).toList();
    if (active.isNotEmpty) {
      selectedRoadmapNotifier.value = active.first;
    } else if (loaded.isNotEmpty) {
      selectedRoadmapNotifier.value = loaded.first;
    }

    // İlk yüklemede mevcut alışkanlıkların durumuna göre düğümleri değerlendir
    _evaluateNodeConditions(notify: false);
  }

  /// Ana sayfada bir alışkanlık tamamlandığında / streak değiştiğinde otomatik tetiklenir
  void _onHabitsChanged() {
    _evaluateNodeConditions(notify: true);
  }

  /// Tüm haritalardaki düğüm şartlarını (linkedHabitIds ve targetDaysStreak) kontrol eder
  void _evaluateNodeConditions({bool notify = true}) {
    final currentHabits = habitController.habitsNotifier.value;
    final habitMap = {for (var h in currentHabits) h.id: h};

    bool hasAnyChange = false;

    final updatedRoadmaps = roadmapsNotifier.value.map((roadmap) {
      if (roadmap.isCompleted) return roadmap;

      bool roadmapModified = false;
      List<RoadmapNodeModel> updatedNodes = List.from(roadmap.nodes);

      for (int i = 0; i < updatedNodes.length; i++) {
        final node = updatedNodes[i];

        // Kilitli olmayan aşamaları kontrol et
        if (!node.isLocked && !node.isCompleted) {
          if (node.linkedHabitIds.isNotEmpty) {
            // Bağlı alışkanlıkları bul
            final linkedHabits = node.linkedHabitIds
                .map((id) => habitMap[id])
                .whereType<HabitModel>()
                .toList();

            if (linkedHabits.isNotEmpty) {
              // Streak şartı kontrolü (tüm bağlı alışkanlıkların min serisi veya tamamlanma durumu)
              final minStreak = linkedHabits
                  .map((h) => h.streakDays)
                  .reduce((a, b) => a < b ? a : b);

              final allCompletedToday = linkedHabits.every((h) => h.isCompleted);

              // Hedef seriye ulaşıldıysa veya 1 günlük hedef olup bugün tamamlandıysa
              final isTargetMet = minStreak >= node.targetDaysStreak ||
                  (node.targetDaysStreak <= 1 && allCompletedToday);

              if (isTargetMet) {
                updatedNodes[i] = node.copyWith(isCompleted: true);
                roadmapModified = true;
                hasAnyChange = true;

                // Bir sonraki basamağın kilidini aç
                if (i + 1 < updatedNodes.length) {
                  updatedNodes[i + 1] =
                      updatedNodes[i + 1].copyWith(isLocked: false);
                }
              }
            }
          }
        }
      }

      // Tüm düğümler tamamlandı mı kontrolü
      final allNodesCompleted =
          updatedNodes.every((n) => n.isCompleted) && updatedNodes.isNotEmpty;

      if (roadmapModified || allNodesCompleted != roadmap.isCompleted) {
        hasAnyChange = true;
        return roadmap.copyWith(
          nodes: updatedNodes,
          isCompleted: allNodesCompleted,
        );
      }

      return roadmap;
    }).toList();

    if (hasAnyChange) {
      roadmapsNotifier.value = updatedRoadmaps;
      StorageService.saveRoadmaps(updatedRoadmaps);

      // Seçili harita varsa güncelle
      if (selectedRoadmapNotifier.value != null) {
        final currentSelectedId = selectedRoadmapNotifier.value!.id;
        final refreshed = updatedRoadmaps.firstWhere(
          (r) => r.id == currentSelectedId,
          orElse: () => updatedRoadmaps.first,
        );
        selectedRoadmapNotifier.value = refreshed;
      }

      if (notify) {
        debugPrint(
            '[RoadmapController]: Arka plan senkronizasyonu tamamlandı. Yol haritası güncellendi.');
      }
    }
  }

  /// Yeni Yol Haritası Ekleme
  void addRoadmap(RoadmapModel roadmap) {
    roadmapsNotifier.value = [...roadmapsNotifier.value, roadmap];
    selectedRoadmapNotifier.value = roadmap;
    StorageService.saveRoadmaps(roadmapsNotifier.value);
    _evaluateNodeConditions(notify: true);
  }

  /// Yol Haritası Silme
  void deleteRoadmap(String id) {
    roadmapsNotifier.value =
        roadmapsNotifier.value.where((r) => r.id != id).toList();
    if (selectedRoadmapNotifier.value?.id == id) {
      selectedRoadmapNotifier.value = roadmapsNotifier.value.isNotEmpty
          ? roadmapsNotifier.value.first
          : null;
    }
    StorageService.saveRoadmaps(roadmapsNotifier.value);
  }

  /// Harita Seçme
  void selectRoadmap(RoadmapModel roadmap) {
    selectedRoadmapNotifier.value = roadmap;
  }

  /// Kullanıcının basamağı manuel olarak onaylayıp tamamlaması
  void completeNodeManually(String roadmapId, String nodeId) {
    final list = List<RoadmapModel>.from(roadmapsNotifier.value);
    final rIndex = list.indexWhere((r) => r.id == roadmapId);
    if (rIndex == -1) return;

    final roadmap = list[rIndex];
    final nodes = List<RoadmapNodeModel>.from(roadmap.nodes);
    final nIndex = nodes.indexWhere((n) => n.id == nodeId);
    if (nIndex == -1) return;

    // Düğümü tamamla
    nodes[nIndex] = nodes[nIndex].copyWith(isCompleted: true);

    // Sonraki düğümün kilidini aç
    if (nIndex + 1 < nodes.length) {
      nodes[nIndex + 1] = nodes[nIndex + 1].copyWith(isLocked: false);
    }

    final allDone = nodes.every((n) => n.isCompleted);
    final updatedRoadmap = roadmap.copyWith(
      nodes: nodes,
      isCompleted: allDone,
    );

    list[rIndex] = updatedRoadmap;
    roadmapsNotifier.value = list;
    if (selectedRoadmapNotifier.value?.id == roadmapId) {
      selectedRoadmapNotifier.value = updatedRoadmap;
    }
    StorageService.saveRoadmaps(list);
  }

  /// Düğüme bağlı alışkanlığı direkt tamamlama / geri alma aksiyonu
  void toggleLinkedHabit(String habitId) {
    habitController.toggleHabit(habitId);
  }

  /// Tamamlanan haritalar akordeonunu aç/kapat
  void toggleCompletedAccordion() {
    isCompletedExpandedNotifier.value = !isCompletedExpandedNotifier.value;
  }

  void dispose() {
    habitController.habitsNotifier.removeListener(_onHabitsChanged);
    roadmapsNotifier.dispose();
    selectedRoadmapNotifier.dispose();
    isCompletedExpandedNotifier.dispose();
  }
}
