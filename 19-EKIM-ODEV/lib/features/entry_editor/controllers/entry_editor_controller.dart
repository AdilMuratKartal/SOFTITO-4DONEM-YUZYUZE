import 'package:flutter/foundation.dart';
import '../../../core/services/storage_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import '../models/journal_entry_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

/// Günlük Yazma / Düzenleme ekranının reaktif durumlarını yöneten Controller.
class EntryEditorController {
  final JournalEntry? initialEntry; // JournalEntry? türünden initialEntry adlı değişkenimiz
  final DateTime? targetDate; // DateTime? türünden targetDate adlı değişkenimiz
  final String? initialMood; // String? türünden initialMood adlı değişkenimiz

  late final ValueNotifier<String> titleNotifier;
  late final ValueNotifier<String> contentNotifier;
  late final ValueNotifier<String?> selectedMoodNotifier;
  late final ValueNotifier<List<String>> tagsNotifier;
  final ValueNotifier<bool> isSavingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessageNotifier =
      ValueNotifier<String?>(null);

  EntryEditorController({
    this.initialEntry, // initialEntry alanına değer aktarıyoruz
    this.targetDate, // targetDate alanına değer aktarıyoruz
    this.initialMood, // initialMood alanına değer aktarıyoruz
  }) {
    titleNotifier = ValueNotifier<String>(initialEntry?.title ?? '');
    contentNotifier = ValueNotifier<String>(initialEntry?.content ?? '');
    selectedMoodNotifier = ValueNotifier<String?>(
        initialEntry?.mood ?? initialMood ?? '😊');
    tagsNotifier = ValueNotifier<List<String>>(initialEntry?.tags ?? []);
  }

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
    final clean = tag.trim().replaceAll('#', '');
    if (clean.isNotEmpty && !tagsNotifier.value.contains(clean)) {
      tagsNotifier.value = [...tagsNotifier.value, clean];
    }
  }

  void removeTag(String tag) {
    tagsNotifier.value = tagsNotifier.value.where((t) => t != tag).toList();
  }

  Future<bool> saveEntry() async {
    final title = titleNotifier.value.trim();
    final content = contentNotifier.value.trim();

    if (title.isEmpty && content.isEmpty) {
      errorMessageNotifier.value = 'Lütfen bir başlık veya içerik yazınız.';
      return false;
    }

    isSavingNotifier.value = true;
    errorMessageNotifier.value = null;

    try { // Hata oluşabilecek kod bloğumuzu güvenle deniyoruz
      final entry = JournalEntry(
        id: initialEntry?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.isEmpty ? 'İsimsiz Günlük' : title,
        content: content,
        createdAt: initialEntry?.createdAt ?? targetDate ?? DateTime.now(),
        mood: selectedMoodNotifier.value,
        tags: tagsNotifier.value,
      );

      await StorageService.instance.saveEntry(entry);
      return true;
    } finally {
      isSavingNotifier.value = false;
    }
  }

  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    titleNotifier.dispose();
    contentNotifier.dispose();
    selectedMoodNotifier.dispose();
    tagsNotifier.dispose();
    isSavingNotifier.dispose();
    errorMessageNotifier.dispose();
  }
}
