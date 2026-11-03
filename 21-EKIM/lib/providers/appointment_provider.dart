import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../models/appointment_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../core/services/json_data_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz

class AppointmentProvider extends ChangeNotifier { // AppointmentProvider sınıfı, dinleyicilere değişiklik haberini yayan ChangeNotifier yapımızdır
  final JsonDataService dataService; // JsonDataService türünden dataService adlı değişkenimiz
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false; // Durum kontrolü için tuttuğumuz bool bayrağımız (_isLoading)

  AppointmentProvider({required this.dataService}); // dataService parametresinin verilmesinin zorunlu olduğunu söylüyoruz

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
  List<AppointmentModel> getByProvider(String providerId) { // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
    return _appointments.where((a) => a.providerId == providerId).toList(); // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
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
        return item.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
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
        return item.copyWith(status: newStatus); // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
      }
      return item;
    }).toList();
    notifyListeners();
  }
}
