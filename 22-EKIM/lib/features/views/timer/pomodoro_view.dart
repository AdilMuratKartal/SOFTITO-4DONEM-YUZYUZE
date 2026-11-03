import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/app_theme.dart';
import '../../controllers/pomodoro_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz

class PomodoroView extends StatefulWidget { // PomodoroView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const PomodoroView({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late final PomodoroController _controller;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _controller = PomodoroController();
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _controller.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text('Odaklanma & Pomodoro'), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            children: [
              // Mod Seçimi
              ValueListenableBuilder<PomodoroMode>(
                valueListenable: _controller.modeNotifier,
                builder: (context, mode, _) {
                  return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                    children: [
                      _buildModeChip('Odaklan (25dk)', mode == PomodoroMode.focus, AppColors.primary, () => _controller.setMode(PomodoroMode.focus), isDark),
                      const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      _buildModeChip('Kısa Mola (5dk)', mode == PomodoroMode.shortBreak, AppColors.moodGood, () => _controller.setMode(PomodoroMode.shortBreak), isDark),
                      const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      _buildModeChip('Uzun (15dk)', mode == PomodoroMode.longBreak, AppColors.tertiary, () => _controller.setMode(PomodoroMode.longBreak), isDark),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Bağlı Alışkanlık Kartı
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Text(
                      'Bağlı: 5 Sayfa Kitap Oku',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.onSurface : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Dairesel Sayaç Kadranı (Display Timer)
              ValueListenableBuilder<int>(
                valueListenable: _controller.remainingSecondsNotifier,
                builder: (context, seconds, _) {
                  return ValueListenableBuilder<PomodoroMode>(
                    valueListenable: _controller.modeNotifier,
                    builder: (context, mode, _) {
                      final total = mode == PomodoroMode.focus
                          ? 25 * 60
                          : (mode == PomodoroMode.shortBreak ? 5 * 60 : 15 * 60);
                      final progress = total > 0 ? (seconds / total) : 0.0;

                      final color = mode == PomodoroMode.focus
                          ? AppColors.primary
                          : (mode == PomodoroMode.shortBreak
                              ? AppColors.moodGood
                              : AppColors.tertiary);

                      return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                        child: Stack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 230,
                              height: 230,
                              child: CircularProgressIndicator( // Veri yüklenirken kullanıcıya işlemin sürdüğünü gösteren yuvarlak animasyon
                                value: progress,
                                strokeWidth: 10,
                                backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
                                valueColor: AlwaysStoppedAnimation<Color>(color),
                              ),
                            ),
                            Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTime(seconds),
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.02,
                                    color: isDark ? AppColors.onSurface : AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                Text(
                                  mode == PomodoroMode.focus
                                      ? 'ODAKLANMA'
                                      : (mode == PomodoroMode.shortBreak ? 'KISA MOLA' : 'UZUN MOLA'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Döngü Noktaları
              ValueListenableBuilder<int>(
                valueListenable: _controller.completedCyclesNotifier,
                builder: (context, cycles, _) {
                  return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                    children: List.generate(4, (i) {
                      final isDone = i < (cycles % 4);
                      return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                          shape: BoxShape.circle,
                          color: isDone
                              ? AppColors.secondary
                              : (isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 36), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Kontrol Butonları
              ValueListenableBuilder<bool>(
                valueListenable: _controller.isRunningNotifier,
                builder: (context, isRunning, _) {
                  return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                    children: [
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? AppColors.surfaceContainerHigh : null,
                          foregroundColor: isDark ? AppColors.onSurface : null,
                        ),
                        iconSize: 26,
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: () => _controller.reset(),
                      ),
                      const SizedBox(width: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRunning ? AppColors.secondary : AppColors.primary,
                          foregroundColor: isRunning ? AppColors.onSecondary : AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        ),
                        onPressed: () {
                          if (isRunning) {
                            _controller.pause();
                          } else {
                            _controller.start();
                          }
                        },
                        child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 26),
                            const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Text(
                              isRunning ? 'DURAKLAT' : 'BAŞLAT',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeChip(String label, bool isSelected, Color activeColor, VoidCallback onTap, bool isDark) {
    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: onTap,
      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isSelected
              ? activeColor
              : (isDark ? AppColors.surfaceContainer : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isSelected ? activeColor : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppColors.onPrimary
                : (isDark ? AppColors.onSurface : AppColors.textLight),
          ),
        ),
      ),
    );
  }
}
