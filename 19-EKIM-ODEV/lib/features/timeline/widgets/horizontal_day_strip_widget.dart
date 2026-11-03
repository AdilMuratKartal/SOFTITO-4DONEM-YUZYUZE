import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';

/// Seçilen ayın günlerini yatay listeleyen ve etkinlik durumunu gösteren çubuk.
class HorizontalDayStripWidget extends StatelessWidget { // HorizontalDayStripWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final int year; // int türünden year adlı değişkenimiz
  final int month; // int türünden month adlı değişkenimiz
  final DateTime selectedDay; // DateTime türünden selectedDay adlı değişkenimiz
  final ValueChanged<DateTime> onDaySelected; // ValueChanged<DateTime> türünden onDaySelected adlı değişkenimiz
  final bool Function(DateTime) hasEntriesOnDate;
  final String? Function(DateTime) getMoodForDate;

  const HorizontalDayStripWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.year, // year parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.month, // month parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.selectedDay, // selectedDay parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onDaySelected, // onDaySelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.hasEntriesOnDate, // hasEntriesOnDate parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.getMoodForDate, // getMoodForDate parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;
    final totalDays = DateTime(year, month + 1, 0).day;
    final dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return SizedBox(
      height: 76,
      child: ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: totalDays, // Listede kaç tane eleman gösterileceğini belirtiyoruz
        itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
          final dayNumber = index + 1;
          final date = DateTime(year, month, dayNumber);
          final isSelected = date.isSameDay(selectedDay);
          final hasEntries = hasEntriesOnDate(date);
          final mood = getMoodForDate(date);
          final weekdayName = dayNames[date.weekday - 1];

          return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
            onTap: () => onDaySelected(date),
            child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              duration: const Duration(milliseconds: 160),
              width: 52,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                color: isSelected ? context.colors.primary : context.colors.surface,
                borderRadius: BorderRadius.circular(style.borderRadius / 1.5), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                border: Border.all(
                  color: isSelected
                      ? context.colors.primary
                      : style.borderColor.withValues(alpha: 0.35),
                  width: isSelected ? style.borderWidth : 1.0,
                ),
                boxShadow: isSelected ? style.cardShadow : const [],
              ),
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                children: [
                  Text(
                    weekdayName,
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? context.colors.onPrimary.withValues(alpha: 0.8)
                          : context.colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? context.colors.onPrimary
                          : context.colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  if (mood != null)
                    Text(mood, style: const TextStyle(fontSize: 12.0))
                  else if (hasEntries)
                    Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        shape: BoxShape.circle,
                        color: isSelected
                            ? context.colors.onPrimary
                            : context.colors.secondary,
                      ),
                    )
                  else
                    const SizedBox(height: 5), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
