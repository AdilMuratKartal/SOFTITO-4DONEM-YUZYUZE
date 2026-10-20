class Treatment {
  final String id;
  final String name;
  final String icon;
  final int durationMinutes;
  final double price;

  const Treatment({
    required this.id,
    required this.name,
    required this.icon,
    required this.durationMinutes,
    required this.price,
  });
}

final List<Treatment> dummyTreatments = const [
  Treatment(
    id: '1',
    name: 'Diş Beyazlatma',
    icon: '✨',
    durationMinutes: 60,
    price: 3500.0,
  ),
  Treatment(
    id: '2',
    name: 'Kanal Tedavisi',
    icon: '🦷',
    durationMinutes: 90,
    price: 4000.0,
  ),
  Treatment(
    id: '3',
    name: 'Dolgu',
    icon: '🔧',
    durationMinutes: 30,
    price: 1500.0,
  ),
  Treatment(
    id: '4',
    name: 'Diş Çekimi',
    icon: '🩺',
    durationMinutes: 45,
    price: 2000.0,
  ),
  Treatment(
    id: '5',
    name: 'Diş Taşı Temizliği',
    icon: '🪥',
    durationMinutes: 30,
    price: 1000.0,
  ),
  Treatment(
    id: '6',
    name: 'İmplant',
    icon: '🏥',
    durationMinutes: 120,
    price: 15000.0,
  ),
];
