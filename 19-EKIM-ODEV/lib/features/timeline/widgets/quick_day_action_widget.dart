import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';

/// Seçili gün için hızlı mod seçimi ve günlük oluşturma kartı.
class QuickDayActionWidget extends StatelessWidget { // QuickDayActionWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final DateTime selectedDay; // DateTime türünden selectedDay adlı değişkenimiz
  final String? selectedCreationMood; // String? türünden selectedCreationMood adlı değişkenimiz
  final ValueChanged<String> onMoodSelected; // ValueChanged<String> türünden onMoodSelected adlı değişkenimiz
  final VoidCallback onCreateEntry; // VoidCallback türünden onCreateEntry adlı değişkenimiz
  final bool filterOnlyDay; // bool türünden filterOnlyDay adlı değişkenimiz
  final VoidCallback onToggleDayFilter; // VoidCallback türünden onToggleDayFilter adlı değişkenimiz

  static const List<String> moods = ['😊', '✨', '☕', '🔥', '🌧️', '🌙'];

  const QuickDayActionWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.selectedDay, // selectedDay parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.selectedCreationMood, // selectedCreationMood parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onMoodSelected, // onMoodSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onCreateEntry, // onCreateEntry parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.filterOnlyDay, // filterOnlyDay parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onToggleDayFilter, // onToggleDayFilter parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.cardShadow,
      ),
      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
        crossAxisAlignment: CrossAxisAlignment.stretch, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
        children: [
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: [
              Icon(Icons.event_note, size: 20, color: context.colors.primary),
              const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: Text(
                  selectedDay.toJournalDate(),
                  style: style.headerFont.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                onTap: onToggleDayFilter,
                borderRadius: BorderRadius.circular(style.borderRadius / 2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: [
                      Icon(
                        filterOnlyDay
                            ? Icons.filter_alt
                            : Icons.filter_alt_outlined,
                        size: 16,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        filterOnlyDay ? 'Yalnızca Bu Gün' : 'Tüm Ay',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
            children: [
              Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                child: SingleChildScrollView( // Küçük ekranlarda taşma (overflow) hatası vermesin, ekran rahatça kaydırılsın diye sarmalıyoruz
                  scrollDirection: Axis.horizontal,
                  child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: moods.map((m) {
                      final isChosen = selectedCreationMood == m;
                      return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () => onMoodSelected(m),
                        child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: isChosen
                                ? context.colors.primary.withValues(alpha: 0.18)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isChosen
                                  ? context.colors.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Text(m, style: const TextStyle(fontSize: 20.0)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              ElevatedButton.icon(
                onPressed: onCreateEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                  elevation: 0, // Kartın arkasına gölge veriyoruz (z koordinatı)
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(style.borderRadius / 2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    side: BorderSide(
                      color: style.borderColor,
                      width: style.borderWidth,
                    ),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text(
                  'Günlük Yaz',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
