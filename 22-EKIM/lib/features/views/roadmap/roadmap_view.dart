import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../controllers/roadmap_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../../controllers/habit_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../roadmap_list_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

/// Yol Haritası Ana Ekran Sarmalayıcısı (RoadmapView)
/// Yeni hiyerarşik RoadmapListView bileşenine yönlendirir.
class RoadmapView extends StatefulWidget { // RoadmapView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final RoadmapController? roadmapController; // RoadmapController? türünden roadmapController adlı değişkenimiz
  final HabitController? habitController; // HabitController? türünden habitController adlı değişkenimiz

  const RoadmapView({ // Genel, sabit sınıf constructor'ı
    super.key,
    this.roadmapController, // roadmapController alanına değer aktarıyoruz
    this.habitController, // habitController alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<RoadmapView> createState() => _RoadmapViewState();
}

class _RoadmapViewState extends State<RoadmapView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late final HabitController _habitController;
  late final RoadmapController _roadmapController;
  bool _ownsControllers = false; // Durum kontrolü için tuttuğumuz bool bayrağımız (_ownsControllers)

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    if (widget.roadmapController != null && widget.habitController != null) {
      _habitController = widget.habitController!;
      _roadmapController = widget.roadmapController!;
    } else {
      _ownsControllers = true;
      _habitController = HabitController();
      _habitController.loadDailyHabits();
      _roadmapController = RoadmapController(habitController: _habitController);
    }
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    if (_ownsControllers) {
      _roadmapController.dispose();
      _habitController.dispose();
    }
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return RoadmapListView(
      roadmapController: _roadmapController,
      habitController: _habitController,
    );
  }
}
