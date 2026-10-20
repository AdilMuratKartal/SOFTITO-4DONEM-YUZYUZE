// ==============================================================================
// iJournal - Altın Standart Özellik Ekranı Örneği (Sample Screen)
//
// Bu dosya, iJournal mimarisinde yeni bir ekran veya özellik yazarken uyulması
// gereken tüm kuralları tek bir çalıştırılabilir örnek üzerinde gösterir:
// 1. Controller: ValueNotifier tabanlı reaktif durum yönetimi (Ağır setState yok)
// 2. Model: Immutable veri yapısı, copyWith, fromJson, toJson
// 3. View: Clean UI, 40 satırı geçmeyen build metodu
// 4. Widgets: 40 satırı aşmayan, temaya duyarlı modüler alt bileşenler
// 5. Tema Uyumu: Sıfır sabit renk, context.colors ve context.journalStyle kullanımı
// ==============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ijournal/core/extensions/context_extensions.dart';

// ------------------------------------------------------------------------------
// 1. MODEL KATMANI (Normalde: lib/features/<feature>/models/<name>_model.dart)
// ------------------------------------------------------------------------------

@immutable
class SampleTimelineEntry {
  final String id;
  final String title;
  final String content;
  final String mood;
  final DateTime createdAt;

  const SampleTimelineEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
  });

  SampleTimelineEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? mood,
    DateTime? createdAt,
  }) {
    return SampleTimelineEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SampleTimelineEntry.fromJson(Map<String, dynamic> json) {
    return SampleTimelineEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      mood: json['mood'] as String? ?? '😊',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// ------------------------------------------------------------------------------
// 2. CONTROLLER KATMANI (Normalde: lib/features/<feature>/controllers/)
// ------------------------------------------------------------------------------

class SampleTimelineController {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<List<SampleTimelineEntry>> entriesNotifier =
      ValueNotifier<List<SampleTimelineEntry>>([]);
  final ValueNotifier<String?> selectedMoodFilter = ValueNotifier<String?>(null);

  /// Günlükleri yükler.
  Future<void> fetchEntries() async {
    isLoadingNotifier.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      entriesNotifier.value = [
        SampleTimelineEntry(
          id: '1',
          title: 'Yeni Bir Başlangıç',
          content: 'Bugün iJournal ile ilk günlüğümü yazdım. Tasarım harika hissettiriyor!',
          mood: '✨',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        SampleTimelineEntry(
          id: '2',
          title: 'Kahve ve Kodlama',
          content: 'Flutter 3.29 ve ValueNotifier mimarisi üzerinde çalıştım.',
          mood: '☕',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  /// Duygu filtresini değiştirir.
  void setFilter(String? mood) {
    selectedMoodFilter.value = mood;
  }

  /// Yeni günlük kaydı ekler.
  void addEntry(SampleTimelineEntry entry) {
    entriesNotifier.value = [entry, ...entriesNotifier.value];
  }

  /// Günlüğü siler.
  void deleteEntry(String id) {
    entriesNotifier.value =
        entriesNotifier.value.where((e) => e.id != id).toList();
  }

  /// Tüm kaynakları temizler.
  void dispose() {
    isLoadingNotifier.dispose();
    entriesNotifier.dispose();
    selectedMoodFilter.dispose();
  }
}

// ------------------------------------------------------------------------------
// 3. VIEW KATMANI (Normalde: lib/features/<feature>/view/<name>_view.dart)
// ------------------------------------------------------------------------------

class SampleTimelineView extends StatefulWidget {
  const SampleTimelineView({super.key});

  @override
  State<SampleTimelineView> createState() => _SampleTimelineViewState();
}

class _SampleTimelineViewState extends State<SampleTimelineView> {
  late final SampleTimelineController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SampleTimelineController();
    _controller.fetchEntries();
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
        title: Text('Günlük Akışı', style: style.headerFont),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: _controller.fetchEntries,
          ),
        ],
      ),
      body: Column(
        children: [
          SampleFilterChipsBar(
            selectedFilterNotifier: _controller.selectedMoodFilter,
            onFilterSelected: _controller.setFilter,
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _controller.isLoadingNotifier,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildEntriesList();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList() {
    return ValueListenableBuilder<List<SampleTimelineEntry>>(
      valueListenable: _controller.entriesNotifier,
      builder: (context, entries, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: _controller.selectedMoodFilter,
          builder: (context, filter, _) {
            final filtered = filter == null
                ? entries
                : entries.where((e) => e.mood == filter).toList();

            if (filtered.isEmpty) {
              return const SampleEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final entry = filtered[index];
                return SampleTimelineCard(
                  entry: entry,
                  onDelete: () => _controller.deleteEntry(entry.id),
                );
              },
            );
          },
        );
      },
    );
  }
}

// ------------------------------------------------------------------------------
// 4. MODÜLER ALT WIDGET'LAR (Normalde: lib/features/<feature>/widgets/)
// ------------------------------------------------------------------------------

/// Filtre çubuğu bileşeni (40 satır altı, modüler).
class SampleFilterChipsBar extends StatelessWidget {
  final ValueListenable<String?> selectedFilterNotifier;
  final ValueChanged<String?> onFilterSelected;

  static const List<String> availableMoods = ['✨', '☕', '😊', '🌧️'];

  const SampleFilterChipsBar({
    super.key,
    required this.selectedFilterNotifier,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ValueListenableBuilder<String?>(
        valueListenable: selectedFilterNotifier,
        builder: (context, current, _) {
          return Row(
            children: [
              ChoiceChip(
                label: const Text('Tümü'),
                selected: current == null,
                onSelected: (_) => onFilterSelected(null),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(style.borderRadius),
                ),
              ),
              const SizedBox(width: 8),
              ...availableMoods.map((mood) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(mood),
                    selected: current == mood,
                    onSelected: (selected) =>
                        onFilterSelected(selected ? mood : null),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(style.borderRadius),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

/// Temaya duyarlı Günlük Kartı bileşeni.
///
/// Kenarlık kalınlığı, rengi, gölgesi ve köşe yuvarlaklığı doğrudan
/// [context.journalStyle] ThemeExtension üzerinden dinamik beslenir.
class SampleTimelineCard extends StatelessWidget {
  final SampleTimelineEntry entry;
  final VoidCallback onDelete;

  const SampleTimelineCard({
    super.key,
    required this.entry,
    required this.onDelete,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(entry.mood, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.title,
                    style: style.headerFont.copyWith(
                      color: context.colors.onSurface,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: context.colors.error,
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.content,
              style: TextStyle(
                color: context.colors.onSurface.withOpacity(0.85),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Boş ekran durumunu gösteren hafif bileşen.
class SampleEmptyState extends StatelessWidget {
  const SampleEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 64,
            color: context.colors.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz bir günlük kaydı yok',
            style: context.journalStyle.headerFont.copyWith(
              color: context.colors.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
