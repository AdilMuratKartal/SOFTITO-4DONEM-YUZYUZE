import 'dentist.dart';
import 'treatment.dart';

enum AppointmentStatus {
  pending,    // Bekliyor
  confirmed,  // Onaylandı
  cancelled,  // İptal Edildi
  completed,  // Tamamlandı
}

class Appointment {
  final String id;
  final Dentist dentist;
  final Treatment treatment;
  final DateTime date;
  final String time;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.dentist,
    required this.treatment,
    required this.date,
    required this.time,
    required this.status,
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
