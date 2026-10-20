// Flutter Materyal kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Context extension ile tema renklerine hızlı erişimi içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';

/// TakeGO Dijital Kokpit Eylem Düğmesi (KeyActionButton)
///
/// Kapı kilidi, far yakma ve bagaj açma gibi otomotiv kontrol
/// fonksiyonlarını aktif/pasif durumuna göre parlayan buton tasarımıyla sunar.
class KeyActionButton extends StatelessWidget {
  /// Butonun üzerinde gösterilecek ana ikon (Örn: kilit, far, bagaj)
  final IconData icon;

  /// Butonun altındaki açıklayıcı başlık etiketi
  final String label;

  /// Butonun aktif/seçili olup olmadığı (Örn: Kapı açık veya farlar yanıyorsa true)
  final bool isActive;

  /// Kullanıcı butona dokunduğunda tetiklenen tıklama geri çağırma (callback) eylemi
  final VoidCallback onTap;

  /// Buton aktifken parlayacak özel vurgu rengi (Null verilirse temadan alınır)
  final Color? activeColor;

  // Sabit kurucu metot
  const KeyActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Aktif tema renk şemasını extension üzerinden alıyoruz
    final colors = context.colors;

    // Vurgu rengini belirliyoruz: Özel renk varsa o, yoksa aktiflik durumuna göre yeşil/mavi
    final highlightColor =
        activeColor ?? (isActive ? colors.secondary : colors.primary);

    // Tıklanabilir mürekkep efekti (ripple) sunan InkWell
    return InkWell(
      // Butona dokunulduğunda onTap fonksiyonunu çalıştırıyoruz
      onTap: onTap,
      // Tıklama dalgasını 16 piksel yuvarlak köşelere sınırlıyoruz
      borderRadius: BorderRadius.circular(16),
      // Aktiflik durum geçişinde renkleri yumuşakça canlandıran AnimatedContainer
      child: AnimatedContainer(
        // Renk geçiş animasyon süresi: 200 milisaniye
        duration: const Duration(milliseconds: 200),
        // Kutu içi yatay ve dikey dolgu
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        // Buton kutusunun arka planı ve çerçeve çizgisi
        decoration: BoxDecoration(
          // Aktifse vurgu renginin %15 saydam tonu, pasifse koyu kokpit yüzeyi
          color: isActive
              ? highlightColor.withValues(alpha: 0.15)
              : colors.surfaceContainer,
          // 16 piksel yuvarlatılmış köşe yarıçapı
          borderRadius: BorderRadius.circular(16),
          // Çerçeve kenarlık çizgisi
          border: Border.all(
            // Aktifse parlayan durum rengi, pasifse loş çerçeve
            color: isActive ? highlightColor : colors.outlineVariant,
            // Aktifken daha kalın (1.8px), pasifken ince (1.0px) çizgi
            width: isActive ? 1.8 : 1.0,
          ),
        ),
        // İkon ve metni dikeyde alt alta dizen Column
        child: Column(
          // Minimum dikey boyutta toplanmasını sağlıyoruz
          mainAxisSize: MainAxisSize.min,
          children: [
            // Eylem ikonu
            Icon(
              icon,
              // İkon piksel boyutu
              size: 28,
              // Aktifken durum rengi, pasifken gri ton
              color: isActive ? highlightColor : colors.onSurfaceVariant,
            ),
            // İkon ile metin arasına 8 piksel boşluk
            const SizedBox(height: 8),
            // Buton açıklama etiketi
            Text(
              label,
              style: TextStyle(
                // Yazı boyutu
                fontSize: 12,
                // Kalın yazı tipi
                fontWeight: FontWeight.bold,
                // Aktifken parlayan durum rengi
                color: isActive ? highlightColor : colors.onSurface,
              ),
              // Ortalanmış metin hizalaması
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
