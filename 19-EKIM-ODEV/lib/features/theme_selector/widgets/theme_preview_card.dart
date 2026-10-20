import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/models/app_theme_type.dart';

/// Her temanın kendine has stilini (kenarlık, gölge, renk) simüle eden önizleme kartı.
class ThemePreviewCard extends StatelessWidget {
  final JournalTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemePreviewCard({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(style.borderRadius),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : style.borderColor.withValues(alpha: 0.5),
            width: isSelected
                ? (style.borderWidth < 2.0 ? 2.5 : style.borderWidth + 1.0)
                : 1.0,
          ),
          boxShadow: isSelected ? style.cardShadow : const [],
        ),
        child: Row(
          children: [
            _buildThemeBadge(context),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        theme.displayName,
                        style: style.headerFont.copyWith(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.check_circle,
                            size: 18, color: context.colors.primary),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getThemeDescription(theme),
                    style: TextStyle(
                      fontSize: 13.0,
                      color: context.colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeBadge(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _getThemePreviewColor(theme),
        shape: BoxShape.circle,
        border:
            Border.all(color: Colors.black.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Center(
        child: Text(
          _getThemeEmoji(theme),
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  Color _getThemePreviewColor(JournalTheme t) {
    switch (t) {
      case JournalTheme.neoBrutalist:
        return const Color(0xFFFFE500);
      case JournalTheme.minimalist:
        return const Color(0xFFFBFBFB);
      case JournalTheme.journal:
        return const Color(0xFFD4A373);
      case JournalTheme.handDrawn:
        return const Color(0xFFFFF9DE);
      case JournalTheme.rubberHose:
        return const Color(0xFFFFF8EA);
    }
  }

  String _getThemeEmoji(JournalTheme t) {
    switch (t) {
      case JournalTheme.neoBrutalist:
        return '⚡';
      case JournalTheme.minimalist:
        return '⚪';
      case JournalTheme.journal:
        return '📖';
      case JournalTheme.handDrawn:
        return '✏️';
      case JournalTheme.rubberHose:
        return '🎩';
    }
  }

  String _getThemeDescription(JournalTheme t) {
    switch (t) {
      case JournalTheme.neoBrutalist:
        return 'Sert 3px siyah kenarlıklar, canlı pop renkler ve sert gölgeler.';
      case JournalTheme.minimalist:
        return 'Sade İskandinav tipografisi, yumuşak mikro kontrastlar.';
      case JournalTheme.journal:
        return 'Parşömen dokusu, gece mavisi mürekkep ve vintage defter havası.';
      case JournalTheme.handDrawn:
        return 'Kraft saman kağıdı, 2B kurşun kalem ve post-it sıcaklığı.';
      case JournalTheme.rubberHose:
        return '1930\'lar vintage Fleischer animasyon çizgisi ve Technicolor kırmızısı.';
    }
  }
}
