import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Günlük yazımı için pratik biçimlendirme ve ekleme araç çubuğu.
class TextFormattingBar extends StatelessWidget {
  final VoidCallback onAddDate;
  final VoidCallback onAddBullet;
  final VoidCallback onAddQuote;

  const TextFormattingBar({
    super.key,
    required this.onAddDate,
    required this.onAddBullet,
    required this.onAddQuote,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(
          color: style.borderColor.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, size: 20),
            tooltip: 'Tarih Ekle',
            onPressed: onAddDate,
          ),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted, size: 20),
            tooltip: 'Madde İmi',
            onPressed: onAddBullet,
          ),
          IconButton(
            icon: const Icon(Icons.format_quote_outlined, size: 20),
            tooltip: 'Alıntı Ekle',
            onPressed: onAddQuote,
          ),
        ],
      ),
    );
  }
}
