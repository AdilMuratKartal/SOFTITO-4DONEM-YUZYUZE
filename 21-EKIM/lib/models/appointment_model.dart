import 'package:flutter/foundation.dart';

@immutable
class AppointmentModel {
  final String id;
  final String listingId;
  final String customerId;
  final String customerName;
  final String providerId;
  final String providerName;
  final String serviceTitle;
  final String description;
  final String appointmentDate; // '2026-10-22'
  final String appointmentTime; // '10:30'
  final double offeredPrice;
  final String locationType;    // 'sen_gel' | 'ben_geleyim'
  final String address;         // Hizmetin gerçekleşeceği açık adres
  final String status;          // 'beklemede' | 'onaylandi' | 'iptal' | 'bitti'
  final String lastOfferBy;     // 'customer' | 'provider'
  final String createdAt;

  const AppointmentModel({
    required this.id,
    required this.listingId,
    required this.customerId,
    required this.customerName,
    required this.providerId,
    required this.providerName,
    required this.serviceTitle,
    required this.description,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.offeredPrice,
    required this.locationType,
    required this.address,
    required this.status,
    required this.lastOfferBy,
    required this.createdAt,
  });

  bool get isPending => status == 'beklemede';
  bool get isApproved => status == 'onaylandi';
  bool get isCancelled => status == 'iptal';
  bool get isCompleted => status == 'bitti';

  AppointmentModel copyWith({
    String? id,
    String? listingId,
    String? customerId,
    String? customerName,
    String? providerId,
    String? providerName,
    String? serviceTitle,
    String? description,
    String? appointmentDate,
    String? appointmentTime,
    double? offeredPrice,
    String? locationType,
    String? address,
    String? status,
    String? lastOfferBy,
    String? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      description: description ?? this.description,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      offeredPrice: offeredPrice ?? this.offeredPrice,
      locationType: locationType ?? this.locationType,
      address: address ?? this.address,
      status: status ?? this.status,
      lastOfferBy: lastOfferBy ?? this.lastOfferBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String? ?? '',
      listingId: json['listingId'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? 'Müşteri',
      providerId: json['providerId'] as String? ?? '',
      providerName: json['providerName'] as String? ?? 'Hizmet Veren',
      serviceTitle: json['serviceTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      appointmentDate: json['appointmentDate'] as String? ?? '',
      appointmentTime: json['appointmentTime'] as String? ?? '',
      offeredPrice: (json['offeredPrice'] as num?)?.toDouble() ?? 0.0,
      locationType: json['locationType'] as String? ?? 'ben_geleyim',
      address: json['address'] as String? ?? '',
      status: json['status'] as String? ?? 'beklemede',
      lastOfferBy: json['lastOfferBy'] as String? ?? 'customer',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'customerId': customerId,
      'customerName': customerName,
      'providerId': providerId,
      'providerName': providerName,
      'serviceTitle': serviceTitle,
      'description': description,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'offeredPrice': offeredPrice,
      'locationType': locationType,
      'address': address,
      'status': status,
      'lastOfferBy': lastOfferBy,
      'createdAt': createdAt,
    };
  }
}
