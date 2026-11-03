class Treatment { // Treatment sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String name; // String türünden name adlı değişkenimiz
  final String icon; // String türünden icon adlı değişkenimiz
  final int durationMinutes; // int türünden durationMinutes adlı değişkenimiz
  final double price; // double türünden price adlı değişkenimiz

  const Treatment({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.name, // name parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.icon, // icon parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.durationMinutes, // durationMinutes parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.price, // price parametresinin verilmesinin zorunlu olduğunu söylüyoruz
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
