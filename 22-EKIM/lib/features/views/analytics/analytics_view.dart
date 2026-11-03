import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:flutter/services.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/habit_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../../models/habit_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/category_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/mood_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class DayHabitStatus {
  final String title; // String türünden title adlı değişkenimiz
  final String categoryName; // String türünden categoryName adlı değişkenimiz
  final Color categoryColor; // Color türünden categoryColor adlı değişkenimiz
  final String iconPath; // String türünden iconPath adlı değişkenimiz
  final String timeRange; // String türünden timeRange adlı değişkenimiz
  final bool isCompleted; // bool türünden isCompleted adlı değişkenimiz

  DayHabitStatus({
    required this.title, // title parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.categoryName, // categoryName parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.categoryColor, // categoryColor parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.iconPath, // iconPath parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.timeRange, // timeRange parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isCompleted, // isCompleted parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });
}

class DayActivityDetail {
  final DateTime date; // DateTime türünden date adlı değişkenimiz
  final int completedCount; // int türünden completedCount adlı değişkenimiz
  final int totalCount; // int türünden totalCount adlı değişkenimiz
  final String? moodKey; // String? türünden moodKey adlı değişkenimiz
  final List<DayHabitStatus> habits; // List<DayHabitStatus> türünden habits adlı değişkenimiz

  DayActivityDetail({
    required this.date, // date parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.completedCount, // completedCount parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.totalCount, // totalCount parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.moodKey, // moodKey alanına değer aktarıyoruz
    required this.habits, // habits parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });
}

class AnalyticsView extends StatefulWidget { // AnalyticsView sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final HabitController? habitController; // HabitController? türünden habitController adlı değişkenimiz

  const AnalyticsView({super.key, this.habitController}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  DateTime? _hoveredDate;

  IconData _getIconData(String iconPath) {
    if (iconPath.contains('sport') || iconPath.contains('run')) {
      return Icons.directions_run_rounded;
    } else if (iconPath.contains('water') || iconPath.contains('su')) {
      return Icons.water_drop_rounded;
    } else if (iconPath.contains('book') || iconPath.contains('kitap') || iconPath.contains('mind')) {
      return Icons.menu_book_rounded;
    } else if (iconPath.contains('music') || iconPath.contains('muzik')) {
      return Icons.music_note_rounded;
    } else if (iconPath.contains('meditation') || iconPath.contains('self_improvement') || iconPath.contains('zihin')) {
      return Icons.self_improvement_rounded;
    } else if (iconPath.contains('apple') || iconPath.contains('besin') || iconPath.contains('restaurant')) {
      return Icons.restaurant_rounded;
    } else if (iconPath.contains('bike') || iconPath.contains('bisiklet')) {
      return Icons.pedal_bike_rounded;
    } else if (iconPath.contains('palette') || iconPath.contains('sanat')) {
      return Icons.palette_rounded;
    } else if (iconPath.contains('code') || iconPath.contains('kod')) {
      return Icons.code_rounded;
    } else if (iconPath.contains('sleep') || iconPath.contains('uyku')) {
      return Icons.bedtime_rounded;
    }
    return Icons.star_rounded;
  }

  DayActivityDetail _calculateDayDetail(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final isFuture = date.isAfter(DateTime(now.year, now.month, now.day));

    final allHabits = widget.habitController?.habitsNotifier.value ?? <HabitModel>[];
    final allCategories = widget.habitController?.categoriesNotifier.value ?? CategoryModel.defaultCategories;

    // O günün haftanın günü (1: Pzt ... 7: Paz)
    final dayOfWeek = date.weekday;
    final scheduledHabits = allHabits.where((h) => h.selectedDays.contains(dayOfWeek)).toList();
    final effectiveHabits = scheduledHabits.isNotEmpty ? scheduledHabits : allHabits;

    if (isFuture) {
      return DayActivityDetail(
        date: date,
        completedCount: 0,
        totalCount: effectiveHabits.length,
        moodKey: null,
        habits: effectiveHabits.map((h) {
          final cat = allCategories.firstWhere(
            (c) => c.id == h.categoryId,
            orElse: () => const CategoryModel(id: 'genel', name: 'Genel', iconPath: '', colorHex: 0xFF4EDEA3),
          );
          return DayHabitStatus(
            title: h.title,
            categoryName: cat.name,
            categoryColor: Color(cat.colorHex),
            iconPath: h.iconPath,
            timeRange: '${h.startTime} - ${h.endTime}',
            isCompleted: false,
          );
        }).toList(),
      );
    }

    if (isToday) {
      final completed = allHabits.where((h) => h.isCompleted).length;
      return DayActivityDetail(
        date: date,
        completedCount: completed,
        totalCount: allHabits.length,
        moodKey: 'great',
        habits: allHabits.map((h) {
          final cat = allCategories.firstWhere(
            (c) => c.id == h.categoryId,
            orElse: () => const CategoryModel(id: 'genel', name: 'Genel', iconPath: '', colorHex: 0xFF4EDEA3),
          );
          return DayHabitStatus(
            title: h.title,
            categoryName: cat.name,
            categoryColor: Color(cat.colorHex),
            iconPath: h.iconPath,
            timeRange: '${h.startTime} - ${h.endTime}',
            isCompleted: h.isCompleted,
          );
        }).toList(),
      );
    }

    // Geçmiş günler için gerçekçi simülasyon ve alışkanlık eşleştirmesi
    final habitStatuses = <DayHabitStatus>[];
    int completedCount = 0; // int türünden completedCount değişkenimiz

    for (int i = 0; i < effectiveHabits.length; i++) {
      final h = effectiveHabits[i];
      final cat = allCategories.firstWhere(
        (c) => c.id == h.categoryId,
        orElse: () => const CategoryModel(id: 'genel', name: 'Genel', iconPath: '', colorHex: 0xFF4EDEA3),
      );
      // Gün ve index bazlı tutarlı tamamlama simülasyonu
      final isDone = ((date.day * 3 + i * 2) % 4) != 0;
      if (isDone) completedCount++;

      habitStatuses.add(DayHabitStatus(
        title: h.title,
        categoryName: cat.name,
        categoryColor: Color(cat.colorHex),
        iconPath: h.iconPath,
        timeRange: '${h.startTime} - ${h.endTime}',
        isCompleted: isDone,
      ));
    }

    // Mood eşleştirmesi
    const moods = ['great', 'good', 'neutral', 'good', 'great'];
    final mood = moods[(date.day + date.weekday) % moods.length];

    return DayActivityDetail(
      date: date,
      completedCount: completedCount,
      totalCount: effectiveHabits.length,
      moodKey: mood,
      habits: habitStatuses,
    );
  }

  void _showDayDetailsModal(BuildContext context, DayActivityDetail detail, bool isDark) {
    HapticFeedback.lightImpact();

    const trDays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    final dayName = trDays[detail.date.weekday - 1];
    const trMonths = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final monthName = trMonths[detail.date.month - 1];

    final ratio = detail.totalCount > 0 ? (detail.completedCount / detail.totalCount) : 0.0;
    final percent = (ratio * 100).toInt();

    final moodItem = MoodItem.allMoods.cast<MoodItem?>().firstWhere(
          (m) => m?.keyName == detail.moodKey,
          orElse: () => null,
        );

    showModalBottomSheet( // Ekranın altından yukarı doğru açılan modal form penceresi
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusModal)),
            border: Border.all(
              color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              // Tutma Çubuğu (Drag Handle)
              Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  ),
                ),
              ),
              const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // Tarih ve Tamamlama Özeti Başlığı
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                crossAxisAlignment: CrossAxisAlignment.center, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                children: [
                  Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                    child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                      crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                      children: [
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.primary),
                            const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Text(
                              '${detail.date.day} $monthName ${detail.date.year}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                          padding: const EdgeInsets.only(left: 26.0),
                          child: Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '${detail.completedCount} / ${detail.totalCount} (%$percent)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // O günün mood durumu
              if (moodItem != null)
                Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: moodItem.activeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    border: Border.all(color: moodItem.activeColor.withValues(alpha: 0.25)),
                  ),
                  child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: [
                      Text(moodItem.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        'Günün Modu: ${moodItem.label}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: moodItem.activeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                'Alışkanlık Durumları',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              // Alışkanlıklar Listesi
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true, // Listenin sadece elemanları kadar yer kaplamasını sağlıyoruz, taşmasın diye
                  physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
                  itemCount: detail.habits.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                  separatorBuilder: (_, _) => const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  itemBuilder: (context, idx) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                    final habit = detail.habits[idx];
                    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        border: Border.all(
                          color: habit.isCompleted
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                        ),
                      ),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        children: [
                          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                              color: habit.categoryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            ),
                            child: Icon(_getIconData(habit.iconPath), color: habit.categoryColor, size: 18),
                          ),
                          const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                              children: [
                                Text(
                                  habit.title,
                                  maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                  overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    decoration: habit.isCompleted ? TextDecoration.none : null,
                                    color: isDark ? AppColors.onSurface : AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                  children: [
                                    Text(
                                      habit.categoryName,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: habit.categoryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Text(
                                      '•  ${habit.timeRange}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                              color: habit.isCompleted
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : (isDark ? AppColors.surfaceContainerHighest : Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            ),
                            child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  habit.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                  size: 14,
                                  color: habit.isCompleted ? AppColors.primary : AppColors.outline,
                                ),
                                const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                Text(
                                  habit.isCompleted ? 'Tamamlandı' : 'Yapılmadı',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: habit.isCompleted ? AppColors.primary : AppColors.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              SizedBox(
                width: double.infinity,
                child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  ),
                  onPressed: () => Navigator.pop(ctx), // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
                  child: const Text('Kapat', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    const trMonths = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final currentMonthName = trMonths[now.month - 1];

    final hoveredDetail = _hoveredDate != null ? _calculateDayDetail(_hoveredDate!) : null;

    return Scaffold( // Sayfa iskeletini (appBar, body, floatingActionButton) oluşturan ana Scaffold widget'ımız
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar( // Sayfanın üst kısmındaki başlık ve aksiyon barı (AppBar)
        title: const Text('İstatistik & Analiz'), // Sayfa başlığını ekrana yazdırıyoruz
      ),
      body: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
          physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma kaydırma efekti veriyoruz
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              // Metrik Özet Kartları
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                children: [
                  _buildMetricCard(context, '%82', 'Haftalık Başarı', Icons.track_changes, AppColors.primary, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  _buildMetricCard(context, '18 Gün', 'En Uzun Seri', Icons.local_fire_department, AppColors.secondary, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                  const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  _buildMetricCard(context, '6.5 Sa', 'Odaklanma', Icons.timer, AppColors.tertiary, isDark), // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
                ],
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Haftalık Tamamlama Bar Grafiği
              Text(
                'Haftalık Tamamlanma Grafiği',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
                            final idx = val.toInt();
                            if (idx >= 0 && idx < days.length) {
                              return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  days[idx],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _makeBarGroup(0, 70, isDark),
                      _makeBarGroup(1, 100, isDark),
                      _makeBarGroup(2, 60, isDark),
                      _makeBarGroup(3, 85, isDark),
                      _makeBarGroup(4, 90, isDark),
                      _makeBarGroup(5, 50, isDark),
                      _makeBarGroup(6, 80, isDark),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Kategori Dağılımı Donut Grafiği
              Text(
                'Kategori Dağılımı',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 36,
                          sections: [
                            PieChartSectionData(color: AppColors.categorySport, value: 35, showTitle: false, radius: 18),
                            PieChartSectionData(color: AppColors.categoryHealth, value: 25, showTitle: false, radius: 18),
                            PieChartSectionData(color: AppColors.categoryMind, value: 20, showTitle: false, radius: 18),
                            PieChartSectionData(color: AppColors.categoryMusic, value: 12, showTitle: false, radius: 18),
                            PieChartSectionData(color: AppColors.secondary, value: 8, showTitle: false, radius: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          _buildLegendRow('Spor (%35)', AppColors.categorySport, isDark), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          _buildLegendRow('Sağlık (%25)', AppColors.categoryHealth, isDark), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          _buildLegendRow('Zihin (%20)', AppColors.categoryMind, isDark), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          _buildLegendRow('Müzik (%12)', AppColors.categoryMusic, isDark), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          _buildLegendRow('Diğer (%8)', AppColors.secondary, isDark), // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Aylık Aktivite Izgarası (Heatmap)
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                children: [
                  Text(
                    'Aylık Aktivite Izgarası ($currentMonthName ${now.year})',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                    ),
                  ),
                  const Text(
                    'Detay için dokun',
                    style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    // Canlı Hover / Önizleme Bilgi Çubuğu
                    AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: hoveredDetail != null
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : (isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight),
                        borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        border: Border.all(
                          color: hoveredDetail != null
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        children: [
                          Icon(
                            hoveredDetail != null ? Icons.touch_app_rounded : Icons.info_outline,
                            size: 16,
                            color: hoveredDetail != null ? AppColors.primary : AppColors.outline,
                          ),
                          const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                            child: Text(
                              hoveredDetail != null
                                  ? '${hoveredDetail.date.day} $currentMonthName: ${hoveredDetail.completedCount} alışkanlık tamamlandı (Detaylar için tıkla)'
                                  : 'Günün üzerine gelerek veya tıklayarak detayları görüntüleyin',
                              maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                              overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: hoveredDetail != null ? FontWeight.bold : FontWeight.w500,
                                color: hoveredDetail != null
                                    ? AppColors.primary
                                    : (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gün İsimleri Başlığı (Pzt, Sal, Çar, Per, Cum, Cmt, Paz)
                    Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        children: const [
                          'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'
                        ].map((d) => Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                          child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                            child: Text(
                              d,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.outline,
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                    // 7 Kolonlu Aylık Izgara
                    _buildMonthCalendarGrid(context, now, daysInMonth, isDark, currentMonthName),
                    const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    // Renk Yoğunluğu Skalası (Legend)
                    Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      mainAxisAlignment: MainAxisAlignment.end, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        Text(
                          'Daha Az',
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
                        ),
                        const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        _buildLegendBox(isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight),
                        const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        _buildLegendBox(AppColors.primary.withValues(alpha: 0.25)),
                        const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        _buildLegendBox(AppColors.primary.withValues(alpha: 0.50)),
                        const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        _buildLegendBox(AppColors.primary.withValues(alpha: 0.75)),
                        const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        _buildLegendBox(AppColors.primary),
                        const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Text(
                          'Daha Çok',
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCalendarGrid(
    BuildContext context,
    DateTime now,
    int daysInMonth,
    bool isDark,
    String currentMonthName,
  ) {
    // Ayın 1. gününün haftanın günü (1: Pzt ... 7: Paz)
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final leadingEmptyDays = firstDayOfMonth.weekday - 1; // 0..6
    final totalCells = leadingEmptyDays + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
      children: List.generate(rowCount, (rowIndex) {
        return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - leadingEmptyDays + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 36)); // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              }

              final cellDate = DateTime(now.year, now.month, dayNumber);
              final isToday = cellDate.day == now.day && cellDate.month == now.month && cellDate.year == now.year;
              final isFuture = cellDate.isAfter(DateTime(now.year, now.month, now.day));
              final detail = _calculateDayDetail(cellDate);

              Color cellColor;
              if (isFuture) {
                cellColor = (isDark ? AppColors.surfaceContainerLowest : AppColors.surfaceVariantLight).withValues(alpha: 0.5);
              } else if (detail.completedCount == 0) {
                cellColor = isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight;
              } else if (detail.completedCount == 1) {
                cellColor = AppColors.primary.withValues(alpha: 0.25);
              } else if (detail.completedCount == 2) {
                cellColor = AppColors.primary.withValues(alpha: 0.50);
              } else if (detail.completedCount == 3) {
                cellColor = AppColors.primary.withValues(alpha: 0.75);
              } else {
                cellColor = AppColors.primary;
              }

              final textColor = (detail.completedCount >= 3)
                  ? AppColors.onPrimary
                  : (isDark ? AppColors.onSurface : AppColors.textLight);

              final tooltipMessage = isFuture
                  ? '$dayNumber $currentMonthName: Gelecek Gün'
                  : '$dayNumber $currentMonthName: ${detail.completedCount} alışkanlık yapıldı\nDetaylar için dokunun';

              return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Tooltip(
                    message: tooltipMessage,
                    waitDuration: const Duration(milliseconds: 100),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                          _hoveredDate = cellDate;
                        });
                      },
                      onExit: (_) {
                        setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                          if (_hoveredDate == cellDate) _hoveredDate = null;
                        });
                      },
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () => _showDayDetailsModal(context, detail, isDark),
                        child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          duration: const Duration(milliseconds: 150),
                          height: 36,
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: cellColor,
                            borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            border: Border.all(
                              color: isToday
                                  ? AppColors.secondary
                                  : (_hoveredDate == cellDate ? AppColors.primary : Colors.transparent),
                              width: isToday ? 2.0 : 1.2,
                            ),
                          ),
                          child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                            child: Text(
                              '$dayNumber',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: (isToday || detail.completedCount >= 3) ? FontWeight.bold : FontWeight.w500,
                                color: isFuture ? AppColors.outline.withValues(alpha: 0.5) : textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      width: 14,
      height: 14,
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: color,
        borderRadius: BorderRadius.circular(3), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String value, String label, IconData icon, Color color, bool isDark) { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
        ),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.onSurface : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, bool isDark) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y == 100 ? AppColors.secondary : AppColors.primary,
          width: 14,
          borderRadius: BorderRadius.circular(4), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendRow(String title, Color color, bool isDark) { // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      children: [
        Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle), // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        ),
        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
