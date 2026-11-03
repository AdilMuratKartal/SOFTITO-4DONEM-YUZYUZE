import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/extensions/context_extensions.dart';

/// Günlük yazımı için pratik biçimlendirme ve ekleme araç çubuğu.
class TextFormattingBar extends StatelessWidget { // TextFormattingBar sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final VoidCallback onAddDate; // VoidCallback türünden onAddDate adlı değişkenimiz
  final VoidCallback onAddBullet; // VoidCallback türünden onAddBullet adlı değişkenimiz
  final VoidCallback onAddQuote; // VoidCallback türünden onAddQuote adlı değişkenimiz

  const TextFormattingBar({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.onAddDate, // onAddDate parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onAddBullet, // onAddBullet parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onAddQuote, // onAddQuote parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: style.borderColor.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
            icon: const Icon(Icons.calendar_today_outlined, size: 20),
            tooltip: 'Tarih Ekle',
            onPressed: onAddDate,
          ),
          IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
            icon: const Icon(Icons.format_list_bulleted, size: 20),
            tooltip: 'Madde İmi',
            onPressed: onAddBullet,
          ),
          IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
            icon: const Icon(Icons.format_quote_outlined, size: 20),
            tooltip: 'Alıntı Ekle',
            onPressed: onAddQuote,
          ),
        ],
      ),
    );
  }
}
