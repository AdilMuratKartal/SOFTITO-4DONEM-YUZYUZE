class Dentist {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int experienceYears;
  final String imageUrl;
  final bool isAvailable;

  const Dentist({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experienceYears,
    required this.imageUrl,
    required this.isAvailable,
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
