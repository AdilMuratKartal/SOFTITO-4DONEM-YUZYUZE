import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controller/water_tracker_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../models/water_entry_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

/// Su Tüketim Geçmişi Listesi Bileşeni
class WaterHistoryList extends StatelessWidget { // WaterHistoryList sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final WaterTrackerController controller; // WaterTrackerController türünden controller adlı değişkenimiz

  const WaterHistoryList({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final theme = Theme.of(context);

    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
      children: [
        _buildSectionTitle(theme),
        const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        _buildList(theme),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme) {
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
      children: [
        Text(
          'Bugünkü İçimler',
          style: theme.textTheme.titleMedium?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
            fontWeight: FontWeight.bold,
          ),
        ),
        ValueListenableBuilder<List<WaterEntryModel>>(
          valueListenable: controller.historyNotifier,
          builder: (context, history, _) {
            if (history.isEmpty) return const SizedBox.shrink();
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
    return ValueListenableBuilder<List<WaterEntryModel>>(
      valueListenable: controller.historyNotifier,
      builder: (context, history, _) {
        if (history.isEmpty) {
          return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
            child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                children: [
                  Icon(
                    Icons.opacity_outlined,
                    size: 36,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    'Henüz su kaydı bulunmuyor.',
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
          itemCount: history.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
          separatorBuilder: (context, index) => const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
            final entry = history[index];
            return _buildEntryCard(context, theme, entry); // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
          },
        );
      },
    );
  }

  Widget _buildEntryCard( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    BuildContext context,
    ThemeData theme,
    WaterEntryModel entry,
  ) {
    final timeStr =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        children: [
          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            ),
            child: Icon(
              Icons.water_drop_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              children: [
                Text(
                  '${entry.amountMl} ml',
                  style: theme.textTheme.titleSmall?.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  entry.note ?? 'Hızlı Ekleme',
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
            onPressed: () => controller.removeEntry(entry.id),
          ),
        ],
      ),
    );
  }
}
