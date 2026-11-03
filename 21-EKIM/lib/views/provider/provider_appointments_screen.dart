import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../providers/appointment_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../shared/offer_form_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/chat_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/profile_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/conversations_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/widgets/status_badge.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../shared/widgets/location_badge.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import 'provider_listings_screen.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz

class ProviderAppointmentsScreen extends StatefulWidget { // ProviderAppointmentsScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final int initialIndex; // int türünden initialIndex adlı değişkenimiz

  const ProviderAppointmentsScreen({super.key, this.initialIndex = 0}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<ProviderAppointmentsScreen> createState() => _ProviderAppointmentsScreenState();
}

class _ProviderAppointmentsScreenState extends State<ProviderAppointmentsScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late int _currentIndex; // int türünden _currentIndex adlı değişkenimiz

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _currentIndex = widget.initialIndex;
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final List<Widget> pages = [
      const _ProviderAppointmentsTab(),
      const ProviderListingsScreen(isTab: true),
      const ConversationsScreen(isTab: true),
      const ProfileScreen(isTab: true),
    ];

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      body: IndexedStack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.secondary.withAlpha(30),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox, color: AppColors.secondary),
            label: 'Talepler',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: AppColors.secondary),
            label: 'İlanlarım',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: AppColors.secondary),
            label: 'Mesajlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.secondary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _ProviderAppointmentsTab extends StatelessWidget { // _ProviderAppointmentsTab sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const _ProviderAppointmentsTab();

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final authProvider = context.watch<AuthProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();
    final currentUser = authProvider.currentUser;

    final providerAppointments = currentUser != null // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
        ? appointmentProvider.getByProvider(currentUser.id)
        : [];

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            const Text('Gelen Talepler & Randevular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              'Aktif: ${currentUser?.name ?? "Hizmet Veren"}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: providerAppointments.isEmpty // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
          ? Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                padding: const EdgeInsets.all(24),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                  children: [
                    Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: AppColors.secondary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.inbox_outlined, size: 48, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    const Text(
                      'Henüz Gelen Randevu Talebi Yok',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    const Text(
                      'Müşteriler ilanlarınıza teklif verdiğinde talepler anlık olarak burada listelenecektir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
              padding: const EdgeInsets.all(16),
              itemCount: providerAppointments.length, // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final apt = providerAppointments[index]; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz

                return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    title: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      children: [
                        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                          child: Text(
                            apt.serviceTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${apt.offeredPrice.toStringAsFixed(0)} ₺',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                      padding: const EdgeInsets.only(top: 6),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        children: [
                          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                            child: Text(
                              'Müşteri: ${apt.customerName} • ${apt.appointmentDate} ${apt.appointmentTime}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ),
                          StatusBadge(status: apt.status),
                        ],
                      ),
                    ),
                    children: [
                      const Divider(color: AppColors.border), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
                      const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                      // Ulaşım ve Açık Adres
                      Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                              children: [
                                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                  children: [
                                    const Text('Hizmet Konumu: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    LocationBadge(locationType: apt.locationType),
                                  ],
                                ),
                                const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                Text(
                                  apt.address,
                                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                      if (apt.description.isNotEmpty) ...[
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                          children: [
                            const Icon(Icons.notes_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                              child: Text(
                                'Müşteri Notu: ${apt.description}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      ],

                      const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                      // Hizmet Veren Yönetim Butonları (Wrap ile taşma korumalı)
                      Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (apt.status == 'beklemede') ...[
                            ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                              onPressed: () {
                                appointmentProvider.updateStatus(apt.id, 'onaylandi');
                                ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                                  const SnackBar(
                                    content: Text('Randevu başarıyla onaylandı! Saat rezerve edildi.'),
                                    backgroundColor: AppColors.approvedText,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.approvedText,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('Onayla', style: TextStyle(fontSize: 12)),
                            ),
                            OutlinedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                              onPressed: () {
                                Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
                                  MaterialPageRoute(
                                    builder: (_) => OfferFormScreen(
                                      existingAppointment: apt,
                                      isCounterOffer: true,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.secondary),
                                foregroundColor: AppColors.secondary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('Karşı Teklif Sun', style: TextStyle(fontSize: 12)),
                            ),
                            OutlinedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                              onPressed: () {
                                appointmentProvider.updateStatus(apt.id, 'iptal');
                                ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                                  const SnackBar(
                                    content: Text('Randevu talebi reddedildi/iptal edildi.'),
                                    backgroundColor: AppColors.cancelledText,
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.cancelledText),
                                foregroundColor: AppColors.cancelledText,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('İptal Et', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                          if (apt.status == 'onaylandi') ...[
                            ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                              onPressed: () {
                                appointmentProvider.updateStatus(apt.id, 'bitti');
                                ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                                  const SnackBar(
                                    content: Text('Hizmet tamamlandı olarak işaretlendi.'),
                                    backgroundColor: AppColors.completedText,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.completedText,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('İşi Tamamla (Bitti)', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(appointment: apt),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline, size: 14),
                            label: const Text('Mesajlaş', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
