import 'dart:convert'; // JSON çözümleme (jsonDecode) ve dönüştürme işlemleri için bu paketi ekliyoruz

/// Yol Haritası Basamak / Düğüm Modeli
class RoadmapNodeModel { // RoadmapNodeModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final int stepNumber; // int türünden stepNumber adlı değişkenimiz
  final String title; // String türünden title adlı değişkenimiz
  final String description; // String türünden description adlı değişkenimiz
  final int targetDaysStreak; // Bu aşamayı tamamlamak için gereken seri (gün)
  final List<String> linkedHabitIds; // Bağlı mikro-alışkanlık referans ID'leri
  final bool isCompleted; // bool türünden isCompleted adlı değişkenimiz
  final bool isLocked; // bool türünden isLocked adlı değişkenimiz

  const RoadmapNodeModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.stepNumber, // stepNumber parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.title, // title parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.description, // description parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.targetDaysStreak, // targetDaysStreak parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.linkedHabitIds, // linkedHabitIds parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.isCompleted = false, // isCompleted alanına değer aktarıyoruz
    this.isLocked = true, // isLocked alanına değer aktarıyoruz
  });

  RoadmapNodeModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    int? stepNumber,
    String? title,
    String? description,
    int? targetDaysStreak,
    List<String>? linkedHabitIds,
    bool? isCompleted,
    bool? isLocked,
  }) {
    return RoadmapNodeModel(
      id: id ?? this.id, // id alanına değer aktarıyoruz
      stepNumber: stepNumber ?? this.stepNumber, // stepNumber alanına değer aktarıyoruz
      title: title ?? this.title, // title alanına değer aktarıyoruz
      description: description ?? this.description, // description alanına değer aktarıyoruz
      targetDaysStreak: targetDaysStreak ?? this.targetDaysStreak, // targetDaysStreak alanına değer aktarıyoruz
      linkedHabitIds: linkedHabitIds ?? this.linkedHabitIds, // linkedHabitIds alanına değer aktarıyoruz
      isCompleted: isCompleted ?? this.isCompleted, // isCompleted alanına değer aktarıyoruz
      isLocked: isLocked ?? this.isLocked, // isLocked alanına değer aktarıyoruz
    );
  }

  factory RoadmapNodeModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    return RoadmapNodeModel(
      id: json['id'] as String? ?? UniqueKey().toString(),
      stepNumber: json['stepNumber'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      targetDaysStreak: json['targetDaysStreak'] as int? ?? 7,
      linkedHabitIds: (json['linkedHabitIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    return {
      'id': id,
      'stepNumber': stepNumber,
      'title': title,
      'description': description,
      'targetDaysStreak': targetDaysStreak,
      'linkedHabitIds': linkedHabitIds,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
    };
  }
}

/// Yol Haritası Modeli
class RoadmapModel { // RoadmapModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String title; // String türünden title adlı değişkenimiz
  final String category; // String türünden category adlı değişkenimiz
  final String iconName; // String türünden iconName adlı değişkenimiz
  final String durationWeeks; // String türünden durationWeeks adlı değişkenimiz
  final String nextReward; // String türünden nextReward adlı değişkenimiz
  final bool isCompleted; // bool türünden isCompleted adlı değişkenimiz
  final List<RoadmapNodeModel> nodes; // List<RoadmapNodeModel> türünden nodes adlı değişkenimiz

  const RoadmapModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.title, // title parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.category, // category parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.iconName, // iconName parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.durationWeeks = '4 Hafta', // durationWeeks alanına değer aktarıyoruz
    this.nextReward = 'Odak Nişanı', // nextReward alanına değer aktarıyoruz
    this.isCompleted = false, // isCompleted alanına değer aktarıyoruz
    required this.nodes, // nodes parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  /// Tamamlanan düğüm / Toplam düğüm yüzdesi (0.0 - 100.0)
  double get progressPercentage {
    if (nodes.isEmpty) return 0.0;
    return (completedNodesCount / nodes.length) * 100;
  }

  /// 0.0 - 1.0 aralığında progress oranı (ProgressIndicator için)
  double get progressRatio {
    if (nodes.isEmpty) return 0.0;
    return completedNodesCount / nodes.length;
  }

  int get completedNodesCount => nodes.where((n) => n.isCompleted).length;

  /// İlk tamamlanmamış ve kilitli olmayan aktif basamağı döndürür
  RoadmapNodeModel? get activeNode {
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      return nodes.firstWhere((n) => !n.isCompleted && !n.isLocked);
    } catch (_) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      return null;
    }
  }

  RoadmapModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    String? title,
    String? category,
    String? iconName,
    String? durationWeeks,
    String? nextReward,
    bool? isCompleted,
    List<RoadmapNodeModel>? nodes,
  }) {
    return RoadmapModel(
      id: id ?? this.id, // id alanına değer aktarıyoruz
      title: title ?? this.title, // title alanına değer aktarıyoruz
      category: category ?? this.category, // category alanına değer aktarıyoruz
      iconName: iconName ?? this.iconName, // iconName alanına değer aktarıyoruz
      durationWeeks: durationWeeks ?? this.durationWeeks, // durationWeeks alanına değer aktarıyoruz
      nextReward: nextReward ?? this.nextReward, // nextReward alanına değer aktarıyoruz
      isCompleted: isCompleted ?? this.isCompleted, // isCompleted alanına değer aktarıyoruz
      nodes: nodes ?? this.nodes, // nodes alanına değer aktarıyoruz
    );
  }

  factory RoadmapModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    return RoadmapModel(
      id: json['id'] as String? ?? UniqueKey().toString(),
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'Kişisel Gelişim',
      iconName: json['iconName'] as String? ?? '🎯',
      durationWeeks: json['durationWeeks'] as String? ?? '4 Hafta',
      nextReward: json['nextReward'] as String? ?? 'Odak Nişanı',
      isCompleted: json['isCompleted'] as bool? ?? false,
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => RoadmapNodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    return {
      'id': id,
      'title': title,
      'category': category,
      'iconName': iconName,
      'durationWeeks': durationWeeks,
      'nextReward': nextReward,
      'isCompleted': isCompleted,
      'nodes': nodes.map((n) => n.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory RoadmapModel.fromJsonString(String str) => // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
      RoadmapModel.fromJson(jsonDecode(str) as Map<String, dynamic>); // Gelen ham JSON metnini çözüp Dart nesnelerine/listelerine dönüştürüyoruz
}

class UniqueKey { // UniqueKey sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  String toString() => DateTime.now().microsecondsSinceEpoch.toString();
}
