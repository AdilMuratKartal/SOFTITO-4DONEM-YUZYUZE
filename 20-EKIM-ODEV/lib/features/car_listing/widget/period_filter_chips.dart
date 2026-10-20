// Flutter'ın temel materyal tasarım widget kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Kiralama periyodu enum tanımını (günlük, haftalık, aylık) içe aktarıyoruz
import '../models/rental_period_type.dart';

/// TakeGO Kiralama Periyodu Seçici Çipleri (PeriodFilterChips)
///
/// Kullanıcının Günlük, Haftalık ve Aylık kiralama periyotları
/// arasında dinamik geçiş yapmasını sağlayan SegmentedButton bileşenidir.
class PeriodFilterChips extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // ÖZELLİKLER (Properties)
  // ---------------------------------------------------------------------------

  /// Halihazırda seçili olan kiralama periyodu (günlük, haftalık veya aylık)
  final RentalPeriodType selectedPeriod;

  /// Kullanıcı periyot butonlarından birine tıkladığında çağrılan bildirim fonksiyonu
  final ValueChanged<RentalPeriodType> onPeriodChanged;

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: Dışarıdan zorunlu periyot durumu ve tetikleyici fonksiyon alır
  const PeriodFilterChips({
    // Widget ağacında performans optimizasyonu sağlayan super.key
    super.key,
    // Aktif periyot seçimi (Zorunlu alan)
    required this.selectedPeriod,
    // Periyot değiştiğinde tetiklenecek fonksiyon (Zorunlu alan)
    required this.onPeriodChanged,
  });

  // ---------------------------------------------------------------------------
  // ARAYÜZ OLUŞTURMA (Build)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Çipleri ekranda ferah göstermek için dış kenar boşluğu ekliyoruz
    return Padding(
      // Yatayda 16px, dikeyde 8px padding değeri tanımlıyoruz
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      // Seçenekleri modern hap biçimli butonlar olarak sunan SegmentedButton
      child: SegmentedButton<RentalPeriodType>(
        // Seçim ikonunun (tik işaretinin) çip üzerinde gereksiz yer kaplamasını engelliyoruz
        showSelectedIcon: false,
        // Kullanıcının seçebileceği periyot butonlarının listesi
        segments: const [
          // 1. Segment: Günlük Kiralama Butonu
          ButtonSegment(
            // Temsil ettiği enum değeri: günlük
            value: RentalPeriodType.daily,
            // Buton üzerinde görünecek etiket metni
            label: Text('Günlük'),
            // Günlük takvim ikonu
            icon: Icon(
              Icons.today_rounded,
              size: 18,
            ),
          ),
          // 2. Segment: Haftalık Kiralama Butonu
          ButtonSegment(
            // Temsil ettiği enum değeri: haftalık
            value: RentalPeriodType.weekly,
            // Buton üzerinde görünecek etiket metni
            label: Text('Haftalık'),
            // Hafta görünümü ikonu
            icon: Icon(
              Icons.view_week_rounded,
              size: 18,
            ),
          ),
          // 3. Segment: Aylık Kiralama Butonu
          ButtonSegment(
            // Temsil ettiği enum değeri: aylık
            value: RentalPeriodType.monthly,
            // Buton üzerinde görünecek etiket metni
            label: Text('Aylık'),
            // Ay takvimi ikonu
            icon: Icon(
              Icons.calendar_month_rounded,
              size: 18,
            ),
          ),
        ],
        // SegmentedButton tek seçimli çalıştığı için mevcut periyodu tek elemanlı Set olarak veriyoruz
        selected: {selectedPeriod},
        // Kullanıcı yeni bir segmente tıkladığında çalışan fonksiyon bloğu
        onSelectionChanged: (Set<RentalPeriodType> selectedSet) {
          // Seçim kümesinin ilk elemanını alarak üst widget'a bildiriyoruz
          onPeriodChanged(selectedSet.first);
        },
      ),
    );
  }
}
