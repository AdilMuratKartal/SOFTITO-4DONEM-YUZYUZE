import 'package:flutter/material.dart';
import '../models/roadmap_model.dart';

class RoadmapController {
  final ValueNotifier<List<RoadmapNodeModel>> nodesNotifier =
      ValueNotifier<List<RoadmapNodeModel>>([
    const RoadmapNodeModel(
      stageNumber: 1,
      title: 'Günde 15 Dk Tempolu Yürüyüş',
      description: 'Haftada 4 gün, hafif tempolu yürüyüş ile kardiyo alışkanlığı kazan.',
      isCompleted: true,
      isActive: false,
      isLocked: false,
    ),
    const RoadmapNodeModel(
      stageNumber: 2,
      title: '1 Dk Koşu / 2 Dk Yürüyüş İnterval',
      description: 'Nabzı kontrollü yükseltmek için interval koşuya başla.',
      isCompleted: true,
      isActive: false,
      isLocked: false,
    ),
    const RoadmapNodeModel(
      stageNumber: 3,
      title: 'Kesintisiz 1.5 Km Hafif Koşu',
      description: 'Haftada 3 gün, duraksamadan 1.5 km mesafeyi tamamla.',
      isCompleted: false,
      isActive: true,
      isLocked: false,
    ),
    const RoadmapNodeModel(
      stageNumber: 4,
      title: 'Kesintisiz 2.5 Km Koşu',
      description: 'Aşama 3 tamamlandıktan sonra açılacak ara hedef.',
      isCompleted: false,
      isActive: false,
      isLocked: true,
    ),
    const RoadmapNodeModel(
      stageNumber: 5,
      title: 'Hedef: 5K Kesintisiz Koşu',
      description: 'Final aşaması: 5 kilometreyi duraksamadan bitir.',
      isCompleted: false,
      isActive: false,
      isLocked: true,
    ),
  ]);

  void completeActiveStage() {
    final list = List<RoadmapNodeModel>.from(nodesNotifier.value);
    int activeIdx = list.indexWhere((n) => n.isActive);
    if (activeIdx != -1) {
      final current = list[activeIdx];
      list[activeIdx] = RoadmapNodeModel(
        stageNumber: current.stageNumber,
        title: current.title,
        description: current.description,
        isCompleted: true,
        isActive: false,
        isLocked: false,
      );

      if (activeIdx + 1 < list.length) {
        final next = list[activeIdx + 1];
        list[activeIdx + 1] = RoadmapNodeModel(
          stageNumber: next.stageNumber,
          title: next.title,
          description: next.description,
          isCompleted: false,
          isActive: true,
          isLocked: false,
        );
      }
      nodesNotifier.value = list;
    }
  }

  void dispose() {
    nodesNotifier.dispose();
  }
}
