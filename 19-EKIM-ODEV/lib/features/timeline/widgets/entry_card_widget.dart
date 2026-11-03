import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../entry_editor/models/journal_entry_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

/// 5 Temanın tasarım diline göre dinamik şekillenen Günlük Kartı bileşeni.
class EntryCardWidget extends StatelessWidget { // EntryCardWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final JournalEntry entry; // JournalEntry türünden entry adlı değişkenimiz
  final VoidCallback? onTap; // VoidCallback? türünden onTap adlı değişkenimiz
  final VoidCallback? onDelete; // VoidCallback? türünden onDelete adlı değişkenimiz

  const EntryCardWidget({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.entry, // entry parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.onTap, // onTap alanına değer aktarıyoruz
    this.onDelete, // onDelete alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final style = context.journalStyle;

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
          borderRadius: BorderRadius.circular(style.borderRadius), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          onTap: onTap,
          child: Padding( // Widget'ın kenarlarından içeriye doğru nefes alma boşluğu vermek için Padding
            padding: const EdgeInsets.all(16),
            child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
              crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
              children: [
                _buildHeader(context, style),
                const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                _buildContent(context),
                if (entry.tags.isNotEmpty) ...[
                  const SizedBox(height: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  _buildTags(context, style),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic style) {
    return Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
      children: [
        if (entry.mood != null) ...[
          Text(entry.mood!, style: const TextStyle(fontSize: 22.0)),
          const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
        ],
        Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
          child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
            crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
            children: [
              Text(
                entry.title,
                style: style.headerFont.copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
                  color: context.colors.onSurface,
                  fontSize: 18.0,
                ),
                maxLines: 1, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
                overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
              ),
              Text(
                entry.createdAt.toJournalDate(),
                style: TextStyle(
                  color: context.colors.onSurface.withValues(alpha: 0.6),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        if (onDelete != null)
          IconButton( // Sadece simgeden oluşan tıklanabilir ikon butonu
            icon: const Icon(Icons.delete_outline, size: 20),
            color: context.colors.error,
            onPressed: onDelete,
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      entry.content,
      maxLines: 3, // Metnin en fazla kaç satır olacağını sınırlıyoruz, taşmasın diye
      overflow: TextOverflow.ellipsis, // Metin sığmazsa taşmasın, sonuna üç nokta (...) koysun diye
      style: TextStyle(
        color: context.colors.onSurface.withValues(alpha: 0.85),
        fontSize: 14.0,
        height: 1.45,
      ),
    );
  }

  Widget _buildTags(BuildContext context, dynamic style) {
    return Wrap( // Ekrana sığmayan butonlar ve etiketler alt satıra geçsin, taşma yapmasın diye Wrap kullanıyoruz
      spacing: 6,
      runSpacing: 4,
      children: entry.tags.map((tag) {
        return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
            color: context.colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(style.borderRadius / 2), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
