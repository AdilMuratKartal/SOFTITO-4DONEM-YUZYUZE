// Flutter materyal tasarım kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
// Tema renklerine context.colors üzerinden erişim sağlayan extension'ı içe aktarıyoruz
import '../../../core/extensions/context_extensions.dart';
// Tarihleri Türkçe metne ve gün sayısına dönüştüren extension'ları içe aktarıyoruz
import '../../../core/extensions/date_extensions.dart';

/// TakeGO Tarih Aralığı Seçim Bileşeni (DateRangePickerWidget)
///
/// Aracın hangi tarihler arasında kiralanmaya uygun olduğunu
/// takvimden [DateTimeRange] olarak seçtiren interaktif alandır.
class DateRangePickerWidget extends StatelessWidget { // DateRangePickerWidget sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  // ---------------------------------------------------------------------------
  // ÖZELLİKLER (Properties)
  // ---------------------------------------------------------------------------

  /// Seçili başlangıç ve bitiş tarihlerini reaktif olarak tutan ValueNotifier
  final ValueNotifier<DateTimeRange> dateRangeNotifier; // ValueNotifier<DateTimeRange> türünden dateRangeNotifier adlı değişkenimiz

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: Dışarıdan tarih aralığı bildiricisini zorunlu olarak alır
  const DateRangePickerWidget({ // Genel, sabit sınıf constructor'ı
    // Widget ağacı performans optimizasyonu için super.key
    super.key,
    // Tarih aralığı dinleyicisi parametresi (Zorunlu alan)
    required this.dateRangeNotifier, // dateRangeNotifier parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  // ---------------------------------------------------------------------------
  // ARAYÜZ OLUŞTURMA (Build)
  // ---------------------------------------------------------------------------

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    // 1. Değişken: Aktif tema renk paleti
    final colors = context.colors;

    // Tarih aralığındaki reaktif değişiklikleri dinleyen ValueListenableBuilder
    return ValueListenableBuilder<DateTimeRange>(
      // Dinlenecek tarih aralığı bildiricisi
      valueListenable: dateRangeNotifier,
      // Yeni bir tarih seçildiğinde kutuyu yeniden çizen builder fonksiyonu
      builder: (context, range, _) {
        // Tıklama dalgalanma efektli InkWell bileşeni
        return InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
          // Kutuya dokunulduğunda Flutter'ın tarih aralığı takvimini açıyoruz
          onTap: () => _pickDateRange(context),
          // 12 piksel yuvarlatılmış dokunma köşesi
          borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          // Seçili tarih bilgilerini gösteren kutu
          child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
            // Kutu içi dolgusu: yatayda 16px, dikeyde 14px
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            // Kutunun köşe ve zemin süslemesi
            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
              // Temanın yüzey rengi
              color: colors.surfaceContainer,
              // 12 piksel yuvarlak köşeler
              borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
              // İnce kenarlık çizgisi
              border: Border.all(color: colors.outlineVariant),
            ),
            // İkonları ve tarih metinlerini yatayda dizen Row bileşeni
            child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
              children: [
                // Takvim ikonu
                Icon(
                  Icons.calendar_month_rounded,
                  color: colors.primary,
                  size: 22,
                ),
                // İkon ile metinler arasına 12px yatay boşluk
                const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                // Başlık ve tarih aralığını kalan genişliğe yayan Expanded
                Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                  child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                    // Metinleri sola dayalı hizalar
                    crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
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
                      const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
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
