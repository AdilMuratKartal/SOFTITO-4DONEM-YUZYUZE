import 'package:flutter/foundation.dart';

@immutable
class TimelineFilterModel { // TimelineFilterModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String searchQuery; // String türünden searchQuery adlı değişkenimiz
  final String? selectedMood; // String? türünden selectedMood adlı değişkenimiz
  final String? selectedTag; // String? türünden selectedTag adlı değişkenimiz

  const TimelineFilterModel({ // Genel, sabit sınıf constructor'ı
    this.searchQuery = '', // searchQuery alanına değer aktarıyoruz
    this.selectedMood, // selectedMood alanına değer aktarıyoruz
    this.selectedTag, // selectedTag alanına değer aktarıyoruz
  });

  TimelineFilterModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? searchQuery,
    String? selectedMood,
    String? selectedTag,
    bool clearMood = false,
    bool clearTag = false,
  }) {
    return TimelineFilterModel(
      searchQuery: searchQuery ?? this.searchQuery, // searchQuery alanına değer aktarıyoruz
      selectedMood: clearMood ? null : (selectedMood ?? this.selectedMood), // selectedMood alanına değer aktarıyoruz
      selectedTag: clearTag ? null : (selectedTag ?? this.selectedTag), // selectedTag alanına değer aktarıyoruz
    );
  }
}
