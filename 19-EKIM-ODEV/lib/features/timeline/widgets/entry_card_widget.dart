import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../entry_editor/models/journal_entry_model.dart';

/// 5 Temanın tasarım diline göre dinamik şekillenen Günlük Kartı bileşeni.
class EntryCardWidget extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const EntryCardWidget({
    super.key,
    required this.entry,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(style.borderRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, style),
                const SizedBox(height: 8),
                _buildContent(context),
                if (entry.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildTags(context, style),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic style) {
    return Row(
      children: [
        if (entry.mood != null) ...[
          Text(entry.mood!, style: const TextStyle(fontSize: 22.0)),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: style.headerFont.copyWith(
                  color: context.colors.onSurface,
                  fontSize: 18.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                entry.createdAt.toJournalDate(),
                style: TextStyle(
                  color: context.colors.onSurface.withValues(alpha: 0.6),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: context.colors.error,
            onPressed: onDelete,
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      entry.content,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: context.colors.onSurface.withValues(alpha: 0.85),
        fontSize: 14.0,
        height: 1.45,
      ),
    );
  }

  Widget _buildTags(BuildContext context, dynamic style) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: entry.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(style.borderRadius / 2),
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
