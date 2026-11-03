import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../providers/appointment_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../shared/offer_form_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/chat_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/widgets/status_badge.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../shared/widgets/location_badge.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

class CustomerAppointmentsScreen extends StatelessWidget { // CustomerAppointmentsScreen sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final bool isTab; // bool türünden isTab adlı değişkenimiz

  const CustomerAppointmentsScreen({super.key, this.isTab = false}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final authProvider = context.watch<AuthProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();
    final currentUser = authProvider.currentUser;

    final customerAppointments = currentUser != null
        ? appointmentProvider.getByCustomer(currentUser.id)
        : [];

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text('Randevularım ve Tekliflerim'), // Sayfa başlığını ekrana yazdırıyoruz
        automaticallyImplyLeading: !isTab,
      ),
      body: customerAppointments.isEmpty
          ? Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                padding: const EdgeInsets.all(24),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                  children: [
                    Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: AppColors.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calendar_month_outlined, size: 48, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    const Text(
                      'Aktif Randevunuz Bulunmuyor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    const Text(
                      'İlanlar sekmesinden kuaför, tesisatçı veya öğretmen ilanlarını inceleyip teklif oluşturabilirsiniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
              padding: const EdgeInsets.all(16),
              itemCount: customerAppointments.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final apt = customerAppointments[index];

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
                              '${apt.providerName} • ${apt.appointmentDate} ${apt.appointmentTime}', // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
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
                                    const Text(
                                      'Hizmet Yeri: ',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
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

                      // Açıklama / Not
                      if (apt.description.isNotEmpty) ...[
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                          children: [
                            const Icon(Icons.notes_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                              child: Text(
                                'Açıklama: ${apt.description}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      ],

                      // Karşı Teklif Uyarısı
                      if (apt.status == 'beklemede' && apt.lastOfferBy == 'provider') ...[ // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
                        Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: AppColors.pendingBg,
                            borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            border: Border.all(color: AppColors.pendingText.withAlpha(60)),
                          ),
                          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            children: [
                              const Icon(Icons.info_outline, color: AppColors.pendingText, size: 18),
                              const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                                child: Text(
                                  'Hizmet veren yeni bir fiyat/saat karşı teklifi sundu! (${apt.offeredPrice.toStringAsFixed(0)} ₺)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.pendingText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                      // Taşmaları Önleyen Wrap Aksiyon Butonları
                      Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (apt.status == 'beklemede' && apt.lastOfferBy == 'provider') ...[ // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
                            ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                              onPressed: () {
                                appointmentProvider.updateStatus(apt.id, 'onaylandi');
                                ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                                  const SnackBar(
                                    content: Text('Karşı teklifi onayladınız! Randevu kesinleşti.'),
                                    backgroundColor: AppColors.approvedText,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.approvedText,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text('Kabul Et (Onayla)', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                          if (apt.status == 'beklemede') ...[
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
                              child: const Text('Tekrar Teklif Ver', style: TextStyle(fontSize: 12)),
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
                            label: const Text('Mesaj Gönder', style: TextStyle(fontSize: 12)),
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
