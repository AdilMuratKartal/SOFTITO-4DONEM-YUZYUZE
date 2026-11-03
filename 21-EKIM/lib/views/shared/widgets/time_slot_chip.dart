import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/app_theme.dart';

class TimeSlotChip extends StatelessWidget { // TimeSlotChip sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final String time; // String türünden time adlı değişkenimiz
  final bool isBooked; // bool türünden isBooked adlı değişkenimiz
  final bool isSelected; // bool türünden isSelected adlı değişkenimiz
  final VoidCallback? onTap; // VoidCallback? türünden onTap adlı değişkenimiz

  const TimeSlotChip({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.time, // time parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isBooked, // isBooked parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.isSelected = false, // isSelected alanına değer aktarıyoruz
    this.onTap, // onTap alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: isBooked ? null : onTap,
      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isBooked
              ? Colors.grey.shade200
              : (isSelected ? AppColors.primary : AppColors.surface),
          borderRadius: BorderRadius.circular(8), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isBooked
                ? Colors.grey.shade300
                : (isSelected ? AppColors.primary : AppColors.border),
          ),
        ),
        child: Text(
          isBooked ? '$time (Dolu)' : time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            decoration: isBooked ? TextDecoration.lineThrough : null,
            color: isBooked
                ? Colors.grey.shade500
                : (isSelected ? Colors.white : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
