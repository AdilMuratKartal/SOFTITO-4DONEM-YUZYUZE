import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/theme/app_theme.dart';

class DailyCalendarStrip extends StatelessWidget { // DailyCalendarStrip sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final ValueNotifier<DateTime> selectedDateNotifier; // ValueNotifier<DateTime> türünden selectedDateNotifier adlı değişkenimiz
  final ValueChanged<DateTime> onDateSelected; // ValueChanged<DateTime> türünden onDateSelected adlı değişkenimiz

  const DailyCalendarStrip({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.selectedDateNotifier, // selectedDateNotifier parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onDateSelected, // onDateSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final now = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Haftanın başlangıcı (Pazartesi)
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekDays = List.generate(7, (i) => monday.add(Duration(days: i)));

    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDateNotifier,
      builder: (context, selectedDate, _) {
        return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: weekDays.map((date) {
            final isSelected = date.year == selectedDate.year &&
                date.month == selectedDate.month &&
                date.day == selectedDate.day;
            final isToday = date.year == now.year &&
                date.month == now.month &&
                date.day == now.day;

            const trDays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
            final dayName = trDays[date.weekday - 1];

            return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                  onTap: () => onDateSelected(date),
                  child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                    duration: const Duration(milliseconds: 200),
                    constraints: const BoxConstraints(
                      minHeight: AppSizes.calendarItemMinHeight,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                      color: isSelected
                          ? AppColors.primary
                          : (isToday
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : (isDark ? AppColors.surfaceContainer : Colors.transparent)),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isToday
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : (isDark ? AppColors.outlineVariant : AppColors.borderLight)),
                        width: 1,
                      ),
                    ),
                    child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                      mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.onPrimary
                                  : (isToday
                                      ? AppColors.primary
                                      : (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.onPrimary
                                  : (isDark ? AppColors.onSurface : AppColors.textLight),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        if (isSelected)
                          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                              color: AppColors.onPrimary,
                              shape: BoxShape.circle,
                            ),
                          )
                        else if (isToday)
                          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
