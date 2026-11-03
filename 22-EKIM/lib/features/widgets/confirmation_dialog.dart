import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/theme/app_theme.dart';

/// Kullanıcıdan silme, onaylama veya geri alma işlemlerinde teyit alan modern diyalog penceresi.
class ConfirmationDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    String cancelText = 'Vazgeç', // String türünden cancelText değişkenimiz
    Color confirmColor = AppColors.primary,
    IconData? icon,
    Color? iconColor,
    bool isDestructive = false,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog( // Kullanıcıya uyarı veya onay penceresi göstermek için AlertDialog açıyoruz
        backgroundColor: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          side: BorderSide(
            color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
            width: 1,
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        title: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: [
            if (icon != null) ...[
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: (iconColor ?? confirmColor).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor ?? confirmColor, size: 22),
              ),
              const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            ],
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            height: 1.45,
            color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            ),
            child: Text(
              cancelText,
              style: TextStyle(
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: Icon(
              isDestructive
                  ? Icons.delete_outline_rounded
                  : Icons.check_circle_outline_rounded,
              size: 18,
              color: Colors.white,
            ),
            label: Text(
              confirmText,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              elevation: 0, // Kartın arkasına gölge veriyoruz (z koordinatı)
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
