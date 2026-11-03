import 'dentist.dart';
import 'treatment.dart';

enum AppointmentStatus { // AppointmentStatus enum yapısı, belirli sabit seçenekleri tip güvenli şekilde listelememizi sağlar
  pending,    // Bekliyor
  confirmed,  // Onaylandı
  cancelled,  // İptal Edildi
  completed,  // Tamamlandı
}

class Appointment { // Appointment sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final Dentist dentist; // Dentist türünden dentist adlı değişkenimiz
  final Treatment treatment; // Treatment türünden treatment adlı değişkenimiz
  final DateTime date; // DateTime türünden date adlı değişkenimiz
  final String time; // String türünden time adlı değişkenimiz
  final AppointmentStatus status; // AppointmentStatus türünden status adlı değişkenimiz

  const Appointment({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.dentist, // dentist parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.treatment, // treatment parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.date, // date parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.time, // time parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.status, // status parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });
}

final List<Appointment> dummyAppointments = [
  Appointment(
    id: '1',
    dentist: dummyDentists[0],
    treatment: dummyTreatments[0],
    date: DateTime(2026, 10, 18),
    time: '10:30',
    status: AppointmentStatus.confirmed,
  ),
  Appointment(
    id: '2',
    dentist: dummyDentists[1],
    treatment: dummyTreatments[1],
    date: DateTime(2026, 10, 20),
    time: '14:00',
    status: AppointmentStatus.pending,
  ),
  Appointment(
    id: '3',
    dentist: dummyDentists[3],
    treatment: dummyTreatments[4],
    date: DateTime(2026, 10, 12),
    time: '09:00',
    status: AppointmentStatus.completed,
  ),
  Appointment(
    id: '4',
    dentist: dummyDentists[4],
    treatment: dummyTreatments[2],
    date: DateTime(2026, 10, 15),
    time: '11:00',
    status: AppointmentStatus.cancelled,
  ),
];
