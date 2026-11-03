import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../controllers/entry_editor_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../models/journal_entry_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../widgets/mood_picker_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../widgets/text_formatting_bar.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

/// Günlük Yazma ve Düzenleme Ekranı (Clean UI, 40 satır altı build kuralına sadık).
class EntryEditorView extends StatefulWidget { // EntryEditorView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final JournalEntry? initialEntry; // JournalEntry? türünden initialEntry adlı değişkenimiz
  final DateTime? targetDate; // DateTime? türünden targetDate adlı değişkenimiz
  final String? initialMood; // String? türünden initialMood adlı değişkenimiz

  const EntryEditorView({ // Genel, sabit sınıf constructor'ı
    super.key,
    this.initialEntry, // initialEntry alanına değer aktarıyoruz
    this.targetDate, // targetDate alanına değer aktarıyoruz
    this.initialMood, // initialMood alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<EntryEditorView> createState() => _EntryEditorViewState();
}

class _EntryEditorViewState extends State<EntryEditorView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  late final EntryEditorController _controller;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagController;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    _controller = EntryEditorController(
      initialEntry: widget.initialEntry,
      targetDate: widget.targetDate,
      initialMood: widget.initialMood,
    );
    _titleController =
        TextEditingController(text: widget.initialEntry?.title ?? '');
    _contentController =
        TextEditingController(text: widget.initialEntry?.content ?? '');
    _tagController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _controller.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: _buildAppBarTitle(style),
        actions: [
          _buildSaveAction(),
        ],
      ),
      body: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
        padding: const EdgeInsets.all(16),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          crossAxisAlignment: CrossAxisAlignment.stretch, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            MoodPickerWidget(
              selectedMoodNotifier: _controller.selectedMoodNotifier,
              onMoodSelected: _controller.setMood,
            ),
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            _buildTitleInput(style),
            const Divider(height: 24), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
            _buildFormattingRow(), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            _buildContentInput(style),
            const Divider(height: 24), // Bölümler arasına ince bir ayırıcı çizgi çekmek için
            _buildTagsSection(style),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(dynamic style) {
    final effectiveDate =
        widget.initialEntry?.createdAt ?? widget.targetDate;

    if (effectiveDate != null) {
      return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          Text(
            widget.initialEntry == null
                ? AppStrings.newEntryTitle
                : AppStrings.editEntryTitle,
            style: style.headerFont.copyWith(fontSize: 16.0), // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
          ),
          Text(
            effectiveDate.toJournalDate(),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: context.colors.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ],
      );
    }

    return Text(
      widget.initialEntry == null
          ? AppStrings.newEntryTitle
          : AppStrings.editEntryTitle,
      style: style.headerFont,
    );
  }

  Widget _buildSaveAction() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isSavingNotifier,
      builder: (context, isSaving, _) {
        if (isSaving) {
          return const Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
            child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2), // Veri yüklenirken kullanıcıya işlemin sürdüğünü gösteren yuvarlak animasyon
              ),
            ),
          );
        }
        return IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
          icon: const Icon(Icons.check),
          tooltip: AppStrings.saveButton,
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final navigator = Navigator.of(context);
            final errorColor = context.colors.error;

            final success = await _controller.saveEntry();
            if (!mounted) return;

            if (success) {
              messenger.showSnackBar(
                const SnackBar(content: Text(AppStrings.saveSuccess)),
              );
              navigator.pop();
            } else if (_controller.errorMessageNotifier.value != null) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(_controller.errorMessageNotifier.value!),
                  backgroundColor: errorColor,
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildTitleInput(dynamic style) {
    return TextField( // Kullanıcıdan metin girdisi almak için form alanı
      controller: _titleController,
      onChanged: _controller.updateTitle,
      style: style.headerFont.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
        fontSize: 22.0,
        color: context.colors.onSurface,
      ),
      decoration: const InputDecoration(
        hintText: AppStrings.titleHint,
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildFormattingRow() { // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
    return Align(
      alignment: Alignment.centerLeft,
      child: TextFormattingBar(
        onAddDate: () {
          final stamp = '\n📅 ${DateTime.now().toJournalDate()}\n';
          _contentController.text += stamp;
          _controller.updateContent(_contentController.text);
        },
        onAddBullet: () {
          _contentController.text += '\n• ';
          _controller.updateContent(_contentController.text);
        },
        onAddQuote: () {
          _contentController.text += '\n> "';
          _controller.updateContent(_contentController.text);
        },
      ),
    );
  }

  Widget _buildContentInput(dynamic style) {
    return TextField( // Kullanıcıdan metin girdisi almak için form alanı
      controller: _contentController,
      onChanged: _controller.updateContent,
      maxLines: null, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
      minLines: 8,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
        fontSize: 16.0,
        height: 1.5,
        color: context.colors.onSurface.withValues(alpha: 0.9),
      ),
      decoration: const InputDecoration(
        hintText: AppStrings.contentHint,
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildTagsSection(dynamic style) {
    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
      children: [
        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: [
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
                controller: _tagController,
                decoration: const InputDecoration(
                  hintText: AppStrings.tagHint,
                  border: InputBorder.none,
                ),
                onSubmitted: (tag) {
                  _controller.addTag(tag);
                  _tagController.clear();
                },
              ),
            ),
            IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
              icon: const Icon(Icons.add),
              onPressed: () {
                _controller.addTag(_tagController.text);
                _tagController.clear();
              },
            ),
          ],
        ),
        ValueListenableBuilder<List<String>>(
          valueListenable: _controller.tagsNotifier,
          builder: (context, tags, _) {
            if (tags.isEmpty) return const SizedBox.shrink();
            return Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
              spacing: 6,
              children: tags.map((tag) {
                return Chip(
                  label: Text('#$tag'),
                  onDeleted: () => _controller.removeTag(tag),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(style.borderRadius / 2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
