import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controller/water_tracker_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz

/// Günlük Su İlerleme Kartı Bileşeni
class WaterProgressCard extends StatelessWidget { // WaterProgressCard sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final WaterTrackerController controller; // WaterTrackerController türünden controller adlı değişkenimiz

  const WaterProgressCard({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = theme.cardTheme.color ?? theme.colorScheme.surface;
    final borderColor = isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE);

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: cardBg,
        borderRadius: BorderRadius.circular(24), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(color: borderColor, width: 1),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: controller.totalWaterNotifier,
        builder: (context, totalWater, _) {
          return ValueListenableBuilder<int>(
            valueListenable: controller.dailyGoalNotifier,
            builder: (context, goal, _) {
              final progress = goal > 0 ? (totalWater / goal).clamp(0.0, 1.0) : 0.0;
              final percent = (progress * 100).toInt();

              return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                children: [
                  _buildProgressHeader(theme, percent),
                  const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  _buildProgressBar(theme, progress),
                  const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  _buildStatsRow(theme, totalWater, goal), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(ThemeData theme, int percent) {
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
      children: [
        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: [
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              'Günlük Hedef',
              style: theme.textTheme.titleMedium?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: theme.colorScheme.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          ),
          child: Text(
            '%$percent',
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(ThemeData theme, double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 14,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, int total, int goal) { // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
      children: [
        Text(
          '$total ml içildi',
          style: theme.textTheme.bodyMedium?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          'Hedef: $goal ml',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
