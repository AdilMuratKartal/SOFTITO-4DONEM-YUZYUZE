import 'dart:convert'; // JSON çözümleme (jsonDecode) ve dönüştürme işlemleri için bu paketi ekliyoruz
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import '../../models/user_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/listing_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/appointment_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/message_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class JsonDataService {
  Future<List<UserModel>> loadUsers() async {
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      final jsonStr = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      debugPrint('users.json okuma hatası: $e');
      return [];
    }
  }

  Future<List<ListingModel>> loadListings() async {
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      final jsonStr = await rootBundle.loadString('assets/data/listings.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => ListingModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      debugPrint('listings.json okuma hatası: $e');
      return [];
    }
  }

  Future<List<AppointmentModel>> loadAppointments() async {
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      final jsonStr = await rootBundle.loadString('assets/data/appointments.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      debugPrint('appointments.json okuma hatası: $e');
      return [];
    }
  }

  Future<List<MessageModel>> loadMessages() async {
    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      final jsonStr = await rootBundle.loadString('assets/data/messages.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => MessageModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) { // Hata oluşursa yakalayıp uygulamanın patlamasını (çökmesini) engelliyoruz
      debugPrint('messages.json okuma hatası: $e');
      return [];
    }
  }
}
