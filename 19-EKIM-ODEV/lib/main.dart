import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/extensions/context_extensions.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/controllers/theme_controller.dart';
import 'core/theme/models/app_theme_type.dart';
import 'features/calendar_view/view/calendar_view.dart';
import 'features/theme_selector/view/theme_selector_view.dart';
import 'features/timeline/view/timeline_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  runApp(const IJournalApp());
}

class IJournalApp extends StatelessWidget {
  const IJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.instance;

    return ValueListenableBuilder<JournalTheme>(
      valueListenable: themeController.currentTheme,
      builder: (context, activeTheme, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeController.currentMode,
          builder: (context, activeMode, _) {
            return MaterialApp(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              themeMode: activeMode,
              theme: AppThemes.getTheme(activeTheme, Brightness.light),
              darkTheme: AppThemes.getTheme(activeTheme, Brightness.dark),
              home: const MainNavigationShell(),
            );
          },
        );
      },
    );
  }
}

/// Ana alt menü ve gezinme kabuğu (Timeline, Calendar, ThemeSelector).
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TimelineView(),
    CalendarView(),
    ThemeSelectorView(),
  ];

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: style.borderColor.withValues(alpha: 0.3),
              width: style.borderWidth < 1.5 ? 1.0 : style.borderWidth,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: context.colors.surface,
          indicatorColor: context.colors.primary.withValues(alpha: 0.18),
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: AppStrings.tabTimeline,
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: AppStrings.tabCalendar,
            ),
            NavigationDestination(
              icon: Icon(Icons.palette_outlined),
              selectedIcon: Icon(Icons.palette),
              label: AppStrings.tabThemes,
            ),
          ],
        ),
      ),
    );
  }
}
