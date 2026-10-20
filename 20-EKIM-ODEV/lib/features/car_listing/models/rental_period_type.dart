/// TakeGO Araç Kiralama Periyot Türleri (RentalPeriodType)
///
/// Kullanıcının filtreleme ve fiyatlandırma ekranlarında
/// Günlük, Haftalık veya Aylık seçenekleri arasında geçiş yapmasını sağlar.
enum RentalPeriodType {
  /// 1. Günlük kiralama seçeneği (Tek günlük kiralama ve fiyatlandırma)
  daily,

  /// 2. Haftalık kiralama seçeneği (7 günlük avantajlı kiralama paketi)
  weekly,

  /// 3. Aylık kiralama seçeneği (30 günlük uzun dönem kiralama paketi)
  monthly;

  // ---------------------------------------------------------------------------
  // GÖRSEL METİN VE ETİKET GETTER'LARI
  // ---------------------------------------------------------------------------

  /// SegmentedButton ve çip üzerinde gösterilecek Türkçe etiket metni
  String get label {
    // Enum değerine göre eşleşen metni seçiyoruz
    switch (this) {
      // Günlük periyot için etiket
      case RentalPeriodType.daily:
        return 'Günlük';
      // Haftalık periyot için etiket
      case RentalPeriodType.weekly:
        return 'Haftalık';
      // Aylık periyot için etiket
      case RentalPeriodType.monthly:
        return 'Aylık';
    }
  }

  /// Fiyat kartının yanına eklenecek birim para birimi ve periyot son eki (Örn: '₺ / Gün')
  String get unitSuffix {
    // Enum değerine göre uygun para birimi metnini döndürüyoruz
    switch (this) {
      // Günlük birim etiketi
      case RentalPeriodType.daily:
        return '₺ / Gün';
      // Haftalık birim etiketi
      case RentalPeriodType.weekly:
        return '₺ / Hafta';
      // Aylık birim etiketi
      case RentalPeriodType.monthly:
        return '₺ / Ay';
    }
  }

  /// Periyodun kaç takvim gününden oluştuğunu belirten gün sayısı katsayısı
  int get dayCount {
    // Periyodun gün karşılığını döndürüyoruz
    switch (this) {
      // Günlük: 1 gün
      case RentalPeriodType.daily:
        return 1;
      // Haftalık: 7 gün
      case RentalPeriodType.weekly:
        return 7;
      // Aylık: 30 gün
      case RentalPeriodType.monthly:
        return 30;
    }
  }
}
