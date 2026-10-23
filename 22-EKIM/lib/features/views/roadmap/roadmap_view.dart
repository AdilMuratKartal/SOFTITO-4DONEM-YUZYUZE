import 'package:flutter/material.dart';
import '../../controllers/roadmap_controller.dart';
import '../../controllers/habit_controller.dart';
import '../roadmap_list_view.dart';

/// Yol Haritası Ana Ekran Sarmalayıcısı (RoadmapView)
/// Yeni hiyerarşik RoadmapListView bileşenine yönlendirir.
class RoadmapView extends StatefulWidget {
  final RoadmapController? roadmapController;
  final HabitController? habitController;

  const RoadmapView({
    super.key,
    this.roadmapController,
    this.habitController,
  });

  @override
  State<RoadmapView> createState() => _RoadmapViewState();
}

class _RoadmapViewState extends State<RoadmapView> {
  late final HabitController _habitController;
  late final RoadmapController _roadmapController;
  bool _ownsControllers = false;

  @override
  void initState() {
    super.initState();
    if (widget.roadmapController != null && widget.habitController != null) {
      _habitController = widget.habitController!;
      _roadmapController = widget.roadmapController!;
    } else {
      _ownsControllers = true;
      _habitController = HabitController();
      _habitController.loadDailyHabits();
      _roadmapController = RoadmapController(habitController: _habitController);
    }
  }

  @override
  void dispose() {
    if (_ownsControllers) {
      _roadmapController.dispose();
      _habitController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoadmapListView(
      roadmapController: _roadmapController,
      habitController: _habitController,
    );
  }
}
