// Flutter materyal tasarım kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Tema renklerine context.colors üzerinden erişim sağlayan extension'ı içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Tarihleri Türkçe metne ve gün sayısına dönüştüren extension'ları içe aktarıyoruz
import '../../../core/extensions/date_extensions.dart';

/// TakeGO Tarih Aralığı Seçim Bileşeni (DateRangePickerWidget)
///
/// Aracın hangi tarihler arasında kiralanmaya uygun olduğunu
/// takvimden [DateTimeRange] olarak seçtiren interaktif alandır.
class DateRangePickerWidget extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // ÖZELLİKLER (Properties)
  // ---------------------------------------------------------------------------

  /// Seçili başlangıç ve bitiş tarihlerini reaktif olarak tutan ValueNotifier
  final ValueNotifier<DateTimeRange> dateRangeNotifier;

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: Dışarıdan tarih aralığı bildiricisini zorunlu olarak alır
  const DateRangePickerWidget({
    // Widget ağacı performans optimizasyonu için super.key
    super.key,
    // Tarih aralığı dinleyicisi parametresi (Zorunlu alan)
    required this.dateRangeNotifier,
  });

  // ---------------------------------------------------------------------------
  // ARAYÜZ OLUŞTURMA (Build)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // 1. Değişken: Aktif tema renk paleti
    final colors = context.colors;

    // Tarih aralığındaki reaktif değişiklikleri dinleyen ValueListenableBuilder
    return ValueListenableBuilder<DateTimeRange>(
      // Dinlenecek tarih aralığı bildiricisi
      valueListenable: dateRangeNotifier,
      // Yeni bir tarih seçildiğinde kutuyu yeniden çizen builder fonksiyonu
      builder: (context, range, _) {
        // Tıklama dalgalanma efektli InkWell bileşeni
        return InkWell(
          // Kutuya dokunulduğunda Flutter'ın tarih aralığı takvimini açıyoruz
          onTap: () => _pickDateRange(context),
          // 12 piksel yuvarlatılmış dokunma köşesi
          borderRadius: BorderRadius.circular(12),
          // Seçili tarih bilgilerini gösteren kutu
          child: Container(
            // Kutu içi dolgusu: yatayda 16px, dikeyde 14px
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            // Kutunun köşe ve zemin süslemesi
            decoration: BoxDecoration(
              // Temanın yüzey rengi
              color: colors.surfaceContainer,
              // 12 piksel yuvarlak köşeler
              borderRadius: BorderRadius.circular(12),
              // İnce kenarlık çizgisi
              border: Border.all(color: colors.outlineVariant),
            ),
            // İkonları ve tarih metinlerini yatayda dizen Row bileşeni
            child: Row(
              children: [
                // Takvim ikonu
                Icon(
                  Icons.calendar_month_rounded,
                  color: colors.primary,
                  size: 22,
                ),
                // İkon ile metinler arasına 12px yatay boşluk
                const SizedBox(width: 12),
                // Başlık ve tarih aralığını kalan genişliğe yayan Expanded
                Expanded(
                  child: Column(
                    // Metinleri sola dayalı hizalar
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Küçük üst başlık etiketi
                      const Text(
                        'Müsaitlik Tarih Aralığı',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Başlık ile tarih arasına 2px dikey boşluk
                      const SizedBox(height: 2),
                      // Formatlanmış başlangıç ve bitiş tarihi metni (Örn: 20 Eki 2026 ➜ 27 Eki 2026 (7 Gün))
                      Text(
                        '${range.start.toFormattedString}  ➜  ${range.end.toFormattedString} (${range.totalDays} Gün)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sağ uçta yer alan takvimi düzenle ikonu
                Icon(
                  Icons.edit_calendar_outlined,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // YARDIMCI METOT: TARİH SEÇİCİ TAKVİM
  // ---------------------------------------------------------------------------

  /// Flutter standart tarih aralığı seçici penceresini (showDateRangePicker) açar
  Future<void> _pickDateRange(BuildContext context) async {
    // 1. Değişken: Şu anki anlık tarih referansı
    final now = DateTime.now();

    // 2. Değişken: Kullanıcının takvimden seçtiği yeni tarih aralığı
    final picked = await showDateRangePicker(
      // Ekran bağlamı
      context: context,
      // Seçilebilecek ilk gün (bugün)
      firstDate: now,
      // Seçilebilecek son gün (bugünden 1 yıl sonrası)
      lastDate: now.add(const Duration(days: 365)),
      // Takvim ilk açıldığında gösterilecek başlangıç aralığı
      initialDateRange: dateRangeNotifier.value,
      // Takvim penceresi üst yardım metni
      helpText: 'Kiralama Müsaitlik Aralığını Seçin',
      // Onaylama buton metni
      confirmText: 'Aralığı Onayla',
      // İptal buton metni
      cancelText: 'Vazgeç',
    );

    // Kullanıcı bir aralık seçip onayladıysa (null dönmediyse)
    if (picked != null) {
      // Yeni aralığı reaktif bildiriciye atıyoruz (arayüz anında güncellenir)
      dateRangeNotifier.value = picked;
    }
  }
}
