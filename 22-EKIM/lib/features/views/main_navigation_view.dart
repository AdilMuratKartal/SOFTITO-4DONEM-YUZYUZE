import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/habit_controller.dart';
import '../controllers/mood_controller.dart';
import 'home_view.dart';
import 'roadmap_view.dart';
import 'pomodoro_view.dart';
import 'analytics_view.dart';
import 'profile_view.dart';

class MainNavigationView extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const MainNavigationView({super.key, required this.themeModeNotifier});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;
  late final HabitController _habitController;
  late final MoodController _moodController;

  @override
  void initState() {
    super.initState();
    _habitController = HabitController();
    _moodController = MoodController();
    _habitController.loadDailyHabits();
    _moodController.loadTodayMood();
  }

  @override
  void dispose() {
    _habitController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeView(
        habitController: _habitController,
        moodController: _moodController,
      ),
      const RoadmapView(),
      const PomodoroView(),
      AnalyticsView(habitController: _habitController),
      ProfileView(themeModeNotifier: widget.themeModeNotifier),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
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
