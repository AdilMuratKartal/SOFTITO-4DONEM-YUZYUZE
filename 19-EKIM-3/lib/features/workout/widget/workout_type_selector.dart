import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controller/workout_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz

/// Egzersiz Türü Seçici ve Hızlı Ekleme Bileşeni
class WorkoutTypeSelector extends StatelessWidget { // WorkoutTypeSelector sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final WorkoutController controller; // WorkoutController türünden controller adlı değişkenimiz

  const WorkoutTypeSelector({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _buildWorkoutButtons(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
      children: [
        Text(
          'Hızlı Egzersiz Ekle',
          style: theme.textTheme.titleMedium?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Özel Egzersiz'),
          onPressed: () => _showCustomWorkoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildWorkoutButtons(BuildContext context) {
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      children: [
        _presetButton(context, 'Koşu', Icons.directions_run_rounded, 30, 280),
        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _presetButton(context, 'Fitness', Icons.fitness_center_rounded, 45, 220),
        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _presetButton(context, 'Bisiklet', Icons.directions_bike_rounded, 30, 240),
        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _presetButton(context, 'Yürüyüş', Icons.nordic_walking_rounded, 20, 90),
      ],
    );
  }

  Widget _presetButton(
    BuildContext context,
    String name,
    IconData icon,
    int minutes,
    int calories,
  ) {
    final theme = Theme.of(context);
    return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
      child: InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
        onTap: () {
          controller.addWorkout(
            title: '$minutes dk $name',
            type: name,
            durationMinutes: minutes,
            caloriesBurned: calories,
          );
        },
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            border: Border.all(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
            ),
          ),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            children: [
              Icon(icon, color: theme.colorScheme.tertiary, size: 22),
              const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Text(
                name,
                style: theme.textTheme.labelMedium?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$calories kcal',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10), // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomWorkoutDialog(BuildContext context) {
    final titleController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    final durationController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    final calorieController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog( // Kullanıcıya uyarı veya onay penceresi göstermek için AlertDialog açıyoruz
          title: const Text('Yeni Egzersiz Ekle'), // Sayfa başlığını ekrana yazdırıyoruz
          content: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField( // Kullanıcıdan metin girdisi almak için form alanı
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Egzersiz Adı (Örn: Yüzme)'),
                ),
                TextField( // Kullanıcıdan metin girdisi almak için form alanı
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Süre (dakika)'),
                ),
                TextField( // Kullanıcıdan metin girdisi almak için form alanı
                  controller: calorieController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Harcanan Kalori (kcal)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
              onPressed: () => Navigator.pop(ctx), // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
              child: const Text('İptal'),
            ),
            ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
              onPressed: () {
                final duration = int.tryParse(durationController.text) ?? 20;
                final calories = int.tryParse(calorieController.text) ?? 150;
                final title = titleController.text.trim().isEmpty
                    ? 'Genel Egzersiz'
                    : titleController.text.trim();

                controller.addWorkout(
                  title: title,
                  type: 'Özel',
                  durationMinutes: duration,
                  caloriesBurned: calories,
                );
                Navigator.pop(ctx); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}
