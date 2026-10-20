import 'package:flutter/foundation.dart';

@immutable
class TimelineFilterModel {
  final String searchQuery;
  final String? selectedMood;
  final String? selectedTag;

  const TimelineFilterModel({
    this.searchQuery = '',
    this.selectedMood,
    this.selectedTag,
  });

  TimelineFilterModel copyWith({
    String? searchQuery,
    String? selectedMood,
    String? selectedTag,
    bool clearMood = false,
    bool clearTag = false,
  }) {
    return TimelineFilterModel(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMood: clearMood ? null : (selectedMood ?? this.selectedMood),
      selectedTag: clearTag ? null : (selectedTag ?? this.selectedTag),
    );
  }
}
