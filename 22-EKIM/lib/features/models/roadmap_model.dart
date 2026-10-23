class RoadmapNodeModel {
  final int stageNumber;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isActive;
  final bool isLocked;

  const RoadmapNodeModel({
    required this.stageNumber,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isActive = false,
    this.isLocked = true,
  });
}
