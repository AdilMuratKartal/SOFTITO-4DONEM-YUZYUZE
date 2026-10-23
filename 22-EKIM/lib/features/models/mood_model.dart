import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MoodItem {
  final String keyName;
  final String label;
  final String emoji;
  final Color activeColor;

  const MoodItem({
    required this.keyName,
    required this.label,
    required this.emoji,
    required this.activeColor,
  });

  static const List<MoodItem> allMoods = [
    MoodItem(keyName: 'great', label: 'Harika', emoji: '🤩', activeColor: AppColors.moodGreat),
    MoodItem(keyName: 'good', label: 'İyi', emoji: '🙂', activeColor: AppColors.moodGood),
    MoodItem(keyName: 'neutral', label: 'Normal', emoji: '😐', activeColor: AppColors.moodNeutral),
    MoodItem(keyName: 'bad', label: 'Kötü', emoji: '😕', activeColor: AppColors.moodBad),
    MoodItem(keyName: 'terrible', label: 'Berbat', emoji: '😫', activeColor: AppColors.moodTerrible),
  ];
}
