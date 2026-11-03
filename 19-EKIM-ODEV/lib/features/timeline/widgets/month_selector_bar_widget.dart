import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/extensions/context_extensions.dart';

/// Temaya duyarlı 12 Ay Seçici Yatay Çubuk bileşeni.
class MonthSelectorBarWidget extends StatelessWidget { // MonthSelectorBarWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final int selectedMonth; // int türünden selectedMonth adlı değişkenimiz
  final ValueChanged<int> onMonthSelected; // ValueChanged<int> türünden onMonthSelected adlı değişkenimiz

  static const List<String> monthNames = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  const MonthSelectorBarWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.selectedMonth, // selectedMonth parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onMonthSelected, // onMonthSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return SizedBox(
      height: 44,
      child: ListView.builder( // Sadece ekranda görünen elemanları çizerek RAM tasarrufu sağlayan performanslı liste
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 12, // Listede kaç tane eleman gösterileceğini belirtiyoruz
        itemBuilder: (context, index) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
          final monthIndex = index + 1;
          final isSelected = selectedMonth == monthIndex;

          return Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(monthNames[index]),
              selected: isSelected,
              onSelected: (_) => onMonthSelected(monthIndex),
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13.0,
                color: isSelected
                    ? context.colors.onPrimary
                    : context.colors.onSurface,
              ),
              selectedColor: context.colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(style.borderRadius / 2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                side: BorderSide(
                  color: isSelected
                      ? context.colors.primary
                      : style.borderColor.withValues(alpha: 0.3),
                  width: isSelected ? style.borderWidth : 1.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
