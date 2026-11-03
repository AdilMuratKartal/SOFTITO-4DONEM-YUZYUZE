import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/models/app_theme_type.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../controllers/theme_selector_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../widgets/theme_preview_card.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

class ThemeSelectorView extends StatefulWidget { // ThemeSelectorView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const ThemeSelectorView({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<ThemeSelectorView> createState() => _ThemeSelectorViewState();
}

class _ThemeSelectorViewState extends State<ThemeSelectorView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late final ThemeSelectorController _controller;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _controller = ThemeSelectorController();
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _controller.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: Text(AppStrings.themeSelectorTitle, style: style.headerFont), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      body: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          crossAxisAlignment: CrossAxisAlignment.stretch, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            _buildModeSwitchCard(context, style), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
            const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              'Tasarım Stilleri',
              style: style.headerFont.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                fontSize: 18.0,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            _buildThemesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSwitchCard(BuildContext context, dynamic style) { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _controller.currentMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            border: Border.all(
              color: style.borderColor,
              width: style.borderWidth,
            ),
            boxShadow: style.cardShadow,
          ),
          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                size: 32,
                color: context.colors.primary,
              ),
              const SizedBox(width: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    Text(
                      isDark ? 'Karanlık Mod (Dark)' : 'Aydınlık Mod (Light)',
                      style: style.headerFont.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isDark
                          ? 'Gözü yormayan derin kontrast'
                          : 'Canlı ve net aydınlık görünüm',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: context.colors.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                onChanged: (_) => _controller.toggleMode(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemesList() {
    return ValueListenableBuilder<JournalTheme>(
      valueListenable: _controller.currentTheme,
      builder: (context, current, _) {
        return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          children: JournalTheme.values.map((theme) {
            return ThemePreviewCard( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
              theme: theme,
              isSelected: current == theme,
              onTap: () => _controller.selectTheme(theme),
            );
          }).toList(),
        );
      },
    );
  }
}
