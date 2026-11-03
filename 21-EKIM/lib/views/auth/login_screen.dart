import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../customer/customer_home_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../provider/provider_appointments_screen.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz

class LoginScreen extends StatelessWidget { // LoginScreen sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  const LoginScreen({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final authProvider = context.watch<AuthProvider>();
    final users = authProvider.users;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              const Text(
                'Randevu ve Hizmet Platformu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              const Text(
                'Lütfen test etmek istediğiniz kullanıcı hesabını seçiniz:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Kullanıcı Kartları
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: authProvider.isLoading
                    ? const Center(child: CircularProgressIndicator()) // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                    : ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
                        itemCount: users.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                        itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                          final user = users[index];
                          final isSelected = authProvider.currentUser?.id == user.id;

                          return Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                            elevation: 0, // Kartın arkasına gölge veriyoruz (z koordinatı)
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                              borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              onTap: () {
                                authProvider.switchUser(user);
                              },
                              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                                padding: const EdgeInsets.all(16),
                                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: user.isCustomer
                                          ? AppColors.primary.withAlpha(30)
                                          : AppColors.secondary.withAlpha(30),
                                      child: Icon(
                                        user.isCustomer
                                            ? Icons.person_outline
                                            : Icons.handyman_outlined,
                                        color: user.isCustomer
                                            ? AppColors.primary
                                            : AppColors.secondary,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                                        children: [
                                          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                            children: [
                                              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                                                child: Text(
                                                  user.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                                  color: user.isCustomer
                                                      ? AppColors.iWillComeBg
                                                      : AppColors.comeToMeBg,
                                                  borderRadius: BorderRadius.circular(6), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                                ),
                                                child: Text(
                                                  user.isCustomer ? 'MÜŞTERİ' : 'HİZMET VEREN',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: user.isCustomer
                                                        ? AppColors.iWillComeText
                                                        : AppColors.comeToMeText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                          Text(
                                            user.isCustomer
                                                ? 'Kayıtlı Adres: ${user.savedAddress ?? "Belirtilmedi"}'
                                                : 'Sektör: ${user.sector ?? "Genel"} • ${user.shopAddress ?? ""}',
                                            maxLines: 2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                            overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: isSelected ? AppColors.primary : AppColors.border,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Giriş Yap ve Uygulamaya Devam Et Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                  onPressed: authProvider.currentUser == null
                      ? null
                      : () {
                          final current = authProvider.currentUser!;
                          if (current.isCustomer) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const CustomerHomeScreen(),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const ProviderAppointmentsScreen(),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: authProvider.currentUser?.isCustomer ?? true
                        ? AppColors.primary
                        : AppColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    authProvider.currentUser?.isCustomer ?? true
                        ? 'Müşteri Olarak Başla'
                        : 'Hizmet Veren Olarak Başla',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
