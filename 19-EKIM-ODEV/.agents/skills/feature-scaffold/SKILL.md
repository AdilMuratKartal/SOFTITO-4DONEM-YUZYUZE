---
name: feature-scaffold
description: iJournal uygulamasında yeni bir işlev modülü (ör. entry_editor, timeline, calendar_view) açarken Clean UI, ValueNotifier reaktif state ve temaya duyarlı widget yapısını standartlara uygun olarak üretir.
---

# iJournal Feature Scaffold (Modüler Ekran ve Özellik İskeleti)

Bu yetenek, iJournal projesinde yeni bir ekran veya işlev modülü açarken Clean UI, `ValueNotifier` durum yönetimi ve projenin 5 tasarım temasına tam uyumlu arayüz standartlarını garanti altına alır.

---

## 1. Temel Mimari Kuralları

1. **Tek Dosyada Toplama Yasağı:** Her modül mutlaka `controllers/`, `models/`, `view/` ve `widgets/` olmak üzere 4 ayrı parçaya bölünmelidir.
2. **State Yönetimi Standartları:**
   - Ağır sayfa seviyesi `setState` KULLANILMAYACAKTIR.
   - Durumlar `ValueNotifier` ile tutulacak; UI yalnızca `ValueListenableBuilder` ile dinlenecektir.
   - Sadece yerel metin kontrolü (`TextEditingController`) veya mikro buton animasyonları için `StatefulWidget` kabul edilir.
3. **Temaya Tam Uyum:**
   - Asla sabit renk (`Color(...)`) veya sabit gölge/kenarlık verilmeyecektir.
   - Renkler `context.colors`, stil ve kenarlıklar `context.journalStyle` üzerinden okunacaktır.
4. **Performans ve Temizlik:**
   - Mümkün olan her yerde `const` zorunludur.
   - 40 satırı geçen `build` metotları yasaktır; alt bileşenler `widgets/` altına taşınmalıdır.
   - Controller içindeki tüm `ValueNotifier`'lar `dispose()` edilmelidir.

---

## 2. Modül Klasör Yapısı

Yeni bir özellik oluşturulurken (`lib/features/<feature_name>/`):

```text
lib/features/<feature_name>/
├── controllers/
│   └── <feature_name>_controller.dart
├── models/
│   └── <feature_name>_model.dart
├── view/
│   └── <feature_name>_view.dart
└── widgets/
    └── <feature_name>_widget.dart
```

Test dizininde eşleniği:

```text
test/features/<feature_name>/
└── controllers/
    └── <feature_name>_controller_test.dart
```

---

## 3. Adım Adım Kod Üretim Rehberi (Örnek: `entry_editor`)

### Adım 1: Controller Dosyası (`controllers/entry_editor_controller.dart`)

İş mantığını ve reaktif durumları barındırır. UI'dan tamamen bağımsızdır:

```dart
import 'package:flutter/foundation.dart';
import '../models/journal_entry_model.dart';

class EntryEditorController {
  final ValueNotifier<String> titleNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> contentNotifier = ValueNotifier<String>('');
  final ValueNotifier<String?> selectedMoodNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<List<String>> tagsNotifier = ValueNotifier<List<String>>([]);
  final ValueNotifier<bool> isSavingNotifier = ValueNotifier<bool>(false);

  void updateTitle(String title) {
    titleNotifier.value = title;
  }

  void updateContent(String content) {
    contentNotifier.value = content;
  }

  void setMood(String? mood) {
    selectedMoodNotifier.value = mood;
  }

  void addTag(String tag) {
    if (tag.trim().isNotEmpty && !tagsNotifier.value.contains(tag.trim())) {
      tagsNotifier.value = [...tagsNotifier.value, tag.trim()];
    }
  }

  void removeTag(String tag) {
    tagsNotifier.value = tagsNotifier.value.where((t) => t != tag).toList();
  }

  Future<bool> saveEntry() async {
    if (titleNotifier.value.trim().isEmpty && contentNotifier.value.trim().isEmpty) {
      return false;
    }

    isSavingNotifier.value = true;
    try {
      final entry = JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleNotifier.value.trim(),
        content: contentNotifier.value.trim(),
        createdAt: DateTime.now(),
        mood: selectedMoodNotifier.value,
        tags: tagsNotifier.value,
      );

      // TODO: core/services/storage_service üzerinden kaydet
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    } finally {
      isSavingNotifier.value = false;
    }
  }

  void dispose() {
    titleNotifier.dispose();
    contentNotifier.dispose();
    selectedMoodNotifier.dispose();
    tagsNotifier.dispose();
    isSavingNotifier.dispose();
  }
}
```

---

### Adım 2: Model Dosyası (`models/journal_entry_model.dart`)

Değişmez (`immutable`) olmalı, `copyWith`, `fromJson` ve `toJson` içermelidir:

```dart
import 'package:flutter/foundation.dart';

@immutable
class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? mood;
  final List<String> tags;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.mood,
    this.tags = const [],
  });

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    String? mood,
    List<String>? tags,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      mood: json['mood'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'mood': mood,
      'tags': tags,
    };
  }
}
```

---

### Adım 3: View Dosyası (`view/entry_editor_view.dart`)

Yalnızca `StatelessWidget` veya minimal Controller yönetimi içeren sayfa:

```dart
import 'package:flutter/material.dart';
import 'package:ijournal/core/extensions/context_extensions.dart';
import '../controllers/entry_editor_controller.dart';
import '../widgets/mood_picker_widget.dart';

class EntryEditorView extends StatefulWidget {
  const EntryEditorView({super.key});

  @override
  State<EntryEditorView> createState() => _EntryEditorViewState();
}

class _EntryEditorViewState extends State<EntryEditorView> {
  late final EntryEditorController _controller;
  late final TextEditingController _titleTextController;
  late final TextEditingController _contentTextController;

  @override
  void initState() {
    super.initState();
    _controller = EntryEditorController();
    _titleTextController = TextEditingController();
    _contentTextController = TextEditingController();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Günlük', style: style.headerFont),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _controller.isSavingNotifier,
            builder: (context, isSaving, _) {
              if (isSaving) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  final success = await _controller.saveEntry();
                  if (success && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MoodPickerWidget(
              selectedMoodNotifier: _controller.selectedMoodNotifier,
              onMoodSelected: _controller.setMood,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleTextController,
              onChanged: _controller.updateTitle,
              style: style.headerFont.copyWith(fontSize: 22),
              decoration: const InputDecoration(
                hintText: 'Günün Başlığı...',
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            TextField(
              controller: _contentTextController,
              onChanged: _controller.updateContent,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Bugün neler hissettin, neler yaşadın?',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Adım 4: Temaya Duyarlı Alt Bileşen (`widgets/mood_picker_widget.dart`)

40 satır sınırını aşmamak için ayrıştırılan modüler widget:

```dart
import 'package:flutter/material.dart';
import 'package:ijournal/core/extensions/context_extensions.dart';

class MoodPickerWidget extends StatelessWidget {
  final ValueListenable<String?> selectedMoodNotifier;
  final ValueChanged<String?> onMoodSelected;

  static const List<String> moods = ['😊', '😌', '🤔', '🌧️', '🔥', '✨'];

  const MoodPickerWidget({
    super.key,
    required this.selectedMoodNotifier,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return ValueListenableBuilder<String?>(
      valueListenable: selectedMoodNotifier,
      builder: (context, currentMood, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: moods.map((mood) {
              final isSelected = currentMood == mood;
              return GestureDetector(
                onTap: () => onMoodSelected(isSelected ? null : mood),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected ? context.colors.primary.withOpacity(0.15) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(mood, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
```

---

### Adım 5: Birim Test İskeleti (`test/features/entry_editor/entry_editor_controller_test.dart`)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ijournal/features/entry_editor/controllers/entry_editor_controller.dart';

void main() {
  group('EntryEditorController Tests', () {
    late EntryEditorController controller;

    setUp(() {
      controller = EntryEditorController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç değerleri boş olmalıdır', () {
      expect(controller.titleNotifier.value, '');
      expect(controller.contentNotifier.value, '');
      expect(controller.selectedMoodNotifier.value, isNull);
      expect(controller.tagsNotifier.value, isEmpty);
    });

    test('updateTitle çağrıldığında titleNotifier güncellenmelidir', () {
      controller.updateTitle('Yeni Başlık');
      expect(controller.titleNotifier.value, 'Yeni Başlık');
    });

    test('setMood çağrıldığında mood güncellenmelidir', () {
      controller.setMood('🔥');
      expect(controller.selectedMoodNotifier.value, '🔥');
    });

    test('Boş içerik ve başlıkla kayıt başarısız olmalıdır', () async {
      final success = await controller.saveEntry();
      expect(success, false);
    });
  });
}
```

---

## 4. Yardımcı Kaynaklar ve Araçlar

Bu yetenek paketinde şu destekleyici dosyalar yer alır:

- **Otomasyon Betiği (`script/generate_feature.sh`):** Tek bir komutla (`./script/generate_feature.sh timeline`) bu 4 klasörü ve başlangıç dosyalarını otomatik oluşturur.
- **Durum Akışı Rehberi (`references/state_flow.md`):** `ValueNotifier` ile servis katmanı arasındaki veri akışını gösteren mimari referans şeması.
- **Altın Standart Ekran (`examples/sample_screen.dart`):** Tüm Clean UI kurallarını içeren tam ekran örneği.

---

## 5. Doğrulama

Her yeni modül açıldıktan sonra şu komutlarla doğrulanmalıdır:

```bash
flutter analyze
flutter test test/features/<feature_name>/
```
