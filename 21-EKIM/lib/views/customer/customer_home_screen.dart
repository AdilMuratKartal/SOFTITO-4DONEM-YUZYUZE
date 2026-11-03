import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../providers/listing_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../shared/offer_form_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/profile_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/conversations_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../shared/widgets/location_badge.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import 'customer_appointments_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

class CustomerHomeScreen extends StatefulWidget { // CustomerHomeScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final int initialIndex; // int türünden initialIndex adlı değişkenimiz

  const CustomerHomeScreen({super.key, this.initialIndex = 0}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late int _currentIndex; // int türünden _currentIndex adlı değişkenimiz

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _currentIndex = widget.initialIndex;
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final List<Widget> pages = [
      const _CustomerExploreTab(),
      const CustomerAppointmentsScreen(isTab: true),
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
        indicatorColor: AppColors.primary.withAlpha(30),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore, color: AppColors.primary),
            label: 'Keşfet',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month, color: AppColors.primary),
            label: 'Randevularım',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: AppColors.primary),
            label: 'Mesajlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _CustomerExploreTab extends StatelessWidget { // _CustomerExploreTab sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const _CustomerExploreTab();

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final authProvider = context.watch<AuthProvider>();
    final listingProvider = context.watch<ListingProvider>();
    final currentUser = authProvider.currentUser;
    final listings = listingProvider.filteredListings;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            const Text(
              'Hizmet & Randevu Keşfet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Aktif: ${currentUser?.name ?? "Müşteri"}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          children: [
            // Sektör Filtreleri Yatay Listesi
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: AppConstants.sectors.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                separatorBuilder: (_, _) => const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                  final sector = AppConstants.sectors[index];
                  final isSelected = listingProvider.selectedSector == sector;
                  return ChoiceChip(
                    label: Text(sector),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    onSelected: (_) => listingProvider.setSectorFilter(sector),
                  );
                },
              ),
            ),

            // Ulaşım / Konum Filtreleri (Ben Geleyim / Sen Gel)
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              height: 42,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: AppConstants.locationFilters.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                separatorBuilder: (_, _) => const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                  final loc = AppConstants.locationFilters[index];
                  final isSelected = listingProvider.selectedLocationFilter == loc;
                  return FilterChip(
                    label: Text(loc),
                    selected: isSelected,
                    selectedColor: AppColors.secondary.withAlpha(40),
                    checkmarkColor: AppColors.secondary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.secondary : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    onSelected: (_) => listingProvider.setLocationFilter(loc),
                  );
                },
              ),
            ),
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // İlan Listesi
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: listingProvider.isLoading
                  ? const Center(child: CircularProgressIndicator()) // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                  : listings.isEmpty
                      ? const Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                          child: Text(
                            'Seçili filtrelere uygun ilan bulunamadı.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: listings.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                          itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                            final listing = listings[index];

                            return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                                padding: const EdgeInsets.all(14),
                                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                                  children: [
                                    Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                                      children: [
                                        Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                            color: AppColors.primary.withAlpha(20),
                                            borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                          ),
                                          child: const Icon(
                                            Icons.handyman_outlined,
                                            color: AppColors.primary,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                                          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                                            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                                            children: [
                                              Text(
                                                listing.title,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                              Text(
                                                '${listing.providerName} • ${listing.sector}', // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
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
                                    const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                      children: [
                                        const Icon(Icons.location_pin, size: 14, color: AppColors.textSecondary),
                                        const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                                          child: Text(
                                            listing.district,
                                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                        ),
                                        LocationBadge(locationType: listing.locationType),
                                      ],
                                    ),
                                    const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: listing.timeSlots.take(4).map<Widget>((slot) {
                                        return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.circular(6), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                            border: Border.all(color: AppColors.border),
                                          ),
                                          child: Text(
                                            slot,
                                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                                        onPressed: () {
                                          Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
                                            MaterialPageRoute(
                                              builder: (_) => OfferFormScreen(listing: listing),
                                            ),
                                          );
                                        },
                                        child: const Text('Teklif Ver & Randevu Al'),
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
      ),
    );
  }
}
