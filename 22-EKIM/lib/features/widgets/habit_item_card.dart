import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:flutter/services.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../models/habit_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import 'streak_badge.dart';
import 'confirmation_dialog.dart';

class HabitItemCard extends StatelessWidget { // HabitItemCard sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final HabitModel habit; // HabitModel türünden habit adlı değişkenimiz
  final String categoryName; // String türünden categoryName adlı değişkenimiz
  final Color categoryColor; // Color türünden categoryColor adlı değişkenimiz
  final VoidCallback onToggle; // VoidCallback türünden onToggle adlı değişkenimiz
  final VoidCallback onDelete; // VoidCallback türünden onDelete adlı değişkenimiz
  final VoidCallback? onIncrement; // VoidCallback? türünden onIncrement adlı değişkenimiz
  final VoidCallback? onDecrement; // VoidCallback? türünden onDecrement adlı değişkenimiz

  const HabitItemCard({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.habit, // habit parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.categoryName, // categoryName parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.categoryColor, // categoryColor parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onToggle, // onToggle parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onDelete, // onDelete parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.onIncrement, // onIncrement alanına değer aktarıyoruz
    this.onDecrement, // onDecrement alanına değer aktarıyoruz
  });

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
    } else if (iconPath.contains('bike') || iconPath.contains('pedal_bike') || iconPath.contains('bisiklet')) {
      return Icons.pedal_bike_rounded;
    } else if (iconPath.contains('palette') || iconPath.contains('sanat') || iconPath.contains('art')) {
      return Icons.palette_rounded;
    } else if (iconPath.contains('code') || iconPath.contains('kod')) {
      return Icons.code_rounded;
    } else if (iconPath.contains('sleep') || iconPath.contains('uyku') || iconPath.contains('bedtime')) {
      return Icons.bedtime_rounded;
    }
    return Icons.star_rounded;
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDark,
    bool isPrimary = false,
    bool isDisabled = false,
  }) {
    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: isDisabled ? null : () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isDisabled
              ? (isDark ? AppColors.surfaceContainerLowest : AppColors.surfaceVariantLight)
              : (isPrimary
                  ? AppColors.primary
                  : (isDark ? AppColors.surfaceContainerHighest : AppColors.surfaceLight)),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isPrimary
                ? AppColors.primary
                : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled
              ? (isDark ? AppColors.outline : AppColors.borderDark)
              : (isPrimary ? AppColors.onPrimary : (isDark ? AppColors.onSurface : AppColors.textLight)),
        ),
      ),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key('habit_${habit.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await ConfirmationDialog.show(
          context: context,
          title: 'Alışkanlığı Sil?',
          message: '"${habit.title}" alışkanlığını ve geçmiş serisini kalıcı olarak silmek istediğinize emin misiniz?',
          confirmText: 'Evet, Sil',
          confirmColor: AppColors.danger,
          icon: Icons.delete_forever_rounded,
          iconColor: AppColors.danger,
          isDestructive: true,
        );
      },
      onDismissed: (_) => onDelete(),
      background: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        margin: const EdgeInsets.only(bottom: AppSizes.spaceMd),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          mainAxisAlignment: MainAxisAlignment.end, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 24),
            SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text('Sil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        margin: const EdgeInsets.only(bottom: AppSizes.spaceMd),
        child: Material(
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
              borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              border: Border.all(
                color: habit.isCompleted
                    ? AppColors.primary
                    : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                width: habit.isCompleted ? 1.5 : 1.0,
              ),
            ),
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              mainAxisSize: MainAxisSize.min,
              children: [
                // Üst Satır: İkon + Başlık/Detaylar (Geniş Alan) + Aksiyon
                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  crossAxisAlignment: CrossAxisAlignment.center, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    // 38x38 Kategori İkon Kutusu
                    Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      width: AppSizes.iconBoxMd,
                      height: AppSizes.iconBoxMd,
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: categoryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      ),
                      child: Icon(_getIconData(habit.iconPath), color: categoryColor, size: AppSizes.iconMd),
                    ),
                    const SizedBox(width: AppSizes.spaceMd), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    // Başlık, Zaman ve Meta Bilgileri
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          Text(
                            habit.title,
                            maxLines: 2, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                            overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                              color: habit.isCompleted
                                  ? (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary)
                                  : (isDark ? AppColors.onSurface : AppColors.textLight),
                            ),
                          ),
                          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            children: [
                              const Icon(Icons.schedule, size: 13, color: AppColors.tertiary),
                              const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Flexible(
                                child: Text(
                                  '${habit.startTime} - ${habit.endTime}',
                                  maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                  overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.tertiary,
                                  ),
                                ),
                              ),
                              if (habit.hasReminder) ...[
                                const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                const Icon(Icons.notifications_active, size: 13, color: AppColors.secondary),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            children: [
                              Flexible(
                                child: Text(
                                  categoryName,
                                  maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                                  overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              StreakBadge(streakDays: habit.streakDays),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceSm), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    // Onaylama Aksiyonu (Sadece Checkmark için üst satırda)
                    if (habit.type == HabitType.checkmark)
                      GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onToggle();
                        },
                        child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          duration: const Duration(milliseconds: 200),
                          width: AppSizes.iconBoxMd,
                          height: AppSizes.iconBoxMd,
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            shape: BoxShape.circle,
                            color: habit.isCompleted ? AppColors.primary : Colors.transparent,
                            border: Border.all(
                              color: habit.isCompleted
                                  ? AppColors.primary
                                  : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                              width: 2,
                            ),
                          ),
                          child: habit.isCompleted
                              ? const Icon(Icons.check, color: AppColors.onPrimary, size: 20)
                              : null,
                        ),
                      )
                    else if (habit.isCompleted)
                      Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        ),
                        child: const Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                            SizedBox(width: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Text(
                              'Tamam',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                // Sayaçlı Alışkanlıklar için Alt Kontrol ve İlerleme Barı
                if (habit.type == HabitType.counter) ...[
                  const SizedBox(height: AppSizes.spaceMd), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                      color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      border: Border.all(
                        color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                        width: 0.8,
                      ),
                    ),
                    child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        Flexible(
                          child: Text(
                            '${habit.currentProgress.toInt()} / ${habit.targetProgress.toInt()} ${habit.unit}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.onSurface : AppColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                          ),
                        ),
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildStepperButton(
                              icon: Icons.remove,
                              onTap: onDecrement,
                              isDark: isDark,
                              isDisabled: habit.currentProgress <= 0,
                            ),
                            const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            _buildStepperButton(
                              icon: Icons.add,
                              onTap: onIncrement,
                              isDark: isDark,
                              isPrimary: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceSm), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.progressBarRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    child: LinearProgressIndicator(
                      value: (habit.currentProgress / habit.targetProgress).clamp(0.0, 1.0),
                      minHeight: AppSizes.progressBarHeight,
                      backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        habit.isCompleted ? AppColors.primaryContainer : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
