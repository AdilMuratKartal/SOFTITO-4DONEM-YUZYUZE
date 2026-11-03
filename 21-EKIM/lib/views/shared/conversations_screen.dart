import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../providers/appointment_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../providers/chat_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import 'chat_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import 'widgets/status_badge.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

class ConversationsScreen extends StatelessWidget { // ConversationsScreen sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final bool isTab; // bool türünden isTab adlı değişkenimiz

  const ConversationsScreen({super.key, this.isTab = false}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final authProvider = context.watch<AuthProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();
    final chatProvider = context.watch<ChatProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Kullanıcı oturumu bulunamadı')), // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
      );
    }

    final userAppointments = currentUser.isCustomer
        ? appointmentProvider.getByCustomer(currentUser.id)
        : appointmentProvider.getByProvider(currentUser.id);

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text('Mesajlar ve Sohbetler'), // Sayfa başlığını ekrana yazdırıyoruz
        automaticallyImplyLeading: !isTab,
      ),
      body: userAppointments.isEmpty
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
                      child: const Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    const Text(
                      'Henüz Aktif Sohbetiniz Yok',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    const Text(
                      'Randevu veya teklif oluşturduğunuzda taraflarla buradan doğrudan mesajlaşabilirsiniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: userAppointments.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              separatorBuilder: (_, _) => const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final apt = userAppointments[index];
                final messages = chatProvider.getMessagesByAppointment(apt.id);
                final lastMsg = messages.isNotEmpty ? messages.last : null;

                final otherPartyName = currentUser.isCustomer ? apt.providerName : apt.customerName; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz

                return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  margin: EdgeInsets.zero,
                  child: InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                    borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    onTap: () {
                      Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(appointment: apt),
                        ),
                      );
                    },
                    child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                      padding: const EdgeInsets.all(14),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: currentUser.isCustomer
                                ? AppColors.secondary.withAlpha(25)
                                : AppColors.primary.withAlpha(25),
                            child: Icon(
                              currentUser.isCustomer ? Icons.handyman_outlined : Icons.person_outline,
                              color: currentUser.isCustomer ? AppColors.secondary : AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                              children: [
                                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                  children: [
                                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                                      child: Text(
                                        otherPartyName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (lastMsg != null)
                                      Text(
                                        lastMsg.timestamp,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                Text(
                                  apt.serviceTitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                Text(
                                  lastMsg?.message ?? 'Sohbeti başlatmak için dokunun...',
                                  maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                  overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: lastMsg != null ? AppColors.textSecondary : AppColors.secondary,
                                    fontStyle: lastMsg != null ? FontStyle.normal : FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          StatusBadge(status: apt.status),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
