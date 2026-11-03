import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../entry_editor/models/journal_entry_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../entry_editor/view/entry_editor_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz
import '../../timeline/widgets/entry_card_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../controllers/calendar_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../widgets/day_cell_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

class CalendarView extends StatefulWidget { // CalendarView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  const CalendarView({super.key}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late final CalendarController _controller;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _controller = CalendarController();
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
        title: Text(AppStrings.calendarTitle, style: style.headerFont), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      floatingActionButton: _buildCalendarFab(style),
      body: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        children: [
          _buildMonthHeader(),
          _buildWeekDays(),
          _buildCalendarGrid(),
          const Divider(height: 16), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
          _buildSelectedDayHeader(style),
          Expanded(child: _buildEntriesListForDay()), // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
        ],
      ),
    );
  }

  Widget _buildCalendarFab(dynamic style) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
          MaterialPageRoute(
            builder: (_) => EntryEditorView(
              targetDate: _controller.selectedDateNotifier.value,
            ),
          ),
        );
      },
      backgroundColor: context.colors.primary,
      foregroundColor: context.colors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        side: BorderSide(color: style.borderColor, width: style.borderWidth),
      ),
      icon: const Icon(Icons.add),
      label: const Text('Bu Güne Yaz'),
    );
  }

  Widget _buildMonthHeader() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.focusedDateNotifier,
      builder: (context, date, _) {
        final months = [
          'Ocak',
          'Şubat',
          'Mart',
          'Nisan',
          'Mayıs',
          'Haziran',
          'Temmuz',
          'Ağustos',
          'Eylül',
          'Ekim',
          'Kasım',
          'Aralık'
        ];
        return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
            children: [
              IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _controller.changeMonth(-1),
              ),
              Text(
                '${months[date.month - 1]} ${date.year}',
                style: context.journalStyle.headerFont.copyWith(fontSize: 18.0), // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
              ),
              IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _controller.changeMonth(1),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeekDays() {
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
        children: days.map((d) {
          return SizedBox(
            width: 40,
            child: Text(
              d,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: context.colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.focusedDateNotifier,
      builder: (context, focused, _) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: _controller.selectedDateNotifier,
          builder: (context, selected, _) {
            final firstDayOfMonth = DateTime(focused.year, focused.month, 1);
            final startingWeekday = firstDayOfMonth.weekday; // 1: Pzt, 7: Paz
            final daysInMonth =
                DateTime(focused.year, focused.month + 1, 0).day;

            return GridView.builder( // Elemanları ızgara (grid) düzeninde performanslı şekilde listelemek için kullanıyoruz
              shrinkWrap: true, // Listenin sadece elemanları kadar yer kaplamasını sağlıyoruz, taşmasın diye
              physics: const NeverScrollableScrollPhysics(), // Kendi içinde kaydırılmasını engelleyip dıştaki kaydırıcıya bırakıyoruz
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.1,
              ),
              itemCount: 35, // 5 hafta görünümü
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final dayNumber = index - (startingWeekday - 1) + 1;
                final isCurrentMonth = dayNumber >= 1 && dayNumber <= daysInMonth;

                final cellDate = isCurrentMonth
                    ? DateTime(focused.year, focused.month, dayNumber)
                    : (dayNumber < 1
                        ? DateTime(focused.year, focused.month, dayNumber)
                        : DateTime(
                            focused.year, focused.month + 1, dayNumber - daysInMonth));

                final isSelected = cellDate.isSameDay(selected);
                final hasEntries = _controller.hasEntriesOnDay(cellDate);
                final mood = _controller.getMoodForDay(cellDate);

                return DayCellWidget(
                  date: cellDate,
                  isSelected: isSelected,
                  isCurrentMonth: isCurrentMonth,
                  hasEntries: hasEntries,
                  mood: mood,
                  onTap: () => _controller.selectDate(cellDate),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedDayHeader(dynamic style) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.selectedDateNotifier,
      builder: (context, selected, _) {
        final count = _controller.getEntryCountForDay(selected);
        return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
            children: [
              Text(
                selected.toJournalDate(),
                style: style.headerFont.copyWith(fontSize: 14.0), // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
              ),
              Text(
                count > 0 ? '$count Etkinlik / Günlük' : 'Kayıt Yok',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEntriesListForDay() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.selectedDateNotifier,
      builder: (context, selected, _) {
        return ValueListenableBuilder<List<JournalEntry>>(
          valueListenable: _controller.entriesForSelectedDateNotifier,
          builder: (context, entries, _) {
            if (entries.isEmpty) {
              return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                child: Text(
                  'Bu tarihte kayıtlı etkinlik bulunmuyor.\n"Bu Güne Yaz" butonuyla ekleyebilirsiniz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              );
            }
            return ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: entries.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
              itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                final entry = entries[index];
                return EntryCardWidget(
                  entry: entry,
                  onTap: () => Navigator.of(context).push( // Yeni bir sayfaya geçiş yapıp sayfa yığınına (stack) ekliyoruz
                    MaterialPageRoute(
                      builder: (_) => EntryEditorView(initialEntry: entry),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
