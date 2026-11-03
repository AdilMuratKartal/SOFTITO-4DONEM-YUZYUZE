import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/app_theme.dart';
import '../../controllers/habit_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../../controllers/mood_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../../controllers/roadmap_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../../widgets/daily_mood_dialog.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../home/home_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../roadmap/roadmap_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../timer/pomodoro_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../analytics/analytics_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../profile/profile_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

class MainNavigationView extends StatefulWidget { // MainNavigationView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final ValueNotifier<ThemeMode> themeModeNotifier; // ValueNotifier<ThemeMode> türünden themeModeNotifier adlı değişkenimiz

  const MainNavigationView({super.key, required this.themeModeNotifier}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  int _currentIndex = 0; // int türünden _currentIndex değişkenimiz
  late final HabitController _habitController;
  late final MoodController _moodController;
  late final RoadmapController _roadmapController;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _habitController = HabitController();
    _moodController = MoodController();
    _roadmapController = RoadmapController(habitController: _habitController);
    _habitController.loadDailyHabits();
    _moodController.loadTodayMood().then((_) {
      if (mounted && _moodController.shouldPromptDailyMoodNotifier.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _moodController.shouldPromptDailyMoodNotifier.value) {
            DailyMoodDialog.show(
              context,
              currentMood: _moodController.todayMoodNotifier.value,
              onMoodSelected: _moodController.setTodayMood,
              onDismiss: _moodController.dismissDailyPrompt,
            );
          }
        });
      }
    });
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _habitController.dispose();
    _moodController.dispose();
    _roadmapController.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final pages = [
      HomeView(
        habitController: _habitController,
        moodController: _moodController,
      ),
      RoadmapView(
        roadmapController: _roadmapController,
        habitController: _habitController,
      ),
      const PomodoroView(),
      AnalyticsView(habitController: _habitController),
      ProfileView(themeModeNotifier: widget.themeModeNotifier),
    ];

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      body: IndexedStack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today_rounded, color: AppColors.primary),
            label: 'Bugün',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded, color: AppColors.primary),
            label: 'Rota',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer_rounded, color: AppColors.primary),
            label: 'Odak',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded, color: AppColors.primary),
            label: 'Analiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
