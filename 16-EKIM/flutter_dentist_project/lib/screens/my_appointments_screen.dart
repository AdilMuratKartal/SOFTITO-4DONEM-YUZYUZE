import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../models/appointment.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class MyAppointmentsScreen extends StatefulWidget { // MyAppointmentsScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const MyAppointmentsScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // TabController türünden _tabController adlı değişkenimiz

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _tabController = TabController(length: 3, vsync: this);
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _tabController.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  List<Appointment> _filterByStatuses(List<AppointmentStatus> statuses) {
    return dummyAppointments
        .where((a) => statuses.contains(a.status))
        .toList();
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      children: [
        _buildHeader(),
        _buildTabBar(),
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentList(
                _filterByStatuses([
                  AppointmentStatus.confirmed,
                  AppointmentStatus.pending,
                ]),
                emptyMessage: 'Aktif randevunuz bulunmuyor.',
              ),
              _buildAppointmentList(
                _filterByStatuses([AppointmentStatus.completed]),
                emptyMessage: 'Tamamlanmış randevunuz yok.',
              ),
              _buildAppointmentList(
                _filterByStatuses([AppointmentStatus.cancelled]),
                emptyMessage: 'İptal edilen randevu yok.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────
  // 1) Üst Başlık
  // ──────────────────────────────────────────
  Widget _buildHeader() {
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
      color: const Color(0xFFF8FAFC),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
        children: [
          const Text(
            'Randevularım',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            ),
            child: Text(
              '${dummyAppointments.length} kayıt',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0EA5E9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 2) Tab Bar — Aktif / Tamamlanan / İptal
  // ──────────────────────────────────────────
  Widget _buildTabBar() {
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: const Color(0xFF0EA5E9),
        unselectedLabelColor: const Color(0xFF94A3B8),
        labelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Aktif'),
          Tab(text: 'Tamamlanan'),
          Tab(text: 'İptal'),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // 3) Randevu Listesi
  // ──────────────────────────────────────────
  Widget _buildAppointmentList(
    List<Appointment> appointments, {
    required String emptyMessage,
  }) {
    if (appointments.isEmpty) {
      return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
          children: [
            const Icon(Icons.event_busy_rounded,
                size: 64, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: appointments.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
      separatorBuilder: (_, __) => const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
      itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
        return _appointmentCard(appointments[index]); // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
      },
    );
  }

  // ──────────────────────────────────────────
  // 4) Tek Randevu Kartı
  // ──────────────────────────────────────────
  Widget _appointmentCard(Appointment appt) { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    final statusInfo = _statusStyle(appt.status);

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: Colors.white,
        borderRadius: BorderRadius.circular(18), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        children: [
          // Üst: Doktor bilgisi + durum badge
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE0F2FE),
                child: Text(
                  appt.dentist.name.split(' ').last[0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0EA5E9),
                  ),
                ),
              ),
              const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    Text(
                      appt.dentist.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Text(
                      appt.dentist.specialty,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: statusInfo.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                ),
                child: Text(
                  statusInfo.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusInfo.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          // Divider
          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            height: 1,
            color: const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          // Alt: Tedavi, tarih, saat
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: [
              _infoChip(Icons.medical_services_outlined,
                  appt.treatment.name),
              const Spacer(),
              _infoChip(Icons.calendar_today_rounded,
                  '${appt.date.day}/${appt.date.month}/${appt.date.year}'),
              const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              _infoChip(Icons.access_time_rounded, appt.time),
            ],
          ),
          // İptal / Yeniden planla butonları (aktif randevularda)
          if (appt.status == AppointmentStatus.confirmed ||
              appt.status == AppointmentStatus.pending) ...[
            const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              children: [
                Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                  child: OutlinedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                        const SnackBar(
                          content: Text('Randevu iptal edildi.'),
                          backgroundColor: Color(0xFFEF4444),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('İptal Et',
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                  child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                        const SnackBar(
                          content: Text('Yeniden planlama açıldı.'),
                          backgroundColor: Color(0xFF0EA5E9),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0, // Kartın arkasına gölge veriyoruz (z koordinatı)
                    ),
                    child: const Text('Yeniden Planla',
                        style:
                            TextStyle(fontSize: 13, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  _StatusStyle _statusStyle(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return _StatusStyle('Onaylandı', const Color(0xFF22C55E));
      case AppointmentStatus.pending:
        return _StatusStyle('Bekliyor', const Color(0xFFF59E0B));
      case AppointmentStatus.cancelled:
        return _StatusStyle('İptal', const Color(0xFFEF4444));
      case AppointmentStatus.completed:
        return _StatusStyle('Tamamlandı', const Color(0xFF6366F1));
    }
  }
}

class _StatusStyle {
  final String label; // String türünden label adlı değişkenimiz
  final Color color; // Color türünden color adlı değişkenimiz
  const _StatusStyle(this.label, this.color); // label alanına değer aktarıyoruz
}
