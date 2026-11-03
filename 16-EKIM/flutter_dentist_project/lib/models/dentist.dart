class Dentist { // Dentist sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String name; // String türünden name adlı değişkenimiz
  final String specialty; // String türünden specialty adlı değişkenimiz
  final double rating; // double türünden rating adlı değişkenimiz
  final int experienceYears; // int türünden experienceYears adlı değişkenimiz
  final String imageUrl; // String türünden imageUrl adlı değişkenimiz
  final bool isAvailable; // bool türünden isAvailable adlı değişkenimiz

  const Dentist({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.name, // name parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.specialty, // specialty parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.rating, // rating parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.experienceYears, // experienceYears parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.imageUrl, // imageUrl parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isAvailable, // isAvailable parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });
}

final List<Dentist> dummyDentists = const [
  Dentist(
    id: '1',
    name: 'Dr. Ayşe Yılmaz',
    specialty: 'Ortodonti',
    rating: 4.9,
    experienceYears: 14,
    imageUrl: 'assets/images/dentist1.png',
    isAvailable: true,
  ),
  Dentist(
    id: '2',
    name: 'Dr. Mehmet Kaya',
    specialty: 'Endodonti',
    rating: 4.7,
    experienceYears: 10,
    imageUrl: 'assets/images/dentist2.png',
    isAvailable: true,
  ),
  Dentist(
    id: '3',
    name: 'Dr. Elif Demir',
    specialty: 'Pedodonti',
    rating: 4.8,
    experienceYears: 8,
    imageUrl: 'assets/images/dentist3.png',
    isAvailable: false,
  ),
  Dentist(
    id: '4',
    name: 'Dr. Can Özkan',
    specialty: 'Periodontoloji',
    rating: 4.6,
    experienceYears: 16,
    imageUrl: 'assets/images/dentist4.png',
    isAvailable: true,
  ),
  Dentist(
    id: '5',
    name: 'Dr. Selin Arslan',
    specialty: 'Ağız Cerrahisi',
    rating: 4.9,
    experienceYears: 12,
    imageUrl: 'assets/images/dentist5.png',
    isAvailable: true,
  ),
];
