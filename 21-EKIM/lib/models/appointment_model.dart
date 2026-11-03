import 'package:flutter/foundation.dart';

@immutable
class AppointmentModel { // AppointmentModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String listingId; // String türünden listingId adlı değişkenimiz
  final String customerId; // String türünden customerId adlı değişkenimiz
  final String customerName; // String türünden customerName adlı değişkenimiz
  final String providerId; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
  final String providerName; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
  final String serviceTitle; // String türünden serviceTitle adlı değişkenimiz
  final String description; // String türünden description adlı değişkenimiz
  final String appointmentDate; // '2026-10-22'
  final String appointmentTime; // '10:30'
  final double offeredPrice; // double türünden offeredPrice adlı değişkenimiz
  final String locationType;    // 'sen_gel' | 'ben_geleyim'
  final String address;         // Hizmetin gerçekleşeceği açık adres
  final String status;          // 'beklemede' | 'onaylandi' | 'iptal' | 'bitti'
  final String lastOfferBy;     // 'customer' | 'provider'
  final String createdAt; // String türünden createdAt adlı değişkenimiz

  const AppointmentModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.listingId, // listingId parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.customerId, // customerId parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.customerName, // customerName parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    required this.providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    required this.serviceTitle, // serviceTitle parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.description, // description parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.appointmentDate, // appointmentDate parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.appointmentTime, // appointmentTime parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.offeredPrice, // offeredPrice parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.locationType, // locationType parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.address, // address parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.status, // status parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.lastOfferBy, // lastOfferBy parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.createdAt, // createdAt parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  bool get isPending => status == 'beklemede';
  bool get isApproved => status == 'onaylandi';
  bool get isCancelled => status == 'iptal';
  bool get isCompleted => status == 'bitti';

  AppointmentModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    String? listingId,
    String? customerId,
    String? customerName,
    String? providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    String? providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
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
      id: id ?? this.id, // id alanına değer aktarıyoruz
      listingId: listingId ?? this.listingId, // listingId alanına değer aktarıyoruz
      customerId: customerId ?? this.customerId, // customerId alanına değer aktarıyoruz
      customerName: customerName ?? this.customerName, // customerName alanına değer aktarıyoruz
      providerId: providerId ?? this.providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      providerName: providerName ?? this.providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      serviceTitle: serviceTitle ?? this.serviceTitle, // serviceTitle alanına değer aktarıyoruz
      description: description ?? this.description, // description alanına değer aktarıyoruz
      appointmentDate: appointmentDate ?? this.appointmentDate, // appointmentDate alanına değer aktarıyoruz
      appointmentTime: appointmentTime ?? this.appointmentTime, // appointmentTime alanına değer aktarıyoruz
      offeredPrice: offeredPrice ?? this.offeredPrice, // offeredPrice alanına değer aktarıyoruz
      locationType: locationType ?? this.locationType, // locationType alanına değer aktarıyoruz
      address: address ?? this.address, // address alanına değer aktarıyoruz
      status: status ?? this.status, // status alanına değer aktarıyoruz
      lastOfferBy: lastOfferBy ?? this.lastOfferBy, // lastOfferBy alanına değer aktarıyoruz
      createdAt: createdAt ?? this.createdAt, // createdAt alanına değer aktarıyoruz
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    return AppointmentModel(
      id: json['id'] as String? ?? '',
      listingId: json['listingId'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? 'Müşteri',
      providerId: json['providerId'] as String? ?? '', // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      providerName: json['providerName'] as String? ?? 'Hizmet Veren', // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
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

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    return {
      'id': id,
      'listingId': listingId,
      'customerId': customerId,
      'customerName': customerName,
      'providerId': providerId, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
      'providerName': providerName, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
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
