import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../models/dentist.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../models/treatment.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../models/time_slot.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class BookAppointmentScreen extends StatefulWidget { // BookAppointmentScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const BookAppointmentScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  int _selectedDentistIndex = 0; // int türünden _selectedDentistIndex değişkenimiz
  int _selectedTreatmentIndex = -1; // int türünden _selectedTreatmentIndex değişkenimiz
  int _selectedTimeIndex = -1; // int türünden _selectedTimeIndex değişkenimiz
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
      physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
      padding: const EdgeInsets.only(bottom: 32),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          _buildAppBar(),
          _buildStepIndicator(),
          _buildDentistSelector(),
          _buildTreatmentSelector(),
          _buildDateSelector(),
          _buildTimeSlotGrid(),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 1) Üst Bar
  // ──────────────────────────────────────────
  Widget _buildAppBar() {
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      color: const Color(0xFFF8FAFC),
      child: const Text(
        'Randevu Al',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  // 2) Adım Göstergesi
  // ──────────────────────────────────────────
  Widget _buildStepIndicator() {
    int currentStep = 0; // int türünden currentStep değişkenimiz
    if (_selectedDentistIndex >= 0) currentStep = 1;
    if (_selectedTreatmentIndex >= 0) currentStep = 2;
    if (_selectedTimeIndex >= 0) currentStep = 3;

    final steps = ['Doktor', 'Tedavi', 'Tarih & Saat'];

    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        children: List.generate(steps.length, (i) {
          final isActive = i < currentStep;
          final isCurrent = i == currentStep;
          return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              children: [
                Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: isActive
                        ? const Color(0xFF0EA5E9)
                        : isCurrent
                            ? const Color(0xFFE0F2FE)
                            : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                    child: isActive
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? const Color(0xFF0EA5E9)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Flexible(
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      color: isActive || isCurrent
                          ? const Color(0xFF1E293B)
                          : const Color(0xFF94A3B8),
                    ),
                    overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                  ),
                ),
                if (i < steps.length - 1)
                  Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      height: 1,
                      width: 16,
                      color: isActive
                          ? const Color(0xFF0EA5E9)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────────────────────────────
  // 3) Doktor Seçimi — Yatay Kartlar
  // ──────────────────────────────────────────
  Widget _buildDentistSelector() {
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.only(top: 8),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          const Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Doktor Seçin',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyDentists.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              separatorBuilder: (_, __) => const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final d = dummyDentists[index];
                final isSelected = _selectedDentistIndex == index;
                return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                  onTap: d.isAvailable
                      ? () => setState(() => _selectedDentistIndex = index) // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                      : null,
                  child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                    duration: const Duration(milliseconds: 200),
                    width: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                      color: !d.isAvailable
                          ? const Color(0xFFF1F5F9)
                          : isSelected
                              ? const Color(0xFF0EA5E9)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0EA5E9)
                            : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0EA5E9).withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                      mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isSelected
                              ? Colors.white24
                              : const Color(0xFFE0F2FE),
                          child: Icon(
                            Icons.person,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF0EA5E9),
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Text(
                          d.name.replaceFirst('Dr. ', ''),
                          textAlign: TextAlign.center,
                          maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                          overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: !d.isAvailable
                                ? const Color(0xFF94A3B8)
                                : isSelected
                                    ? Colors.white
                                    : const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Text(
                          d.isAvailable ? d.specialty : 'Müsait Değil',
                          style: TextStyle(
                            fontSize: 10,
                            color: !d.isAvailable
                                ? const Color(0xFFCBD5E1)
                                : isSelected
                                    ? Colors.white70
                                    : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
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
  // 4) Tedavi Seçimi — Chip Listesi
  // ──────────────────────────────────────────
  Widget _buildTreatmentSelector() {
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          const Text(
            'Tedavi Seçin',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
            spacing: 10,
            runSpacing: 10,
            children: List.generate(dummyTreatments.length, (index) {
              final t = dummyTreatments[index];
              final isSelected = _selectedTreatmentIndex == index;
              return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                onTap: () =>
                    setState(() => _selectedTreatmentIndex = index), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: isSelected
                        ? const Color(0xFF0EA5E9)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0EA5E9)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        t.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        '₺${t.price.toInt()}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white70
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 5) Tarih Seçimi — Yatay Gün Listesi
  // ──────────────────────────────────────────
  Widget _buildDateSelector() {
    final days = List.generate(
        14, (i) => DateTime.now().add(Duration(days: i + 1)));
    const dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.only(top: 20),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          const Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tarih Seçin',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: days.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              separatorBuilder: (_, __) => const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final day = days[index];
                final isSelected = _selectedDate.day == day.day &&
                    _selectedDate.month == day.month;
                final isWeekend = day.weekday == 6 || day.weekday == 7;
                return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                  onTap: isWeekend
                      ? null
                      : () => setState(() => _selectedDate = day), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                  child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                      color: isWeekend
                          ? const Color(0xFFF1F5F9)
                          : isSelected
                              ? const Color(0xFF0EA5E9)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0EA5E9)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                      mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        Text(
                          dayNames[day.weekday - 1],
                          style: TextStyle(
                            fontSize: 11,
                            color: isWeekend
                                ? const Color(0xFFCBD5E1)
                                : isSelected
                                    ? Colors.white70
                                    : const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isWeekend
                                ? const Color(0xFFCBD5E1)
                                : isSelected
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
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
  // 6) Saat Seçimi — Grid
  // ──────────────────────────────────────────
  Widget _buildTimeSlotGrid() {
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          const Text(
            'Saat Seçin',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          GridView.builder( // Elemanları ızgara (grid) düzeninde performanslı şekilde listelemek için kullanıyoruz
            shrinkWrap: true, // Listenin sadece elemanları kadar yer kaplamasını sağlıyoruz, taşmasın diye
            physics: const NeverScrollableScrollPhysics(), // Kendi içinde kaydırılmasını engelleyip dıştaki kaydırıcıya bırakıyoruz
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: dummyTimeSlots.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
            itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
              final slot = dummyTimeSlots[index];
              final isSelected = _selectedTimeIndex == index;
              return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                onTap: slot.isAvailable
                    ? () => setState(() => _selectedTimeIndex = index) // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                    : null,
                child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: !slot.isAvailable
                        ? const Color(0xFFF1F5F9)
                        : isSelected
                            ? const Color(0xFF0EA5E9)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    border: Border.all(
                      color: !slot.isAvailable
                          ? const Color(0xFFE2E8F0)
                          : isSelected
                              ? const Color(0xFF0EA5E9)
                              : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                    child: Text(
                      slot.time,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: !slot.isAvailable
                            ? const Color(0xFFCBD5E1)
                            : isSelected
                                ? Colors.white
                                : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 7) Onayla Butonu
  // ──────────────────────────────────────────
  Widget _buildConfirmButton() {
    final isReady = _selectedDentistIndex >= 0 &&
        _selectedTreatmentIndex >= 0 &&
        _selectedTimeIndex >= 0;

    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
          onPressed: isReady
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                    const SnackBar(
                      content: Text('Randevunuz başarıyla oluşturuldu! ✅'),
                      backgroundColor: Color(0xFF22C55E),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0EA5E9),
            disabledBackgroundColor: const Color(0xFFE2E8F0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            ),
            elevation: isReady ? 4 : 0, // Kartın arkasına gölge veriyoruz (z koordinatı)
            shadowColor: const Color(0xFF0EA5E9).withOpacity(0.3),
          ),
          child: Text(
            isReady ? 'Randevuyu Onayla' : 'Lütfen Seçimlerinizi Tamamlayın',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isReady ? Colors.white : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }
}
