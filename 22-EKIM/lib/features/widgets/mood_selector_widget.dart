import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/theme/app_theme.dart';
import '../models/mood_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class MoodSelectorWidget extends StatelessWidget { // MoodSelectorWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final String? selectedMood; // String? türünden selectedMood adlı değişkenimiz
  final ValueChanged<String> onMoodSelected; // ValueChanged<String> türünden onMoodSelected adlı değişkenimiz

  const MoodSelectorWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.selectedMood, // selectedMood parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onMoodSelected, // onMoodSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
        ),
      ),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
            children: [
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: Text(
                  'Bugün nasıl hissediyorsun?',
                  maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                  overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.onSurface : AppColors.textLight,
                  ),
                ),
              ),
              if (selectedMood != null)
                Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  ),
                  child: const Text(
                    'Kaydedildi ✓',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: MoodItem.allMoods.map((mood) {
              final isSelected = selectedMood == mood.keyName;
              return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                    onTap: () => onMoodSelected(mood.keyName),
                    child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: isSelected
                            ? mood.activeColor.withValues(alpha: 0.18)
                            : (isDark ? AppColors.surfaceContainerHigh : Colors.transparent),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        border: Border.all(
                          color: isSelected ? mood.activeColor : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(mood.emoji, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              mood.label,
                              maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? mood.activeColor
                                    : (isDark
                                        ? AppColors.onSurfaceVariant
                                        : AppColors.textSecondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
