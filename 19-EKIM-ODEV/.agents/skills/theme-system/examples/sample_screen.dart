// ==============================================================================
// iJournal - Tema Sistemi Canlı Önizleme ve Test Ekranı (Theme Showcase)
//
// Bu örnek ekran, iJournal'ın 5 farklı görsel temasını (NeoBrutalist, Minimalist,
// Journal, Hand-Drawn, Rubber Hose) ve Gece/Gündüz modunu canlı olarak test eden
// ve ThemeExtension (JournalThemeStyle) ile context.colors entegrasyonunu
// sergileyen referans bileşendir.
//
// Özellik İskeletinden (feature-scaffold) FARKLI olarak:
// Burada doğrudan tema motorunun reaktif davranışı ve 5 temanın görsel farkları
// önizlenir.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:ijournal/core/extensions/context_extensions.dart';
import 'package:ijournal/core/theme/controllers/theme_controller.dart';
import 'package:ijournal/core/theme/models/app_theme_type.dart';

/// 5 Temanın ve Gece/Gündüz modunun canlı önizlendiği vitrin ekranı.
class ThemeShowcaseView extends StatelessWidget {
  const ThemeShowcaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;
    final controller = ThemeController.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tema Vitrini & Önizleme', style: style.headerFont),
        actions: const [
          _ThemeModeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tasarım Dilini Seçin',
              style: style.headerFont.copyWith(
                fontSize: 18,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _ThemeSelectionPanel(controller: controller),
            const SizedBox(height: 24),
            Text(
              'Canlı Kart Önizlemesi',
              style: style.headerFont.copyWith(
                fontSize: 18,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const _LiveThemedCardSample(),
            const SizedBox(height: 24),
            Text(
              'Aktif Tema Renk Tokenları',
              style: style.headerFont.copyWith(
                fontSize: 18,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const _ColorTokensDisplay(),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------------
// MODÜLER ALT BİLEŞENLER (40 satır kuralına uygun)
// ------------------------------------------------------------------------------

/// AppBar üzerindeki Güneş/Ay mod değiştirme butonu.
class _ThemeModeToggleButton extends StatelessWidget {
  const _ThemeModeToggleButton();

  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.instance;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller.currentMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          tooltip: isDark ? 'Gündüz Moduna Geç' : 'Gece Moduna Geç',
          onPressed: controller.toggleMode,
        );
      },
    );
  }
}

/// 5 Temayı seçmeye yarayan yatay / ızgara panel.
class _ThemeSelectionPanel extends StatelessWidget {
  final ThemeController controller;

  const _ThemeSelectionPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return ValueListenableBuilder<JournalTheme>(
      valueListenable: controller.currentTheme,
      builder: (context, activeTheme, _) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: JournalTheme.values.map((theme) {
            final isSelected = activeTheme == theme;

            return ChoiceChip(
              label: Text(theme.displayName),
              selected: isSelected,
              onSelected: (_) => controller.setTheme(theme),
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? context.colors.onPrimary
                    : context.colors.onSurface,
              ),
              selectedColor: context.colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(style.borderRadius),
                side: BorderSide(
                  color: isSelected ? context.colors.primary : style.borderColor,
                  width: isSelected ? style.borderWidth : 1.0,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Seçilen temanın kenarlık, gölge ve font özelliklerini canlı sergileyen kart.
class _LiveThemedCardSample extends StatelessWidget {
  const _LiveThemedCardSample();

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.secondary,
                  borderRadius: BorderRadius.circular(style.borderRadius / 2),
                ),
                child: Text(
                  'Aktif Stil',
                  style: TextStyle(
                    color: context.colors.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Bugün, 14:30',
                style: TextStyle(
                  color: context.colors.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Zamanın ve Düşüncelerin İzi',
            style: style.headerFont.copyWith(
              color: context.colors.onSurface,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bu kart, seçilen temaya göre otomatik olarak değişir. NeoBrutalist sert gölgesini, '
            'Minimalist yalınlığını, Journal antika zarafetini, Hand-Drawn post-it sıcaklığını '
            've Rubber Hose 1930\'lar çizgi film konturunu anında yansıtır.',
            style: TextStyle(
              color: context.colors.onSurface.withOpacity(0.85),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Aktif temanın Material 3 renk paleti tokenlarını gösteren görsel ızgara.
class _ColorTokensDisplay extends StatelessWidget {
  const _ColorTokensDisplay();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.journalStyle;

    final tokenList = [
      {'name': 'Primary', 'color': colors.primary, 'on': colors.onPrimary},
      {'name': 'Secondary', 'color': colors.secondary, 'on': colors.onSecondary},
      {'name': 'Surface', 'color': colors.surface, 'on': colors.onSurface},
      {'name': 'Error', 'color': colors.error, 'on': colors.onError},
    ];

    return Row(
      children: tokenList.map((token) {
        final color = token['color'] as Color;
        final onColor = token['on'] as Color;
        final name = token['name'] as String;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(style.borderRadius),
              border: Border.all(
                color: style.borderColor.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: onColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: TextStyle(
                    color: onColor.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
