import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../models/user_model.dart';
import '../../models/listing_model.dart';
import '../../models/appointment_model.dart';
import '../../models/message_model.dart';

class JsonDataService {
  Future<List<UserModel>> loadUsers() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('users.json okuma hatası: $e');
      return [];
    }
  }

  Future<List<ListingModel>> loadListings() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/listings.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => ListingModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('listings.json okuma hatası: $e');
      return [];
    }
  }

  Future<List<AppointmentModel>> loadAppointments() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/appointments.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('appointments.json okuma hatası: $e');
      return [];
    }
  }

  Future<List<MessageModel>> loadMessages() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/messages.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => MessageModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('messages.json okuma hatası: $e');
      return [];
    }
  }
}
