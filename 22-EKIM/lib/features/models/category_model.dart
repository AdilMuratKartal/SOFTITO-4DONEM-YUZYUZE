import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class CategoryModel {
  final String id;
  final String name;
  final String iconPath;
  final int colorHex;
  final bool isCustom;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.colorHex,
    this.isCustom = false,
  });

  // 4 Temel Başlangıç Kategorisi
  static const List<CategoryModel> defaultCategories = [
    CategoryModel(
      id: 'sport',
      name: 'Spor',
      iconPath: 'assets/icons/sport.svg',
      colorHex: 0xFF10B981, // Yeşil
      isCustom: false,
    ),
    CategoryModel(
      id: 'health',
      name: 'Sağlık',
      iconPath: 'assets/icons/health.svg',
      colorHex: 0xFF0EA5E9, // Gök Mavisi
      isCustom: false,
    ),
    CategoryModel(
      id: 'mind',
      name: 'Zihin',
      iconPath: 'assets/icons/mind.svg',
      colorHex: 0xFF8B5CF6, // Menekşe Moru
      isCustom: false,
    ),
    CategoryModel(
      id: 'music',
      name: 'Müzik',
      iconPath: 'assets/icons/music.svg',
      colorHex: 0xFFEC4899, // Pembe
      isCustom: false,
    ),
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'colorHex': colorHex,
      'isCustom': isCustom,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      iconPath: map['iconPath'] as String,
      colorHex: map['colorHex'] as int,
      isCustom: map['isCustom'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
