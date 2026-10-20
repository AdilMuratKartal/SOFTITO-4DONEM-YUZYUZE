import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/models/app_theme_type.dart';
import '../controllers/theme_selector_controller.dart';
import '../widgets/theme_preview_card.dart';

class ThemeSelectorView extends StatefulWidget {
  const ThemeSelectorView({super.key});

  @override
  State<ThemeSelectorView> createState() => _ThemeSelectorViewState();
}

class _ThemeSelectorViewState extends State<ThemeSelectorView> {
  late final ThemeSelectorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ThemeSelectorController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.themeSelectorTitle, style: style.headerFont),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildModeSwitchCard(context, style),
            const SizedBox(height: 20),
            Text(
              'Tasarım Stilleri',
              style: style.headerFont.copyWith(
                fontSize: 18.0,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _buildThemesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSwitchCard(BuildContext context, dynamic style) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _controller.currentMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(style.borderRadius),
            border: Border.all(
              color: style.borderColor,
              width: style.borderWidth,
            ),
            boxShadow: style.cardShadow,
          ),
          child: Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                size: 32,
                color: context.colors.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDark ? 'Karanlık Mod (Dark)' : 'Aydınlık Mod (Light)',
                      style: style.headerFont.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isDark
                          ? 'Gözü yormayan derin kontrast'
                          : 'Canlı ve net aydınlık görünüm',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: context.colors.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                onChanged: (_) => _controller.toggleMode(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemesList() {
    return ValueListenableBuilder<JournalTheme>(
      valueListenable: _controller.currentTheme,
      builder: (context, current, _) {
        return Column(
          children: JournalTheme.values.map((theme) {
            return ThemePreviewCard(
              theme: theme,
              isSelected: current == theme,
              onTap: () => _controller.selectTheme(theme),
            );
          }).toList(),
        );
      },
    );
  }
}
