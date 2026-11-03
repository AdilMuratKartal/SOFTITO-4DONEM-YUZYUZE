import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/models/app_theme_type.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

/// Her temanın kendine has stilini (kenarlık, gölge, renk) simüle eden önizleme kartı.
class ThemePreviewCard extends StatelessWidget { // ThemePreviewCard sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final JournalTheme theme; // JournalTheme türünden theme adlı değişkenimiz
  final bool isSelected; // bool türünden isSelected adlı değişkenimiz
  final VoidCallback onTap; // VoidCallback türünden onTap adlı değişkenimiz

  const ThemePreviewCard({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.theme, // theme parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isSelected, // isSelected parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onTap, // onTap parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: onTap,
      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : style.borderColor.withValues(alpha: 0.5),
            width: isSelected
                ? (style.borderWidth < 2.0 ? 2.5 : style.borderWidth + 1.0)
                : 1.0,
          ),
          boxShadow: isSelected ? style.cardShadow : const [],
        ),
        child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
          children: [
            _buildThemeBadge(context),
            const SizedBox(width: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
              child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                children: [
                  Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: [
                      Text(
                        theme.displayName,
                        style: style.headerFont.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Icon(Icons.check_circle,
                            size: 18, color: context.colors.primary),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text(
                    _getThemeDescription(theme),
                    style: TextStyle(
                      fontSize: 13.0,
                      color: context.colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeBadge(BuildContext context) {
    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      width: 44,
      height: 44,
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: _getThemePreviewColor(theme),
        shape: BoxShape.circle,
        border:
            Border.all(color: Colors.black.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Center( // İçindeki widget'ı yatayda ve dikeyde tam ortaya hizalamak için
        child: Text(
          _getThemeEmoji(theme),
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  Color _getThemePreviewColor(JournalTheme t) {
    switch (t) {
      case JournalTheme.neoBrutalist:
        return const Color(0xFFFFE500);
      case JournalTheme.minimalist:
        return const Color(0xFFFBFBFB);
      case JournalTheme.journal:
        return const Color(0xFFD4A373);
      case JournalTheme.handDrawn:
        return const Color(0xFFFFF9DE);
      case JournalTheme.rubberHose:
        return const Color(0xFFFFF8EA);
    }
  }

  String _getThemeEmoji(JournalTheme t) {
    switch (t) {
      case JournalTheme.neoBrutalist:
        return '⚡';
      case JournalTheme.minimalist:
        return '⚪';
      case JournalTheme.journal:
        return '📖';
      case JournalTheme.handDrawn:
        return '✏️';
      case JournalTheme.rubberHose:
        return '🎩';
    }
  }

  String _getThemeDescription(JournalTheme t) {
    switch (t) {
      case JournalTheme.neoBrutalist:
        return 'Sert 3px siyah kenarlıklar, canlı pop renkler ve sert gölgeler.';
      case JournalTheme.minimalist:
        return 'Sade İskandinav tipografisi, yumuşak mikro kontrastlar.';
      case JournalTheme.journal:
        return 'Parşömen dokusu, gece mavisi mürekkep ve vintage defter havası.';
      case JournalTheme.handDrawn:
        return 'Kraft saman kağıdı, 2B kurşun kalem ve post-it sıcaklığı.';
      case JournalTheme.rubberHose:
        return '1930\'lar vintage Fleischer animasyon çizgisi ve Technicolor kırmızısı.';
    }
  }
}
