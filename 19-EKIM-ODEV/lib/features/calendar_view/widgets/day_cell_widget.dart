import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/extensions/context_extensions.dart';

/// Takvim gün hücresi bileşeni (ThemeExtension stillerine ve etkinlik duygu emojisine duyarlı).
class DayCellWidget extends StatelessWidget { // DayCellWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final DateTime date; // DateTime türünden date adlı değişkenimiz
  final bool isSelected; // bool türünden isSelected adlı değişkenimiz
  final bool isCurrentMonth; // bool türünden isCurrentMonth adlı değişkenimiz
  final bool hasEntries; // bool türünden hasEntries adlı değişkenimiz
  final String? mood; // String? türünden mood adlı değişkenimiz
  final VoidCallback onTap; // VoidCallback türünden onTap adlı değişkenimiz

  const DayCellWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.date, // date parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isSelected, // isSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isCurrentMonth, // isCurrentMonth parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.hasEntries, // hasEntries parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.mood, // mood alanına değer aktarıyoruz
    required this.onTap, // onTap parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: onTap,
      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isSelected
              ? context.colors.primary
              : (isCurrentMonth ? context.colors.surface : Colors.transparent),
          borderRadius: BorderRadius.circular(style.borderRadius / 2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : (isCurrentMonth
                    ? style.borderColor.withValues(alpha: 0.3)
                    : Colors.transparent),
            width: isSelected ? style.borderWidth : 1.0,
          ),
          boxShadow: isSelected ? style.cardShadow : const [],
        ),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13.0,
                color: isSelected
                    ? context.colors.onPrimary
                    : (isCurrentMonth
                        ? context.colors.onSurface
                        : context.colors.onSurface.withValues(alpha: 0.3)),
              ),
            ),
            if (mood != null)
              Text(
                mood!,
                style: const TextStyle(fontSize: 10.0),
              )
            else if (hasEntries)
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                margin: const EdgeInsets.only(top: 2),
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
  }
}
