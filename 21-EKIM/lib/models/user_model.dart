import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String id;
  final String role; // 'customer' | 'provider'
  final String name;
  final String email;
  final String phone;
  final String? savedAddress; // Müşteri kayıtlı ikamet adresi
  final String? shopAddress;  // Hizmet veren dükkan/ofis adresi
  final String? sector;       // Hizmet veren uzmanlık sektörü

  const UserModel({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    this.savedAddress,
    this.shopAddress,
    this.sector,
  });

  bool get isCustomer => role == 'customer';
  bool get isProvider => role == 'provider';

  UserModel copyWith({
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
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      savedAddress: savedAddress ?? this.savedAddress,
      shopAddress: shopAddress ?? this.shopAddress,
      sector: sector ?? this.sector,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
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
