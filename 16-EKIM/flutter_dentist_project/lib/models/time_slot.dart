class TimeSlot { // TimeSlot sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String time; // String türünden time adlı değişkenimiz
  final bool isAvailable; // bool türünden isAvailable adlı değişkenimiz

  const TimeSlot({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.time, // time parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isAvailable, // isAvailable parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });
}

final List<TimeSlot> dummyTimeSlots = const [
  TimeSlot(id: '1', time: '09:00', isAvailable: true),
  TimeSlot(id: '2', time: '09:30', isAvailable: true),
  TimeSlot(id: '3', time: '10:00', isAvailable: false),
  TimeSlot(id: '4', time: '10:30', isAvailable: true),
  TimeSlot(id: '5', time: '11:00', isAvailable: true),
  TimeSlot(id: '6', time: '11:30', isAvailable: false),
  TimeSlot(id: '7', time: '13:00', isAvailable: true),
  TimeSlot(id: '8', time: '13:30', isAvailable: true),
  TimeSlot(id: '9', time: '14:00', isAvailable: false),
  TimeSlot(id: '10', time: '14:30', isAvailable: true),
  TimeSlot(id: '11', time: '15:00', isAvailable: true),
  TimeSlot(id: '12', time: '15:30', isAvailable: true),
  TimeSlot(id: '13', time: '16:00', isAvailable: false),
  TimeSlot(id: '14', time: '16:30', isAvailable: true),
];
