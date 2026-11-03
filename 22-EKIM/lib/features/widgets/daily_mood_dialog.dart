import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import 'package:flutter/services.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz
import '../../core/theme/app_theme.dart';
import '../models/mood_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

class DailyMoodDialog extends StatelessWidget { // DailyMoodDialog sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final String? initialMood; // String? türünden initialMood adlı değişkenimiz
  final ValueChanged<String> onMoodSelected; // ValueChanged<String> türünden onMoodSelected adlı değişkenimiz
  final VoidCallback onDismiss; // VoidCallback türünden onDismiss adlı değişkenimiz

  const DailyMoodDialog({ // Genel, sabit sınıf constructor'ı
    super.key,
    this.initialMood, // initialMood alanına değer aktarıyoruz
    required this.onMoodSelected, // onMoodSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onDismiss, // onDismiss parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  static Future<void> show(
    BuildContext context, {
    String? currentMood,
    required ValueChanged<String> onMoodSelected,
    required VoidCallback onDismiss,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DailyMoodDialog(
        initialMood: currentMood,
        onMoodSelected: (mood) {
          onMoodSelected(mood);
          Navigator.of(ctx).pop();
        },
        onDismiss: () {
          onDismiss();
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusModal)),
          border: Border.all(
            color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            // Modal tutma çubuğu (Drag handle)
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              width: 40,
              height: 4,
              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              ),
            ),
            const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Başlık ve İkon
            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
              children: [
                const Icon(Icons.wb_sunny_rounded, color: AppColors.secondary, size: 24),
                const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Text(
                  'Bugün Nasıl Hissediyorsun?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.01,
                    color: isDark ? AppColors.onSurface : AppColors.textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              'Günün ilk girişi! Modunu kaydet, enerjine göre alışkanlıklarını yönet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // 5 Mood Seçenekleri - Responsive Expanded Satırı
            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              children: MoodItem.allMoods.map((mood) {
                final isSelected = initialMood == mood.keyName;
                return Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                  child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onMoodSelected(mood.keyName);
                      },
                      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                          color: isSelected
                              ? mood.activeColor.withValues(alpha: 0.18)
                              : (isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          border: Border.all(
                            color: isSelected ? mood.activeColor : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(mood.emoji, style: const TextStyle(fontSize: 26)),
                            const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
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
                                      : (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
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
            const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            // Geç / Daha Sonra Butonu (Tekrar sormasın)
            SizedBox(
              width: double.infinity,
              child: TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onDismiss();
                },
                child: Text(
                  'Daha Sonra (Bugün Tekrar Sorma)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
