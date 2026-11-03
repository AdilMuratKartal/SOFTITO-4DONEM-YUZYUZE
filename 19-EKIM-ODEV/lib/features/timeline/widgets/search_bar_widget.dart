import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';

/// Temaya duyarlı arama çubuğu ve duygu filtresi çubuğu.
class SearchBarWidget extends StatelessWidget { // SearchBarWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final ValueChanged<String> onSearchChanged; // ValueChanged<String> türünden onSearchChanged adlı değişkenimiz
  final String? selectedMood; // String? türünden selectedMood adlı değişkenimiz
  final ValueChanged<String?> onMoodSelected; // ValueChanged<String?> türünden onMoodSelected adlı değişkenimiz

  static const List<String> moods = ['😊', '✨', '☕', '🔥', '🌧️', '🌙'];

  const SearchBarWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.onSearchChanged, // onSearchChanged parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.selectedMood, // selectedMood parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onMoodSelected, // onMoodSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        children: [
          Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              border: Border.all(
                color: style.borderColor.withValues(alpha: 0.5),
                width: 1.0,
              ),
            ),
            child: TextField( // Kullanıcıdan metin girdisi almak için form alanı
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: Icon(Icons.search, color: context.colors.primary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
            scrollDirection: Axis.horizontal,
            child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              children: [
                ChoiceChip(
                  label: const Text(AppStrings.allMoods),
                  selected: selectedMood == null,
                  onSelected: (_) => onMoodSelected(null),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(style.borderRadius / 2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  ),
                ),
                const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                ...moods.map((m) {
                  return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(m),
                      selected: selectedMood == m,
                      onSelected: (selected) =>
                          onMoodSelected(selected ? m : null),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(style.borderRadius / 2),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
