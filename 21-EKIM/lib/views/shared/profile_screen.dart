import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:provider/provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart'; // Provider durum yönetimi kütüphanesini projeye dahil ediyoruz
import '../auth/login_screen.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

class ProfileScreen extends StatefulWidget { // ProfileScreen sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final bool isTab; // bool türünden isTab adlı değişkenimiz

  const ProfileScreen({super.key, this.isTab = false}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late final TextEditingController _addressController;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    final initialAddr = user?.isCustomer == true
        ? (user?.savedAddress ?? '')
        : (user?.shopAddress ?? '');
    _addressController = TextEditingController(text: initialAddr); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _addressController.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  void _saveAddress() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    if (user == null) return;

    final newAddr = _addressController.text.trim();
    if (user.isCustomer) {
      authProvider.updateSavedAddress(newAddr);
    } else {
      authProvider.updateShopAddress(newAddr);
    }

    ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
      const SnackBar(
        content: Text('Adres bilgisi güncellendi!'),
        backgroundColor: AppColors.approvedText,
      ),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Kullanıcı bulunamadı')), // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
      );
    }

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: AppColors.background,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text('Profil ve Hesap Ayarları'), // Sayfa başlığını ekrana yazdırıyoruz
        automaticallyImplyLeading: !widget.isTab,
      ),
      body: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
        padding: const EdgeInsets.all(16),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            // Kullanıcı Bilgi Kartı
            Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                padding: const EdgeInsets.all(16),
                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: user.isCustomer
                          ? AppColors.primary.withAlpha(25)
                          : AppColors.secondary.withAlpha(25),
                      child: Icon(
                        user.isCustomer ? Icons.person : Icons.handyman,
                        size: 32,
                        color: user.isCustomer ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Text(
                            user.phone,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // Adres Düzenleme Kartı
            Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                padding: const EdgeInsets.all(16),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      children: [
                        Icon(
                          user.isCustomer ? Icons.home_outlined : Icons.storefront_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Text(
                          user.isCustomer
                              ? 'Varsayılan Kayıtlı Adresim'
                              : 'Dükkan / Ofis Açık Adresi',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                      controller: _addressController,
                      maxLines: 3, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                      decoration: InputDecoration(
                        hintText: user.isCustomer
                            ? 'Örn: Kadıköy Moda Cad. No:18...'
                            : 'Örn: Üsküdar Selimiye Mah...',
                      ),
                    ),
                    const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                        onPressed: _saveAddress,
                        child: const Text('Adresi Güncelle'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // Kullanıcı / Rol Değiştirme
            const Text(
              'Hesap ve Mod Değiştir',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Card( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                children: authProvider.users.map<Widget>((u) {
                  final isCurrent = u.id == user.id;
                  return ListTile( // Başlık, alt başlık ve simgeleri hazır düzenli gösteren standart liste satırı widget'ı
                    leading: CircleAvatar(
                      backgroundColor: u.isCustomer
                          ? AppColors.primary.withAlpha(25)
                          : AppColors.secondary.withAlpha(25),
                      child: Icon(
                        u.isCustomer ? Icons.person_outline : Icons.handyman_outlined,
                        color: u.isCustomer ? AppColors.primary : AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    title: Text(u.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), // Sayfa başlığını ekrana yazdırıyoruz
                    subtitle: Text( // Sayfa başlığını ekrana yazdırıyoruz
                      u.isCustomer ? 'Müşteri Modu' : 'Hizmet Veren Modu',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: isCurrent
                        ? const Icon(Icons.check_circle, color: AppColors.approvedText)
                        : TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                            onPressed: () {
                              authProvider.switchUser(u);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text('Geçiş Yap'),
                          ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

            // Giriş Ekranına Dönüş / Çıkış Butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.cancelledText),
                label: const Text('Rol / Kullanıcı Seçim Ekranına Dön', style: TextStyle(color: AppColors.cancelledText)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.cancelledText),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
