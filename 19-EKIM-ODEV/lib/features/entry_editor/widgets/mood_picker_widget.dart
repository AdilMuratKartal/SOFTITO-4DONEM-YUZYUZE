import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/extensions/context_extensions.dart';

/// Temaya duyarlı Duygu Durumu Seçici bileşeni.
class MoodPickerWidget extends StatelessWidget { // MoodPickerWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final ValueListenable<String?> selectedMoodNotifier; // ValueListenable<String?> türünden selectedMoodNotifier adlı değişkenimiz
  final ValueChanged<String?> onMoodSelected; // ValueChanged<String?> türünden onMoodSelected adlı değişkenimiz

  static const List<String> availableMoods = [
    '😊',
    '✨',
    '☕',
    '🔥',
    '🌧️',
    '🌙',
    '🌿',
    '💡'
  ];

  const MoodPickerWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.selectedMoodNotifier, // selectedMoodNotifier parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onMoodSelected, // onMoodSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.cardShadow,
      ),
      child: ValueListenableBuilder<String?>(
        valueListenable: selectedMoodNotifier,
        builder: (context, currentMood, _) {
          return SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
            scrollDirection: Axis.horizontal,
            child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              children: availableMoods.map((mood) {
                final isSelected = currentMood == mood;
                return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                  onTap: () => onMoodSelected(isSelected ? null : mood),
                  child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                      color: isSelected
                          ? context.colors.primary.withValues(alpha: 0.18)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? context.colors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      mood,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
