import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/app_theme.dart';
import '../../../core/services/notification_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz

class ProfileView extends StatefulWidget { // ProfileView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final ValueNotifier<ThemeMode> themeModeNotifier; // ValueNotifier<ThemeMode> türünden themeModeNotifier adlı değişkenimiz

  const ProfileView({super.key, required this.themeModeNotifier}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  bool _notificationsEnabled = true; // Durum kontrolü için tuttuğumuz bool bayrağımız (_notificationsEnabled)

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text('Profil & Başarılar'), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              // Profil Başlığı
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: const Icon(Icons.person, color: AppColors.primary, size: 32),
                    ),
                    const SizedBox(width: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            children: [
                              Text(
                                'Kullanıcı',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                                ),
                              ),
                              const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                  color: AppColors.secondary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                ),
                                child: const Text(
                                  '🌟 Kıdemli İradeci',
                                  style: TextStyle(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Text(
                            'Seviye 4 • Toplam 1.420 XP',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Seviye İlerleme Çubuğu
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  children: [
                    Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        Text(
                          'Seviye 4 (420 / 500 XP)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.onSurface : AppColors.textLight,
                          ),
                        ),
                        const Text(
                          'Seviye 5\'e 80 XP Kaldı',
                          style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      child: LinearProgressIndicator(
                        value: 0.84,
                        minHeight: 8,
                        backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Rozetler Vitrini
              Text(
                'Rozetler Vitrini',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              GridView.count(
                shrinkWrap: true, // Listenin sadece elemanları kadar yer kaplamasını sağlıyoruz, taşmasın diye
                physics: const NeverScrollableScrollPhysics(), // Kendi içinde kaydırılmasını engelleyip dıştaki kaydırıcıya bırakıyoruz
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
                children: [
                  _buildBadgeCard('💧 Su Savaşçısı', '7 Gün 2L/gün', true, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  _buildBadgeCard('📖 Kitap Kurdu', '30 Gün Kesintisiz', true, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  _buildBadgeCard('🧘 Zihin Ustası', '10 Nefes Seansı', true, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  _buildBadgeCard('🏃 Maratoncu', '10 Koşu Tamamla', true, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  _buildBadgeCard('🎯 Odak Ustası', '25 Pomodoro', false, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  _buildBadgeCard('❄️ Buz Adam', '14 Gün Soğuk Duş', false, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                ],
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Uygulama Ayarları
              Text(
                'Uygulama Ayarları',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Material(
                color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  side: BorderSide(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  children: [
                    SwitchListTile( // Başlık, alt başlık ve simgeleri hazır düzenli gösteren standart liste satırı widget'ı
                      title: Text( // Sayfa başlığını ekrana yazdırıyoruz
                        'Günlük Hatırlatıcı Bildirimler',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.onSurface : AppColors.textLight,
                        ),
                      ),
                      subtitle: Text( // Sayfa başlığını ekrana yazdırıyoruz
                        _notificationsEnabled ? 'Aktif (Saatinde hatırlatma yapar)' : 'Kapalı',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                        ),
                      ),
                      value: _notificationsEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) async {
                        setState(() => _notificationsEnabled = val); // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                        if (val) {
                          await NotificationService.requestPermissions();
                        } else {
                          await NotificationService.cancelAllNotifications();
                        }
                      },
                    ),
                    if (_notificationsEnabled) ...[
                      Divider(height: 1, color: isDark ? AppColors.outlineVariant : AppColors.borderLight), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
                      ListTile( // Başlık, alt başlık ve simgeleri hazır düzenli gösteren standart liste satırı widget'ı
                        leading: const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 22),
                        title: Text( // Sayfa başlığını ekrana yazdırıyoruz
                          'Anlık Test Bildirimi Gönder',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.onSurface : AppColors.textLight,
                          ),
                        ),
                        subtitle: Text( // Sayfa başlığını ekrana yazdırıyoruz
                          'Cihazınıza anlık test bildirimi gönderir',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                          ),
                        ),
                        trailing: const Icon(Icons.send_rounded, size: 18, color: AppColors.primary),
                        onTap: () async {
                          final success = await NotificationService.showInstantNotification(
                            title: '🔔 Test Bildirimi: Alışkanlık Takibi',
                            body: 'Harika! Bildirim sistemi başarıyla çalışıyor ve aktif.',
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında kullanıcıya bilgi veren kısa SnackBar mesajı gösteriyoruz
                              SnackBar(
                                backgroundColor: success ? AppColors.primary : AppColors.danger,
                                content: Text(
                                  success
                                      ? '✓ Test bildirimi cihaza gönderildi!'
                                      : 'Bildirim gönderilemedi. Lütfen sistem izinlerini kontrol edin.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: success ? AppColors.onPrimary : Colors.white,
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                    Divider(height: 1, color: isDark ? AppColors.outlineVariant : AppColors.borderLight), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
                    ValueListenableBuilder<ThemeMode>(
                      valueListenable: widget.themeModeNotifier,
                      builder: (context, mode, _) {
                        return SwitchListTile( // Başlık, alt başlık ve simgeleri hazır düzenli gösteren standart liste satırı widget'ı
                          title: Text( // Sayfa başlığını ekrana yazdırıyoruz
                            'Karanlık Mod (Mindful Emerald)',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.onSurface : AppColors.textLight,
                            ),
                          ),
                          value: mode == ThemeMode.dark,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            widget.themeModeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCard(String title, String subtitle, bool isUnlocked, bool isDark) { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: isUnlocked
            ? AppColors.primary.withValues(alpha: 0.12)
            : (isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: isUnlocked
              ? AppColors.primary.withValues(alpha: 0.4)
              : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
        ),
      ),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
        children: [
          Icon(
            isUnlocked ? Icons.verified : Icons.lock_outline,
            color: isUnlocked ? AppColors.primary : AppColors.outline,
            size: 28,
          ),
          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? (isDark ? AppColors.onSurface : AppColors.textLight)
                  : (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
