import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../entry_editor/models/journal_entry_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../entry_editor/view/entry_editor_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../controllers/timeline_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../models/timeline_filter_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../widgets/entry_card_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widgets/horizontal_day_strip_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widgets/month_selector_bar_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widgets/quick_day_action_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widgets/search_bar_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

/// Günlük Akışı Ekranı (Timeline View) - Ay ve Gün Seçimi, Hızlı Mod ve Günlük Oluşturma.
class TimelineView extends StatefulWidget { // TimelineView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const TimelineView({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late final TimelineController _controller;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _controller = TimelineController();
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _controller.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: Text(AppStrings.timelineTitle, style: style.headerFont), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      floatingActionButton: _buildFab(style),
      body: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        children: [
          _buildMonthSelector(),
          _buildDayStrip(),
          _buildQuickActionCard(), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
          _buildSearchBar(),
          Expanded(child: _buildEntriesList()), // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return ValueListenableBuilder<int>(
      valueListenable: _controller.selectedMonthNotifier,
      builder: (context, selectedMonth, _) {
        return MonthSelectorBarWidget(
          selectedMonth: selectedMonth,
          onMonthSelected: _controller.selectMonth,
        );
      },
    );
  }

  Widget _buildDayStrip() {
    return ValueListenableBuilder<int>(
      valueListenable: _controller.selectedMonthNotifier,
      builder: (context, month, _) {
        return ValueListenableBuilder<int>(
          valueListenable: _controller.selectedYearNotifier,
          builder: (context, year, _) {
            return ValueListenableBuilder<DateTime>(
              valueListenable: _controller.selectedDayNotifier,
              builder: (context, selectedDay, _) {
                return HorizontalDayStripWidget(
                  year: year,
                  month: month,
                  selectedDay: selectedDay,
                  onDaySelected: _controller.selectDay,
                  hasEntriesOnDate: _controller.hasEntriesOnDate,
                  getMoodForDate: _controller.getMoodForDate,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQuickActionCard() { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.selectedDayNotifier,
      builder: (context, selectedDay, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: _controller.selectedMoodForCreationNotifier,
          builder: (context, creationMood, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: _controller.filterOnlySelectedDayNotifier,
              builder: (context, filterOnlyDay, _) {
                return QuickDayActionWidget(
                  selectedDay: selectedDay,
                  selectedCreationMood: creationMood,
                  onMoodSelected: _controller.selectCreationMood,
                  filterOnlyDay: filterOnlyDay,
                  onToggleDayFilter: _controller.toggleDayFilter,
                  onCreateEntry: () {
                    _navigateToEditor(
                      null,
                      targetDate: selectedDay,
                      initialMood: creationMood,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return ValueListenableBuilder<TimelineFilterModel>(
      valueListenable: _controller.filterNotifier,
      builder: (context, filter, _) {
        return SearchBarWidget(
          onSearchChanged: _controller.updateSearch,
          selectedMood: filter.selectedMood,
          onMoodSelected: _controller.setMoodFilter,
        );
      },
    );
  }

  Widget _buildEntriesList() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isLoadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator()); // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
        }
        return ValueListenableBuilder<List<JournalEntry>>(
          valueListenable: _controller.filteredEntriesNotifier,
          builder: (context, entries, _) {
            if (entries.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: entries.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final entry = entries[index];
                return EntryCardWidget(
                  entry: entry,
                  onTap: () => _navigateToEditor(entry),
                  onDelete: () => _controller.deleteEntry(entry.id),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFab(dynamic style) {
    return FloatingActionButton( // Sayfanın üzerinde yüzen hızlı aksiyon butonu (FAB)
      onPressed: () => _navigateToEditor(
        null,
        targetDate: _controller.selectedDayNotifier.value,
        initialMood: _controller.selectedMoodForCreationNotifier.value,
      ),
      backgroundColor: context.colors.primary,
      foregroundColor: context.colors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        side: BorderSide(color: style.borderColor, width: style.borderWidth),
      ),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildEmptyState() {
    return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 64,
            color: context.colors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Text(
            AppStrings.noEntriesFound,
            style: context.journalStyle.headerFont.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
              fontSize: 16.0,
              color: context.colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Text(
            'Seçilen güne/aya ait günlük bulunamadı.\nYukarıdaki "Günlük Yaz" butonuna dokunarak ekleyin!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.0,
              color: context.colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditor(
    JournalEntry? entry, {
    DateTime? targetDate,
    String? initialMood,
  }) {
    Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
      MaterialPageRoute(
        builder: (_) => EntryEditorView(
          initialEntry: entry,
          targetDate: targetDate,
          initialMood: initialMood,
        ),
      ),
    );
  }
}
