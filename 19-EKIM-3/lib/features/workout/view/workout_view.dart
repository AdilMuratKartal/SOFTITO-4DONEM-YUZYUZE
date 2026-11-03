import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../controller/workout_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../widget/workout_history_list.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widget/workout_summary_card.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widget/workout_type_selector.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

/// Egzersiz ve Kalori Takip Ekranı (StatelessWidget + Clean UI)
class WorkoutView extends StatelessWidget { // WorkoutView sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final WorkoutController controller; // WorkoutController türünden controller adlı değişkenimiz

  const WorkoutView({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.controller, // controller parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          WorkoutSummaryCard(controller: controller), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
          const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          WorkoutTypeSelector(controller: controller),
          const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          WorkoutHistoryList(controller: controller),
          const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        ],
      ),
    );
  }
}
