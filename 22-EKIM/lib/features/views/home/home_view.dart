import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:flutter/services.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import '../../../core/theme/app_theme.dart';
import '../../controllers/habit_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../../controllers/mood_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../../models/habit_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/category_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/mood_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../widgets/mood_selector_widget.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../../widgets/daily_mood_dialog.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../../widgets/daily_calendar_strip.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../../widgets/habit_item_card.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../../widgets/confirmation_dialog.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz
import '../habit_form/add_edit_habit_view.dart'; // Sayfa ve ekran tasarım dosyalarımızı bu dosyaya import ediyoruz

class HomeView extends StatefulWidget { // HomeView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final HabitController habitController; // HabitController türünden habitController adlı değişkenimiz
  final MoodController moodController; // MoodController türünden moodController adlı değişkenimiz

  const HomeView({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.habitController, // habitController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.moodController, // moodController parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  HabitController get _habitController => widget.habitController;
  MoodController get _moodController => widget.moodController;

  bool _isCompletedExpanded = true; // Durum kontrolü için tuttuğumuz bool bayrağımız (_isCompletedExpanded)

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDailyMoodPrompt();
    });
  }

  Future<void> _handleHabitToggle(HabitModel habit) async {
    HapticFeedback.lightImpact();
    if (!habit.isCompleted) {
      final confirmed = await ConfirmationDialog.show(
        context: context,
        title: 'Alışkanlığı Onayla?',
        message: '"${habit.title}" alışkanlığını tamamlandı olarak onaylamak istiyor musunuz? Tamamlananlar altına taşınacaktır.',
        confirmText: 'Evet, Tamamla',
        cancelText: 'Vazgeç',
        confirmColor: AppColors.primary,
        icon: Icons.check_circle_outline_rounded,
        iconColor: AppColors.primary,
      );
      if (confirmed) {
        _habitController.toggleHabit(habit.id);
      }
    } else {
      final confirmed = await ConfirmationDialog.show(
        context: context,
        title: 'Yapılacaklara Geri Al?',
        message: '"${habit.title}" alışkanlığını tamamlananlardan çıkarıp tekrar yapılacaklar listesine almak istiyor musunuz?',
        confirmText: 'Geri Al',
        cancelText: 'Vazgeç',
        confirmColor: AppColors.secondary,
        icon: Icons.replay_rounded,
        iconColor: AppColors.secondary,
      );
      if (confirmed) {
        _habitController.toggleHabit(habit.id);
      }
    }
  }

  Future<void> _handleHabitDelete(HabitModel habit) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Alışkanlığı Sil?',
      message: '"${habit.title}" alışkanlığını verilerden kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
      confirmText: 'Evet, Sil',
      cancelText: 'Vazgeç',
      confirmColor: AppColors.danger,
      icon: Icons.delete_forever_rounded,
      iconColor: AppColors.danger,
      isDestructive: true,
    );
    if (confirmed) {
      _habitController.deleteHabit(habit.id);
    }
  }

  Future<void> _handleHabitIncrement(HabitModel habit, double step) async {
    final willComplete = (habit.currentProgress + step) >= habit.targetProgress;
    if (willComplete && !habit.isCompleted) {
      final confirmed = await ConfirmationDialog.show(
        context: context,
        title: 'Hedefe Ulaşıldı!',
        message: '"${habit.title}" hedefini (${habit.targetProgress.toInt()} ${habit.unit}) tamamladınız! Bu alışkanlığı tamamlandı olarak onaylamak istiyor musunuz?',
        confirmText: 'Onayla ve Tamamla',
        cancelText: 'Vazgeç',
        confirmColor: AppColors.primary,
        icon: Icons.emoji_events_rounded,
        iconColor: AppColors.primary,
      );
      if (confirmed) {
        _habitController.incrementProgress(habit.id, step);
      }
    } else {
      _habitController.incrementProgress(habit.id, step);
    }
  }

  void _checkAndShowDailyMoodPrompt() {
    if (!mounted) return;
    if (_moodController.shouldPromptDailyMoodNotifier.value) {
      DailyMoodDialog.show(
        context,
        currentMood: _moodController.todayMoodNotifier.value,
        onMoodSelected: _moodController.setTodayMood,
        onDismiss: _moodController.dismissDailyPrompt,
      );
    }
  }

  void _openAddHabitModal([HabitModel? habitToEdit]) {
    showModalBottomSheet( // Ekranın altından yukarı doğru açılan modal form penceresi
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddEditHabitModal(
        existingHabit: habitToEdit,
        categories: _habitController.categoriesNotifier.value,
        onSave: (habit) {
          if (habitToEdit == null) {
            _habitController.addHabit(habit);
          } else {
            _habitController.deleteHabit(habitToEdit.id);
            _habitController.addHabit(habit);
          }
        },
        onDelete: habitToEdit != null ? () => _habitController.deleteHabit(habitToEdit.id) : null,
        onCategoryAdded: (cat) => _habitController.addCategory(cat),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final catController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    showDialog( // Ekranda açılır bir diyalog penceresi görüntülemek için showDialog fonksiyonunu çağırıyoruz
      context: context,
      builder: (ctx) => AlertDialog( // Kullanıcıya uyarı veya onay penceresi göstermek için AlertDialog açıyoruz
        backgroundColor: AppColors.surfaceContainer,
        title: const Text('Yeni Kategori Ekle', style: TextStyle(color: AppColors.onSurface)), // Sayfa başlığını ekrana yazdırıyoruz
        content: TextField( // Kullanıcıdan metin girdisi almak için form alanı
          controller: catController,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: const InputDecoration(
            hintText: 'Kategori Adı (Örn: Sanat, Dil...)',
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
        actions: [
          TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
            onPressed: () => Navigator.pop(ctx), // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
            child: const Text('Vazgeç', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            onPressed: () {
              final name = catController.text.trim();
              if (name.isNotEmpty) {
                final newCat = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  iconPath: 'assets/icons/custom.svg',
                  colorHex: 0xFF4EDEA3,
                  isCustom: true,
                );
                _habitController.addCategory(newCat);
                Navigator.pop(ctx); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
              }
            },
            child: const Text('Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
          physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              _buildTopHeader(isDark),
              const SizedBox(height: AppSizes.spaceLg), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              ValueListenableBuilder<String?>(
                valueListenable: _moodController.todayMoodNotifier,
                builder: (context, currentMood, _) {
                  if (currentMood == null) {
                    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                      padding: const EdgeInsets.only(bottom: AppSizes.spaceLg),
                      child: MoodSelectorWidget(
                        selectedMood: currentMood,
                        onMoodSelected: _moodController.setTodayMood,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              DailyCalendarStrip(
                selectedDateNotifier: _habitController.selectedDateNotifier,
                onDateSelected: _habitController.changeSelectedDate,
              ),
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              _buildCategoryFilterBar(isDark),
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              _buildProgressOverview(isDark),
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              _buildHabitsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton( // Sayfanın üzerinde yüzen hızlı aksiyon butonu (FAB)
        backgroundColor: AppColors.primary,
        onPressed: () => _openAddHabitModal(),
        child: const Icon(Icons.add, color: AppColors.onPrimary, size: 28),
      ),
    );
  }

  Widget _buildTopHeader(bool isDark) {
    final now = DateTime.now();
    const trMonths = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final dateStr = 'Bugün, ${now.day} ${trMonths[now.month - 1]}';

    return ValueListenableBuilder<String?>(
      valueListenable: _moodController.todayMoodNotifier,
      builder: (context, currentMood, _) {
        final moodItem = MoodItem.allMoods.cast<MoodItem?>().firstWhere(
              (m) => m?.keyName == currentMood,
              orElse: () => null,
            );

        return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
          crossAxisAlignment: CrossAxisAlignment.center, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                children: [
                  Text(
                    dateStr,
                    maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                    overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    moodItem != null ? '${moodItem.label} Bir Gün!' : 'Harika Bir Gün!',
                    maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                    overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                      letterSpacing: -0.01,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              mainAxisSize: MainAxisSize.min,
              children: [
                if (moodItem != null)
                  GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                    onTap: () {
                      HapticFeedback.selectionClick();
                      DailyMoodDialog.show(
                        context,
                        currentMood: currentMood,
                        onMoodSelected: _moodController.setTodayMood,
                        onDismiss: () {},
                      );
                    },
                    child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: moodItem.activeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        border: Border.all(color: moodItem.activeColor.withValues(alpha: 0.3)),
                      ),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(moodItem.emoji, style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Text(
                            moodItem.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: moodItem.activeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                  ),
                  child: const Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.secondary),
                      SizedBox(width: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        '12G',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: const Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, size: 16, color: AppColors.primary),
                      SizedBox(width: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        'Lv.3',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryFilterBar(bool isDark) {
    return ValueListenableBuilder<List<CategoryModel>>(
      valueListenable: _habitController.categoriesNotifier,
      builder: (context, categories, _) {
        return ValueListenableBuilder<String>(
          valueListenable: _habitController.selectedCategoryNotifier,
          builder: (context, selectedId, _) {
            return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
              child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                children: [
                  _buildCustomChip(
                    label: 'Tümü',
                    isSelected: selectedId == 'all',
                    activeColor: AppColors.primary,
                    onTap: () => _habitController.filterByCategory('all'),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  ...categories.map((cat) {
                    final isSelected = selectedId == cat.id;
                    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildCustomChip(
                        label: cat.name,
                        isSelected: isSelected,
                        activeColor: Color(cat.colorHex),
                        onTap: () => _habitController.filterByCategory(cat.id),
                        isDark: isDark,
                      ),
                    );
                  }),
                  GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                    onTap: _showAddCategoryDialog,
                    child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                      ),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        children: [
                          Icon(Icons.add, size: 16, color: isDark ? AppColors.onSurface : AppColors.textLight),
                          const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Text(
                            'Kategori',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.onSurface : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCustomChip({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: onTap,
      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isSelected
              ? activeColor
              : (isDark ? AppColors.surfaceContainer : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppColors.onPrimary
                : (isDark ? AppColors.onSurface : AppColors.textLight),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview(bool isDark) {
    return ValueListenableBuilder<List<HabitModel>>(
      valueListenable: _habitController.habitsNotifier,
      builder: (context, habits, _) {
        if (habits.isEmpty) return const SizedBox.shrink();
        final completed = habits.where((h) => h.isCompleted).length;
        final ratio = habits.isEmpty ? 0.0 : completed / habits.length;

        return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
          ),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            children: [
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                children: [
                  Flexible(
                    child: Text(
                      'Günün İlerlemesi: $completed / ${habits.length}',
                      maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                      overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.onSurface : AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    '%${(ratio * 100).toInt()}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              ClipRRect(
                borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<HabitModel>>(
      valueListenable: _habitController.habitsNotifier,
      builder: (context, allHabits, _) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: _habitController.selectedDateNotifier,
          builder: (context, selectedDate, _) {
            return ValueListenableBuilder<String>(
              valueListenable: _habitController.selectedCategoryNotifier,
              builder: (context, selectedCategory, _) {
                final dayOfWeek = selectedDate.weekday; // 1: Pazartesi ... 7: Pazar

                // Gün ve Kategoriye göre filtrele
                final habits = allHabits.where((h) {
                  final matchesDay = h.selectedDays.contains(dayOfWeek);
                  final matchesCategory = selectedCategory == 'all' || h.categoryId == selectedCategory;
                  return matchesDay && matchesCategory;
                }).toList();

                if (habits.isEmpty) {
                  return Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                    child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                      padding: const EdgeInsets.all(32.0),
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        children: [
                          Icon(Icons.checklist_rtl_rounded, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          const Text(
                            'Bu gün veya kategoride alışkanlık yok.',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          TextButton.icon(
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Yeni Alışkanlık Ekle'),
                            onPressed: () => _openAddHabitModal(),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final uncompletedHabits = habits.where((h) => !h.isCompleted).toList();
                final completedHabits = habits.where((h) => h.isCompleted).toList();

                return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    // 1. YAPILACAKLAR (YAPILMAYANLAR) BÖLÜMÜ
                    if (uncompletedHabits.isNotEmpty) ...[
                      Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            Text(
                              'Yapılacaklar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              ),
                              child: Text(
                                '${uncompletedHabits.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.primary : AppColors.inversePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...uncompletedHabits.map((habit) {
                        final cat = _habitController.categoriesNotifier.value.firstWhere(
                          (c) => c.id == habit.categoryId,
                          orElse: () => const CategoryModel(
                            id: 'unknown',
                            name: 'Genel',
                            iconPath: '',
                            colorHex: 0xFF4EDEA3,
                          ),
                        );

                        return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                          onTap: () => _openAddHabitModal(habit),
                          child: HabitItemCard( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                            habit: habit,
                            categoryName: cat.name,
                            categoryColor: Color(cat.colorHex),
                            onToggle: () => _handleHabitToggle(habit),
                            onDelete: () => _handleHabitDelete(habit),
                            onIncrement: () => _handleHabitIncrement(habit, 250),
                            onDecrement: () => _habitController.decrementProgress(habit.id, 250),
                          ),
                        );
                      }),
                    ] else if (completedHabits.isNotEmpty) ...[
                      // Tüm alışkanlıklar yapıldığında tebrik kartı
                      Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                        margin: const EdgeInsets.only(bottom: AppSizes.spaceMd),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: AppColors.primary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.celebration_rounded, color: AppColors.primary, size: 24),
                            ),
                            const SizedBox(width: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                                children: [
                                  Text(
                                    'Tüm Alışkanlıklar Tamamlandı! 🎉',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                                    ),
                                  ),
                                  const SizedBox(height: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                  Text(
                                    'Bugünün hedeflerini başarıyla bitirdin, harika bir disiplin!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 2. TAMAMLANANLAR (YAPILANLAR) - AÇILIR LİSTE (COLLAPSIBLE)
                    if (completedHabits.isNotEmpty) ...[
                      const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                            _isCompletedExpanded = !_isCompletedExpanded;
                          });
                        },
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            border: Border.all(
                              color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            children: [
                              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
                              ),
                              const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                  children: [
                                    Text(
                                      'Tamamlananlar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.onSurface : AppColors.textLight,
                                      ),
                                    ),
                                    const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                        color: AppColors.primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                                      ),
                                      child: Text(
                                        '${completedHabits.length}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedRotation(
                                turns: _isCompletedExpanded ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Açılır liste kartları
                      if (_isCompletedExpanded)
                        ...completedHabits.map((habit) {
                          final cat = _habitController.categoriesNotifier.value.firstWhere(
                            (c) => c.id == habit.categoryId,
                            orElse: () => const CategoryModel(
                              id: 'unknown',
                              name: 'Genel',
                              iconPath: '',
                              colorHex: 0xFF4EDEA3,
                            ),
                          );

                          return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                            onTap: () => _openAddHabitModal(habit),
                            child: HabitItemCard( // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                              habit: habit,
                              categoryName: cat.name,
                              categoryColor: Color(cat.colorHex),
                              onToggle: () => _handleHabitToggle(habit),
                              onDelete: () => _handleHabitDelete(habit),
                              onIncrement: () => _handleHabitIncrement(habit, 250),
                              onDecrement: () => _habitController.decrementProgress(habit.id, 250),
                            ),
                          );
                        }),
                    ],
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
