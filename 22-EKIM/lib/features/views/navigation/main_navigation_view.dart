import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/habit_controller.dart';
import '../../controllers/mood_controller.dart';
import '../../controllers/roadmap_controller.dart';
import '../../widgets/daily_mood_dialog.dart';
import '../home/home_view.dart';
import '../roadmap/roadmap_view.dart';
import '../timer/pomodoro_view.dart';
import '../analytics/analytics_view.dart';
import '../profile/profile_view.dart';

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
  late final RoadmapController _roadmapController;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _habitController.dispose();
    _moodController.dispose();
    _roadmapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
