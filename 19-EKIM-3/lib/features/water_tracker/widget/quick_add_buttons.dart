import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controller/water_tracker_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz

/// Hızlı Su Ekleme Butonları Bileşeni
class QuickAddButtons extends StatelessWidget { // QuickAddButtons sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final WaterTrackerController controller; // WaterTrackerController türünden controller adlı değişkenimiz

  const QuickAddButtons({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      children: [
        _buildAddButton(context, 200, 'Bardak'),
        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _buildAddButton(context, 330, 'Kutu'),
        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _buildAddButton(context, 500, 'Şişe'),
        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _buildCustomButton(context),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context, int amount, String label) {
    final theme = Theme.of(context);
    return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
      child: InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
        onTap: () => controller.addWater(amount, note: label),
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            children: [
              Icon(
                Icons.local_drink_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Text(
                '+$amount',
                style: theme.textTheme.labelLarge?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                'ml',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10), // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
      child: InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
        onTap: () => _showCustomInputDialog(context),
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 1.2,
            ),
          ),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Text(
                'Özel',
                style: theme.textTheme.labelLarge?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                'Giriş',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10), // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomInputDialog(BuildContext context) {
    final textController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog( // Kullanıcıya uyarı veya onay penceresi göstermek için AlertDialog açıyoruz
          title: const Text('Özel Miktar Ekle'), // Sayfa başlığını ekrana yazdırıyoruz
          content: TextField( // Kullanıcıdan metin girdisi almak için form alanı
            controller: textController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Örn: 400',
              suffixText: 'ml',
            ),
          ),
          actions: [
            TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
              onPressed: () => Navigator.pop(ctx), // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
              child: const Text('İptal'),
            ),
            ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
              onPressed: () {
                final value = int.tryParse(textController.text);
                if (value != null && value > 0) {
                  controller.addWater(value, note: 'Özel Miktar');
                }
                Navigator.pop(ctx); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}
