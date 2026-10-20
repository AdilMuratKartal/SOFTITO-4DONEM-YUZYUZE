import 'package:flutter/foundation.dart';
import '../../features/entry_editor/models/journal_entry_model.dart';
import '../theme/models/app_theme_type.dart';

/// iJournal uygulamasının yerel veri saklama servisi.
///
/// Offline-first çalışır. Bellek içi ve reaktif bildirim mekanizmasıyla
/// web, mobil ve masaüstünde sıfır konfigürasyonla anında çalışır.
class StorageService {
  static final StorageService instance = StorageService._internal();
  StorageService._internal();

  final ValueNotifier<List<JournalEntry>> entriesNotifier =
      ValueNotifier<List<JournalEntry>>([]);

  bool _initialized = false;

  /// Servisi başlatır ve demo/kayıtlı verileri yükler.
  Future<void> init() async {
    if (_initialized) return;

    // Başlangıç için zengin örnek günlükler
    final now = DateTime.now();
    entriesNotifier.value = [
      JournalEntry(
        id: '1',
        title: 'Dijital Günlük ve Yeni Başlangıçlar',
        content:
            'Bugün iJournal ile ilk günlüğümü kaydettim. NeoBrutalist, Minimalist, Journal, '
            'Hand-Drawn ve Rubber Hose temaları arasında tek dokunuşla geçiş yapabilmek harika bir his! '
            'Fikirlerimi özgürce dökmek için sabırsızlanıyorum.',
        createdAt: now.subtract(const Duration(hours: 3)),
        mood: '✨',
        tags: ['ijournal', 'başlangıç', 'tasarım'],
      ),
      JournalEntry(
        id: '2',
        title: 'Kahve, Kitap ve Düşünceler',
        content:
            'Yağmurlu bir öğleden sonra köşedeki kahvecide oturdum. '
            'Klasik Günlük (Journal) temasına geçince ekran sanki eski bir deri deftere dönüştü. '
            'Sepiya tonlar ve dolma kalem hissi yazma isteğimi iki katına çıkardı.',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        mood: '☕',
        tags: ['kahve', 'huzur', 'kitap'],
      ),
      JournalEntry(
        id: '3',
        title: 'Gece Kodlama Seansı & Rubber Hose Stili',
        content:
            'Gece modunda Rubber Hose temasını denedim. 1930\'ların çizgi film konturları '
            've nitrat film siyahı nostaljik bir hava katıyor. '
            'Yarın takvim görünümünü ve yeni etiketleri inceleyeceğim.',
        createdAt: now.subtract(const Duration(days: 2, hours: 6)),
        mood: '🌙',
        tags: ['kodlama', 'vintage', 'gece'],
      ),
    ];

    _initialized = true;
  }

  /// Tüm günlükleri getirir.
  List<JournalEntry> getAllEntries() {
    return List.unmodifiable(entriesNotifier.value);
  }

  /// Yeni günlük kaydeder veya mevcut olanı günceller.
  Future<void> saveEntry(JournalEntry entry) async {
    final currentList = List<JournalEntry>.from(entriesNotifier.value);
    final index = currentList.indexWhere((e) => e.id == entry.id);

    if (index >= 0) {
      currentList[index] = entry;
    } else {
      currentList.insert(0, entry);
    }

    entriesNotifier.value = currentList;
  }

  /// Günlüğü siler.
  Future<void> deleteEntry(String id) async {
    final currentList = List<JournalEntry>.from(entriesNotifier.value);
    currentList.removeWhere((e) => e.id == id);
    entriesNotifier.value = currentList;
  }

  /// Saklanan tema tercihini döner (varsayılan: Journal).
  JournalTheme getSavedTheme() {
    return JournalTheme.journal;
  }

  /// Tema tercihini kaydeder.
  Future<void> saveTheme(JournalTheme theme) async {
    // Gelecekte SharedPreferences veya LocalStorage anahtarı
  }
}
