import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controller/workout_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../models/workout_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

/// Egzersiz Geçmişi Listesi Bileşeni
class WorkoutHistoryList extends StatelessWidget { // WorkoutHistoryList sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final WorkoutController controller; // WorkoutController türünden controller adlı değişkenimiz

  const WorkoutHistoryList({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final theme = Theme.of(context);

    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
      children: [
        _buildSectionHeader(theme),
        const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _buildList(theme),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
      children: [
        Text(
          'Yapılan Antrenmanlar',
          style: theme.textTheme.titleMedium?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
            fontWeight: FontWeight.bold,
          ),
        ),
        ValueListenableBuilder<List<WorkoutModel>>(
          valueListenable: controller.workoutsNotifier,
          builder: (context, workouts, _) {
            if (workouts.isEmpty) return const SizedBox.shrink();
            return TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
              onPressed: () => controller.reset(),
              child: const Text('Temizle'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildList(ThemeData theme) {
    return ValueListenableBuilder<List<WorkoutModel>>(
      valueListenable: controller.workoutsNotifier,
      builder: (context, workouts, _) {
        if (workouts.isEmpty) {
          return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
            child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                children: [
                  Icon(
                    Icons.sports_gymnastics_rounded,
                    size: 36,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    'Henüz antrenman kaydı eklenmedi.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true, // Listenin sadece elemanları kadar yer kaplamasını sağlıyoruz, taşmasın diye
          physics: const NeverScrollableScrollPhysics(), // Kendi içinde kaydırılmasını engelleyip dıştaki kaydırıcıya bırakıyoruz
          itemCount: workouts.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
          separatorBuilder: (context, index) => const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
            final workout = workouts[index];
            return _buildWorkoutCard(context, theme, workout); // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
          },
        );
      },
    );
  }

  Widget _buildWorkoutCard( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    BuildContext context,
    ThemeData theme,
    WorkoutModel workout,
  ) {
    final timeStr =
        '${workout.timestamp.hour.toString().padLeft(2, '0')}:${workout.timestamp.minute.toString().padLeft(2, '0')}';

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
        ),
      ),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        children: [
          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
              color: theme.colorScheme.tertiary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            ),
            child: Icon(
              Icons.bolt_rounded,
              size: 20,
              color: theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              children: [
                Text(
                  workout.title,
                  style: theme.textTheme.titleSmall?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${workout.durationMinutes} dk • ${workout.caloriesBurned} kcal • +${workout.waterNeededMl} ml su ihtiyacı',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
            icon: const Icon(Icons.close_rounded, size: 16),
            color: theme.colorScheme.error,
            onPressed: () => controller.removeWorkout(workout.id),
          ),
        ],
      ),
    );
  }
}
