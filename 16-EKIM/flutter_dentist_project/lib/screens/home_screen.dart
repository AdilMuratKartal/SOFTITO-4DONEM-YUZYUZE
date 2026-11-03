import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../models/dentist.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../models/treatment.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../models/appointment.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class HomeScreen extends StatelessWidget { // HomeScreen sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const HomeScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
      physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
      padding: const EdgeInsets.only(bottom: 24),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildUpcomingAppointment(),
          _buildTreatmentCategories(),
          _buildTopDentists(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 1) Üst Başlık — Karşılama
  // ──────────────────────────────────────────
  Widget _buildHeader() {
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
      decoration: const BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        gradient: LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        children: [
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              children: const [
                Text(
                  'Merhaba, Kullanıcı 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Text(
                  'Bugün dişlerine bakmaya ne dersin?',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          // Profil avatarı
          Stack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
              Positioned( // Stack içindeki widget'ın konumunu (sol, sağ, üst, alt) piksel olarak ayarlamak için
                bottom: 0,
                right: 0,
                child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 2) Arama Çubuğu
  // ──────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: Colors.white,
          borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const TextField( // Kullanıcıdan metin girdisi almak için form alanı
          decoration: InputDecoration(
            hintText: 'Doktor veya tedavi ara...',
            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            border: InputBorder.none,
            icon: Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  // 3) Yaklaşan Randevu Kartı
  // ──────────────────────────────────────────
  Widget _buildUpcomingAppointment() {
    // İlk onaylanmış randevuyu göster
    final upcoming = dummyAppointments.firstWhere(
      (a) => a.status == AppointmentStatus.confirmed,
      orElse: () => dummyAppointments.first,
    );

    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          const Text(
            'Yaklaşan Randevunuz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0EA5E9).withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              children: [
                // Doktor ikonu
                Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  ),
                  child: const Icon(Icons.medical_services_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                // Bilgiler
                Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                  child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                    crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                    children: [
                      Text(
                        upcoming.dentist.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        upcoming.treatment.name,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // Tarih & saat
                Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.end, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    Text(
                      '${upcoming.date.day}/${upcoming.date.month}/${upcoming.date.year}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      ),
                      child: Text(
                        upcoming.time,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 4) Tedavi Kategorileri — Yatay Scroll
  // ──────────────────────────────────────────
  Widget _buildTreatmentCategories() {
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.only(top: 16),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          const Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tedavi Türleri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyTreatments.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              separatorBuilder: (_, __) => const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final t = dummyTreatments[index];
                return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                    mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                    children: [
                      Text(t.icon, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        t.name,
                        textAlign: TextAlign.center,
                        maxLines: 2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                        overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 5) Popüler Doktorlar Listesi
  // ──────────────────────────────────────────
  Widget _buildTopDentists() {
    final available = dummyDentists.where((d) => d.isAvailable).toList();

    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          const Text(
            'Popüler Doktorlar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          ...available.map((d) => _dentistCard(d)), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
        ],
      ),
    );
  }

  Widget _dentistCard(Dentist d) { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        children: [
          // Avatar
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFE0F2FE),
            child: Text(
              d.name.split(' ').last[0],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0EA5E9),
              ),
            ),
          ),
          const SizedBox(width: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          // Ad & uzmanlık
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              children: [
                Text(
                  d.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Text(
                  d.specialty,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          // Yıldız & deneyim
          Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            crossAxisAlignment: CrossAxisAlignment.end, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    d.rating.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Text(
                '${d.experienceYears} yıl',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
