import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controller/workout_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz

/// Egzersiz Özet Kartı Bileşeni
class WorkoutSummaryCard extends StatelessWidget { // WorkoutSummaryCard sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final WorkoutController controller; // WorkoutController türünden controller adlı değişkenimiz

  const WorkoutSummaryCard({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final theme = Theme.of(context);
    final cardBg = theme.cardTheme.color ?? theme.colorScheme.surface;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE);

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: cardBg,
        borderRadius: BorderRadius.circular(24), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          _buildHeader(theme),
          const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          _buildMetricsRow(theme), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      children: [
        Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: theme.colorScheme.tertiary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            color: theme.colorScheme.tertiary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        Text(
          'Egzersiz & Kalori Durumu',
          style: theme.textTheme.titleMedium?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow(ThemeData theme) { // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      children: [
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
          child: ValueListenableBuilder<int>(
            valueListenable: controller.totalCaloriesNotifier,
            builder: (context, cal, _) => _metricItem(
              theme,
              '$cal',
              'kcal yakıldı',
              theme.colorScheme.error,
              Icons.local_fire_department_rounded,
            ),
          ),
        ),
        const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
          child: ValueListenableBuilder<int>(
            valueListenable: controller.totalMinutesNotifier,
            builder: (context, mins, _) => _metricItem(
              theme,
              '$mins',
              'dakika süre',
              theme.colorScheme.primary,
              Icons.timer_rounded,
            ),
          ),
        ),
        const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
          child: ValueListenableBuilder<int>(
            valueListenable: controller.recommendedWaterNotifier,
            builder: (context, water, _) => _metricItem(
              theme,
              '+$water',
              'ml ekstra su',
              theme.colorScheme.secondary,
              Icons.water_drop_rounded,
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricItem(
    ThemeData theme,
    String value,
    String label,
    Color accentColor,
    IconData icon,
  ) {
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        children: [
          Icon(icon, size: 20, color: accentColor),
          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
              fontWeight: FontWeight.w800,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10), // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
          ),
        ],
      ),
    );
  }
}
