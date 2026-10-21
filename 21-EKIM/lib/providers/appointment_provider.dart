import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../core/services/json_data_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final JsonDataService dataService;
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;

  AppointmentProvider({required this.dataService});

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _appointments = await dataService.loadAppointments();
    _isLoading = false;
    notifyListeners();
  }

  /// Müşteriye ait randevuları listele
  List<AppointmentModel> getByCustomer(String customerId) {
    return _appointments.where((a) => a.customerId == customerId).toList();
  }

  /// Hizmet verene gelen randevu ve talepleri listele
  List<AppointmentModel> getByProvider(String providerId) {
    return _appointments.where((a) => a.providerId == providerId).toList();
  }

  /// Belirli bir ilanda ve tarihte belirli bir saat dilimi dolu mu kontrol et
  bool isSlotBooked(String listingId, String date, String time) {
    return _appointments.any((a) =>
        a.listingId == listingId &&
        a.appointmentDate == date &&
        a.appointmentTime == time &&
        a.status == 'onaylandi');
  }

  /// Yeni randevu talebi / ilk teklif
  void createOffer(AppointmentModel newAppointment) {
    _appointments = [newAppointment, ..._appointments];
    notifyListeners();
  }

  /// Karşı teklif gönderme (Fiyat ve/veya saat revizesi)
  void submitCounterOffer({
    required String appointmentId,
    required double newPrice,
    required String newTime,
    required String counterOfferBy, // 'customer' veya 'provider'
  }) {
    _appointments = _appointments.map((item) {
      if (item.id == appointmentId) {
        return item.copyWith(
          offeredPrice: newPrice,
          appointmentTime: newTime,
          status: 'beklemede',
          lastOfferBy: counterOfferBy,
        );
      }
      return item;
    }).toList();
    notifyListeners();
  }

  /// Randevu durumu güncelleme ('onaylandi', 'iptal', 'bitti')
  void updateStatus(String appointmentId, String newStatus) {
    _appointments = _appointments.map((item) {
      if (item.id == appointmentId) {
        return item.copyWith(status: newStatus);
      }
      return item;
    }).toList();
    notifyListeners();
  }
}
