import 'dart:convert'; // JSON çözümleme (jsonDecode) ve dönüştürme işlemleri için bu paketi ekliyoruz
import 'package:flutter/foundation.dart';

@immutable
class CategoryModel { // CategoryModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String name; // String türünden name adlı değişkenimiz
  final String iconPath; // String türünden iconPath adlı değişkenimiz
  final int colorHex; // int türünden colorHex adlı değişkenimiz
  final bool isCustom; // bool türünden isCustom adlı değişkenimiz

  const CategoryModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.name, // name parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.iconPath, // iconPath parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.colorHex, // colorHex parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.isCustom = false, // isCustom alanına değer aktarıyoruz
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

  factory CategoryModel.fromJson(String source) => // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
