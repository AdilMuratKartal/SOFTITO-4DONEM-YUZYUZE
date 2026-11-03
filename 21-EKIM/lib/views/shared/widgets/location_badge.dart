import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/app_theme.dart';

class LocationBadge extends StatelessWidget { // LocationBadge sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final String locationType; // 'sen_gel', 'ben_geleyim', 'her_ikisi'

  const LocationBadge({super.key, required this.locationType}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final bool isComeToMe = locationType == 'sen_gel';
    final bool isBoth = locationType == 'her_ikisi';

    final Color textColor = isBoth
        ? AppColors.bothText
        : (isComeToMe ? AppColors.comeToMeText : AppColors.iWillComeText);

    final Color bgColor = isBoth
        ? AppColors.bothBg
        : (isComeToMe ? AppColors.comeToMeBg : AppColors.iWillComeBg);

    final IconData icon = isBoth
        ? Icons.swap_horiz_outlined
        : (isComeToMe ? Icons.home_repair_service_outlined : Icons.storefront_outlined);

    final String text = isBoth
        ? 'Adreste veya Dükkanda'
        : (isComeToMe ? 'Sen Gel (Adrese)' : 'Ben Geleyim (Dükkana)');

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: bgColor,
        borderRadius: BorderRadius.circular(6), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
      ),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
          Flexible(
            child: Text(
              text,
              maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
              overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
