import 'package:flutter/foundation.dart';

@immutable
class ListingModel {
  final String id;
  final String providerId;
  final String providerName;
  final String title;
  final String sector;
  final String district;
  final String shopAddress;
  final String locationType; // 'sen_gel', 'ben_geleyim', 'her_ikisi'
  final double basePrice;
  final List<String> timeSlots;
  final List<String> availableDays;

  const ListingModel({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.title,
    required this.sector,
    required this.district,
    required this.shopAddress,
    required this.locationType,
    required this.basePrice,
    required this.timeSlots,
    required this.availableDays,
  });

  ListingModel copyWith({
    String? id,
    String? providerId,
    String? providerName,
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
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      title: title ?? this.title,
      sector: sector ?? this.sector,
      district: district ?? this.district,
      shopAddress: shopAddress ?? this.shopAddress,
      locationType: locationType ?? this.locationType,
      basePrice: basePrice ?? this.basePrice,
      timeSlots: timeSlots ?? this.timeSlots,
      availableDays: availableDays ?? this.availableDays,
    );
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String? ?? '',
      providerId: json['providerId'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'providerName': providerName,
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
