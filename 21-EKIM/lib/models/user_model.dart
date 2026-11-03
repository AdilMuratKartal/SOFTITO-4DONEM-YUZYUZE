import 'package:flutter/foundation.dart';

@immutable
class UserModel { // UserModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String role; // 'customer' | 'provider'
  final String name; // String türünden name adlı değişkenimiz
  final String email; // String türünden email adlı değişkenimiz
  final String phone; // String türünden phone adlı değişkenimiz
  final String? savedAddress; // Müşteri kayıtlı ikamet adresi
  final String? shopAddress;  // Hizmet veren dükkan/ofis adresi
  final String? sector;       // Hizmet veren uzmanlık sektörü

  const UserModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.role, // role parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.name, // name parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.email, // email parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.phone, // phone parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.savedAddress, // savedAddress alanına değer aktarıyoruz
    this.shopAddress, // shopAddress alanına değer aktarıyoruz
    this.sector, // sector alanına değer aktarıyoruz
  });

  bool get isCustomer => role == 'customer';
  bool get isProvider => role == 'provider'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz

  UserModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    String? role,
    String? name,
    String? email,
    String? phone,
    String? savedAddress,
    String? shopAddress,
    String? sector,
  }) {
    return UserModel(
      id: id ?? this.id, // id alanına değer aktarıyoruz
      role: role ?? this.role, // role alanına değer aktarıyoruz
      name: name ?? this.name, // name alanına değer aktarıyoruz
      email: email ?? this.email, // email alanına değer aktarıyoruz
      phone: phone ?? this.phone, // phone alanına değer aktarıyoruz
      savedAddress: savedAddress ?? this.savedAddress, // savedAddress alanına değer aktarıyoruz
      shopAddress: shopAddress ?? this.shopAddress, // shopAddress alanına değer aktarıyoruz
      sector: sector ?? this.sector, // sector alanına değer aktarıyoruz
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    return UserModel(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? 'customer',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      savedAddress: json['savedAddress'] as String?,
      shopAddress: json['shopAddress'] as String?,
      sector: json['sector'] as String?,
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    return {
      'id': id,
      'role': role,
      'name': name,
      'email': email,
      'phone': phone,
      'savedAddress': savedAddress,
      'shopAddress': shopAddress,
      'sector': sector,
    };
  }
}
