import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../providers/listing_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../shared/widgets/location_badge.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import 'create_listing_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

class ProviderListingsScreen extends StatelessWidget { // ProviderListingsScreen sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final bool isTab; // bool türünden isTab adlı değişkenimiz

  const ProviderListingsScreen({super.key, this.isTab = false}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final authProvider = context.watch<AuthProvider>();
    final listingProvider = context.watch<ListingProvider>();
    final currentUser = authProvider.currentUser;

    final myListings = currentUser != null
        ? listingProvider.getByProvider(currentUser.id)
        : [];

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text('Müsaitlik ve Hizmet İlanlarım'), // Sayfa başlığını ekrana yazdırıyoruz
        automaticallyImplyLeading: !isTab,
      ),
      body: myListings.isEmpty
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
                      child: const Icon(Icons.storefront_outlined, size: 48, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    const Text(
                      'Henüz Yayında Bir İlanınız Yok',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    const Text(
                      'Müşterilerden randevu ve teklif alabilmek için çalışma saatlerinizi ve hizmetinizi yayınlayın.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
                          MaterialPageRoute(builder: (_) => const CreateListingScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Yeni İlan Aç'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
              padding: const EdgeInsets.all(16),
              itemCount: myListings.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final listing = myListings[index];

                return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                    padding: const EdgeInsets.all(14),
                    child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                      children: [
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                              child: Text(
                                listing.title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '${listing.basePrice.toStringAsFixed(0)} ₺',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(6), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              ),
                              child: Text(
                                listing.sector,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            LocationBadge(locationType: listing.locationType),
                          ],
                        ),
                        const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                              child: Text(
                                listing.shopAddress,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        const Text(
                          'Müsait Saat Dilimleri:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
                          spacing: 6,
                          runSpacing: 4,
                          children: listing.timeSlots.map<Widget>((slot) {
                            return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(6), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(slot, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
            MaterialPageRoute(builder: (_) => const CreateListingScreen()),
          );
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Yeni İlan Aç'),
      ),
    );
  }
}
