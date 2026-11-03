import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/theme/app_theme.dart';

class MoodItem { // MoodItem sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String keyName; // String türünden keyName adlı değişkenimiz
  final String label; // String türünden label adlı değişkenimiz
  final String emoji; // String türünden emoji adlı değişkenimiz
  final Color activeColor; // Color türünden activeColor adlı değişkenimiz

  const MoodItem({ // Genel, sabit sınıf constructor'ı
    required this.keyName, // keyName parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.label, // label parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.emoji, // emoji parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.activeColor, // activeColor parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  static const List<MoodItem> allMoods = [
    MoodItem(keyName: 'great', label: 'Harika', emoji: '🤩', activeColor: AppColors.moodGreat),
    MoodItem(keyName: 'good', label: 'İyi', emoji: '🙂', activeColor: AppColors.moodGood),
    MoodItem(keyName: 'neutral', label: 'Normal', emoji: '😐', activeColor: AppColors.moodNeutral),
    MoodItem(keyName: 'bad', label: 'Kötü', emoji: '😕', activeColor: AppColors.moodBad),
    MoodItem(keyName: 'terrible', label: 'Berbat', emoji: '😫', activeColor: AppColors.moodTerrible),
  ];
}
