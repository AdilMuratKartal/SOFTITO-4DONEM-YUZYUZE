import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

/// Öne Çıkan Aktif Yol Haritası Hero Kartı
class RoadmapCard extends StatelessWidget { // RoadmapCard sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final RoadmapModel roadmap; // RoadmapModel türünden roadmap adlı değişkenimiz
  final VoidCallback onTap; // VoidCallback türünden onTap adlı değişkenimiz
  final bool isFeatured; // bool türünden isFeatured adlı değişkenimiz

  const RoadmapCard({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.roadmap, // roadmap parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onTap, // onTap parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.isFeatured = true, // isFeatured alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isFeatured) {
      return _buildCompactCard(context, isDark); // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    }

    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: onTap,
      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        margin: const EdgeInsets.only(bottom: AppSizes.spaceLg),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isDark ? AppColors.outlineVariant.withValues(alpha: 0.6) : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          child: Stack( // Elemanları üst üste bindirmek (katmanlı tasarım yapmak) için Stack kullanıyoruz
            children: [
              // Sağ üst arka plan zümrüt ışıltısı efekti
              Positioned( // Stack içindeki widget'ın konumunu (sol, sağ, üst, alt) piksel olarak ayarlamak için
                top: -24,
                right: -24,
                child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
              ),

              Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
                padding: const EdgeInsets.all(AppSizes.spaceLg),
                child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                  children: [
                    // Üst Satır: Kategori + Süre + Durum Rozeti
                    Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
                          spacing: 6,
                          children: [
                            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: isDark
                                    ? AppColors.surfaceContainerHighest
                                    : AppColors.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              ),
                              child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(roadmap.iconName, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                  Text(
                                    roadmap.category,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: isDark
                                    ? AppColors.surfaceContainerHigh
                                    : AppColors.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                              ),
                              child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('⏱️', style: TextStyle(fontSize: 11)),
                                  const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                  Text(
                                    roadmap.durationWeeks,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: roadmap.isCompleted
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          ),
                          child: Text(
                            roadmap.isCompleted ? 'Tamamlandı' : 'Aktif',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                    // Başlık & Açıklama
                    Text(
                      roadmap.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.01,
                        color: isDark ? AppColors.onSurface : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Text(
                      'Bütünsel disiplin ve aşamalı alışkanlık inşa protokolü',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 14), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                    // İlerleme İstatistikleri ve Bar
                    Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        Text(
                          '${roadmap.completedNodesCount} / ${roadmap.nodes.length} Basamak Tamamlandı',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.onSurface : AppColors.textLight,
                          ),
                        ),
                        Text(
                          '%${roadmap.progressPercentage.toInt()}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      child: LinearProgressIndicator(
                        value: roadmap.progressRatio,
                        minHeight: 7,
                        backgroundColor: isDark ? AppColors.surfaceContainerHighest : AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),

                    const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

                    // Alt Kısım: Ödül & Aksiyon
                    Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                      children: [
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          children: [
                            const Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Text(
                              'Sonraki ödül: ',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              roadmap.nextReward,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Detayları Gör',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Arşivlenmiş / Tamamlanmış Kompakt Kart
  Widget _buildCompactCard(BuildContext context, bool isDark) { // Kartın arkasına gölge verip derinlik katıyoruz (elevation - z koordinatı)
    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: onTap,
      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        margin: const EdgeInsets.only(bottom: AppSizes.spaceSm),
        padding: const EdgeInsets.all(AppSizes.spaceMd),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isDark ? AppColors.outlineVariant.withValues(alpha: 0.5) : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: [
            Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
              width: 38,
              height: 38,
              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              ),
              child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
                child: Text(roadmap.iconName, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                children: [
                  Text(
                    roadmap.title,
                    maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                    overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    '${roadmap.nodes.length} Basamak • %100 Tamamlandı',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
