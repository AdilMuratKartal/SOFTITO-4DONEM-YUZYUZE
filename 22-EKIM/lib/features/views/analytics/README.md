# İstatistik & Analiz (Analytics View)

Alışkanlık tamamlanma geçmişi, kategori oranları ve duygu durumu analizlerinin yer aldığı veri ekranı.

- **Konum:** `lib/features/views/analytics/analytics_view.dart`
- **Sorumluluklar:**
  - Genel metrik özet kartları (Tamamlama yüzdesi, toplam seri, aktif alışkanlık sayısı).
  - Haftalık/Aylık alışkanlık tamamlama çubuk grafiği (Bar Chart - FL Chart).
  - Kategori bazlı dağılım pasta/halka grafiği (Spor, Sağlık, Zihin, Müzik, Özel).
  - **Aylık Aktivite Izgarası (Heatmap):** Ayın günleri bazında tamamlanan alışkanlık yoğunluğunu 5 kademeli zümrüt yeşili paletle gösterme.
    - *Hover / Tooltip:* Bir günün üzerine gelindiğinde tarih ve tamamlanan alışkanlık sayısını gösteren anlık bilgi çubuğu ve masaüstü Tooltip.
    - *Tıklama Detay Modalı:* Tıklanan günün tüm alışkanlık durumlarını (tamamlanan/eksik, kategori, zaman aralığı) ve o günün duygu durumunu (mood) listeleyen detaylı Bottom Sheet.
