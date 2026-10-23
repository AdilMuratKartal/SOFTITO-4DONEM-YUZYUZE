# Ana Ekran (Home View)

Kullanıcının günlük mikro-alışkanlıklarını, ilerlemesini ve duygu durumunu takip ettiği merkezi kontrol paneli.

- **Konum:** `lib/features/views/home/home_view.dart`
- **Sorumluluklar:**
  - Günlük tarih ve duygu durumuyla kişiselleştirilmiş tepe başlığı.
  - İnteraktif duygu durumu (Mood) hap rozeti ve ilk girişte sorulan tek seferlik modal entegrasyonu.
  - Yatay ve responsive 7 günlük haftalık takvim şeridi (`DailyCalendarStrip`).
  - Kategori bazlı filtreleme çipleri (Tümü, Spor, Sağlık, Zihin, Müzik ve dinamik eklenenler).
  - Günün tamamlanma yüzdesini gösteren genel ilerleme kartı (`_buildProgressOverview`).
  - Mikro-alışkanlık listesi (Checkmark tik ve alt kontrollü Sayaç kartları).
  - Hızlı yeni alışkanlık ekleme yüzen aksiyon butonu (FAB).
