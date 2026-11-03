import 'package:flutter/foundation.dart';

@immutable
class ListingModel { // ListingModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String providerId; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
  final String providerName; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
  final String title; // String türünden title adlı değişkenimiz
  final String sector; // String türünden sector adlı değişkenimiz
  final String district; // String türünden district adlı değişkenimiz
  final String shopAddress; // String türünden shopAddress adlı değişkenimiz
  final String locationType; // 'sen_gel', 'ben_geleyim', 'her_ikisi'
  final double basePrice; // double türünden basePrice adlı değişkenimiz
  final List<String> timeSlots; // List<String> türünden timeSlots adlı değişkenimiz
  final List<String> availableDays; // List<String> türünden availableDays adlı değişkenimiz

  const ListingModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    required this.providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    required this.title, // title parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.sector, // sector parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.district, // district parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.shopAddress, // shopAddress parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.locationType, // locationType parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.basePrice, // basePrice parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.timeSlots, // timeSlots parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.availableDays, // availableDays parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  ListingModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    String? providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    String? providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    String? title,
    String? sector,
    String? district,
    String? shopAddress,
    String? locationType,
    double? basePrice,
    List<String>? timeSlots,
    List<String>? availableDays,
  }) {
    return ListingModel(
      id: id ?? this.id, // id alanına değer aktarıyoruz
      providerId: providerId ?? this.providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      providerName: providerName ?? this.providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      title: title ?? this.title, // title alanına değer aktarıyoruz
      sector: sector ?? this.sector, // sector alanına değer aktarıyoruz
      district: district ?? this.district, // district alanına değer aktarıyoruz
      shopAddress: shopAddress ?? this.shopAddress, // shopAddress alanına değer aktarıyoruz
      locationType: locationType ?? this.locationType, // locationType alanına değer aktarıyoruz
      basePrice: basePrice ?? this.basePrice, // basePrice alanına değer aktarıyoruz
      timeSlots: timeSlots ?? this.timeSlots, // timeSlots alanına değer aktarıyoruz
      availableDays: availableDays ?? this.availableDays, // availableDays alanına değer aktarıyoruz
    );
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    return ListingModel(
      id: json['id'] as String? ?? '',
      providerId: json['providerId'] as String? ?? '', // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      providerName: json['providerName'] as String? ?? '', // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      title: json['title'] as String? ?? '',
      sector: json['sector'] as String? ?? 'Genel',
      district: json['district'] as String? ?? '',
      shopAddress: json['shopAddress'] as String? ?? '',
      locationType: json['locationType'] as String? ?? 'her_ikisi',
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      timeSlots: (json['timeSlots'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      availableDays: (json['availableDays'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    return {
      'id': id,
      'providerId': providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      'providerName': providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      'title': title,
      'sector': sector,
      'district': district,
      'shopAddress': shopAddress,
      'locationType': locationType,
      'basePrice': basePrice,
      'timeSlots': timeSlots,
      'availableDays': availableDays,
    };
  }
}
