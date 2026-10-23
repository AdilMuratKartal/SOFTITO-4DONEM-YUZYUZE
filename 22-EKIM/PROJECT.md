# Mikro-Alışkanlık ve Kişisel Gelişim Takip Uygulaması (PROJECT.md)

## 1. Proje Özeti

Kullanıcıların büyük ve ulaşılması zor hedefler yerine **mikro-alışkanlıklar** (küçük, sürdürülebilir günlük adımlar) yoluyla pozitif alışkanlıklar kazanmasını veya negatif alışkanlıkları bırakmasını sağlayan, oyunlaştırma (gamification) ve odaklanma araçlarıyla desteklenmiş kapsamlı bir kişisel gelişim uygulamasıdır.

## 2. Proje Amacı ve Vizyonu

İnsanların yeni bir alışkanlık edinirken (spor, okuma, su içme, müzik aleti çalma, soğuk duş) veya bir alışkanlığı bırakırken (sigara bırakma, aralıklı oruç) yaşadıkları motivasyon kaybını önlemek. Bunu; günlük duygu durumu (mood) analizi, Pomodoro odaklanma sayacı, görsel istatistikler, rozet/seviye sistemleri ve adım adım ilerlenen "Roadmap" (Yol Haritası) yapısıyla destekleyerek sürdürülebilir bir yaşam tarzı haline getirmek.

---

## 3. Temel Özellikler (Core Features)

### 3.1. Mikro-Alışkanlık Yönetimi (Ekleme, Silme, Zamanlama ve Kategoriler)

- **Alışkanlık Ekleme & Özelleştirme:**
  - **İsim:** Kullanıcı serbestçe alışkanlık başlığı tanımlar (Örn: "Sabah Koşusu", "Gitar Pratiği", "Su İç").
  - **İkon Seçimi (`icons/`):** Uygulama bünyesindeki `assets/icons/` dizininden yüklenen görsel ikon kümesinden seçim yapılır.
  - **Haftalık Gün Seçimi:** Haftanın 7 günü (Pzt, Sal, Çar, Per, Cum, Cmt, Paz) arasından birden fazla gün seçilebilir. Alışkanlık yalnızca işaretlenen günlerde aktifleşir.
  - **Zaman Aralığı Belirleme:** Alışkanlığın hangi saatler arasında icra edileceğini belirten başlangıç ve bitiş zamanı (Örn: `09:45 - 15:36`).
  - **Hatırlatıcı (Reminder) Bildirim Tiki:** Alışkanlık başlangıç saatinde veya aralık boyunca kullanıcıya anlık bildirim gönderilip gönderilmeyeceğini belirleyen açılır/kapanır anahtar (Switch / Checkbox).
- **Alışkanlık Silme & Düzenleme:**
  - Kart üzerinden sola kaydırarak (Swipe to Delete / Dismissible) veya detay modalından "Alışkanlığı Sil" butonuyla onay diyalogu eşliğinde güvenli silme.
- **Kategori Yönetimi (Temel 4 Kategori + Özel Kategoriler):**
  - **4 Temel Başlangıç Kategorisi:**
    1. **Spor:** Fitness, kardiyo, yürüyüş, esneme hareketleri.
    2. **Sağlık:** Su takibi, beslenme, uyku düzeni, soğuk duş.
    3. **Zihin:** Kitap okuma, meditasyon, nefes egzersizi, odaklanma.
    4. **Müzik:** Enstrüman çalma, solfej, müzik dinleme/üretim.
  - **Dinamik Kategori Ekleme:** Kullanıcı dilediği zaman `+ Kategori Ekle` seçeneğiyle kendi özel kategorisini (isim, renk paleti ve ikon) oluşturabilir.
- **Pozitif & Bırakma Odaklı Yapı:**
  - **Pozitif Alışkanlıklar (Kazanma):** Su içme (ml/bardak bazlı), spor yapma, kitap okuma (sayfa/dakika), yürüyüş (adım/süre), müzik pratikleri.
  - **Negatif Alışkanlıklar / Disiplin (Bırakma & Süreç):** Sigara bırakma, aralıklı oruç (fasting saat takibi), şeker detoksu.
- **Mikro Hedef Mantığı:** Küçük, sürdürülebilir günlük adımlarla zinciri kırmama (streak) felsefesi.

### 3.2. Günlük Mood Tracker (Duygu Durumu Takibi)

- **Çalışma Mantığı:** Uygulama gün içinde ilk kez açıldığında üst kısımda (banner olarak) veya küçük, şık bir Pop-up (Modal) olarak karşımıza çıkar.
- **4 veya 5 Şıklı Hızlı Seçim:** _Harika 🤩, İyi 🙂, Normal 😐, Kötü 😕, Berbat 😫_ şeklinde tek dokunuşla seçilebilir ikon/emoji yapısı.
- **Analiz Bağlantısı:** Seçilen mod, o gün tamamlanan alışkanlıklarla ilişkilendirilir (Örn: "Spor yaptığın günlerde modun %80 daha yüksek").

### 3.3. Oyunlaştırma (Gamification) & Başarı Sistemi

- **Zincir (Streak) Takibi:** Üst üste tamamlanan günlerin alev ikonuyla gösterimi.
- **Rozetler (Badges):** "7 Günlük Su Savaşçısı", "İlk Pomodoro", "30 Gün Sigarasız", "Soğuk Duş Ustası" gibi kilitli/açık başarı rozetleri.
- **Seviye ve XP (Deneyim Puanı):** Tamamlanan her mikro-alışkanlık ve Pomodoro döngüsü kullanıcıya XP kazandırır ve profil seviyesini (Level) artırır.

### 3.4. Roadmap (Yol Haritası) Sayfası

- **Hazır Şablonlar (Pre-built Roadmaps):** "0'dan 5Km Koşuya (30 Gün)", "21 Günde Şekeri Bırakma", "Gitar Çalmaya Başlangıç", "Soğuk Duş Adaptasyonu".
- **Kullanıcı Özel (Custom) Roadmap:** Kullanıcının kendi ana hedefini belirleyip bunu aşamalara (Milestone 1 -> Milestone 2 -> Final Hedef) böldüğü görsel yol haritası (dikey veya kıvrımlı düğüm/node görünümü).

### 3.5. Entegre Pomodoro Timer (Odaklanma Sayacı)

- Okuma, ders çalışma, müzik aleti pratiği gibi süre bazlı alışkanlıkların doğrudan uygulama içinden takip edilmesini sağlar.
- Klasik **25 dk Odaklanma / 5 dk Kısa Mola / 15 dk Uzun Mola** döngüsü veya seçilen alışkanlığa özel ayarlanabilir sayaç.
- Sayaç bittiğinde ilgili alışkanlığın günlük hedefini otomatik olarak "Tamamlandı" işaretler.

### 3.6. Grafik, İstatistik ve Analiz Yapıları

- **Haftalık / Aylık Tamamlanma Oranları:** Çubuk (Bar) ve Çizgi (Line) grafikleri.
- **Alışkanlık Isı Haritası (Heatmap):** GitHub katkı grafiği tarzında, ayın hangi günlerinde ne kadar yoğun alışkanlık yapıldığını gösteren renkli kutucuklar.
- **Mood - Alışkanlık Korelasyonu:** Duygu durumu değişimlerinin çizgi grafiği.
- **Kategori Dağılımı:** 4 temel kategori (Spor, Sağlık, Zihin, Müzik) ve özel kategorilerin pasta/halka grafiği ile görselleştirilmesi.

---

## 4. Planlanan Sayfa Yapısı

Sayfa spesifikasyonları proje kök dizinindeki `sayfalar/` klasöründe konumlandırılır:

1. **`SAYFA1.md` - Ana Ekran (Home & Daily Dashboard):**
   - Üstte Günlük Mood Tracker barı/pop-up'ı, haftalık yatay takvim şeridi, bugünün mikro-alışkanlık kartları (zaman aralığı rozetleri, su sayacı, tik kartları), kategori filtreleri (4 temel + dinamik), swipe-to-delete ile hızlı silme ve floating action button (+ Ekle).
2. **`SAYFA2.md` - Roadmap (Yol Haritası) Ekranı:**
   - Hazır yol haritası kütüphanesi ve kullanıcının kendi oluşturduğu adım adım hedef ağacı (kilitli/açık aşamalar).
3. **`SAYFA3.md` - Pomodoro & Odaklanma Ekranı:**
   - Dairesel geri sayım sayacı, hangi alışkanlık için odaklanıldığı seçimi, arka plan odak sesleri (opsiyonel) ve oturum geçmişi.
4. **`SAYFA4.md` - İstatistik ve Analiz Ekranı:**
   - Grafik yapıları (Bar chart, Line chart, Heatmap), Mood geçmişi, alışkanlık başarı yüzdeleri ve kategori bazlı dağılım (Spor, Sağlık, Zihin, Müzik, Özel).
5. **`SAYFA5.md` - Oyunlaştırma, Rozetler ve Profil Ekranı:**
   - Kullanıcı seviyesi (Level/XP), kazanılan ve kilitli rozetler vitrini, en uzun seriler (streaks) ve uygulama ayarları.
6. **`SAYFA6.md` - Alışkanlık Ekleme, Düzenleme, Silme & Kategori Yönetimi Modalı:**
   - Alışkanlık adı girişi, `icons/` ikon ızgarası, haftalık çoklu gün seçicisi (Pzt-Paz), zaman aralığı seçicisi (`09:45 - 15:36`), hatırlatıcı switch tiki, kategori seçici (4 temel kategori + yeni kategori ekleme diyaloğu) ve silme onay mekanizması.

---

## 5. Teknik Mimari ve Veri Yapısı Özeti (Flutter)

### 5.1. Kullanılacak Teknolojiler

- **Framework:** Flutter & Dart
- **Mimari Yaklaşım:** Feature-First (Özellik Odaklı) Modüler Yapı (`controllers`, `models`, `views`, `widgets`).
- **State Management:** `ValueNotifier` / `Provider` (Hızlı, reaktif ve temiz UI güncellemeleri için).
- **Veri Depolama:** Yerel JSON şablonları (`assets/data/`) + Kullanıcı verilerinin kalıcılığı için `SharedPreferences` veya `Hive` / `SQLite`.
- **Grafik & UI Paketleri:** `fl_chart` (grafikler için), `percent_indicator` (dairesel su/pomodoro göstergeleri için), `lucide_icons` veya Material İkonları.
- **İkon Varlıkları:** `assets/icons/` dizini altında kategorilendirilmiş SVG/PNG habit ikonları.

### 5.2. Temel Klasör Yapısı Taslağı

Proje `features/` dizini altında katman bazlı (`controllers`, `models`, `views`, `widgets`) ve varlık (`assets/icons/`) düzeninde inşa edilir:

```text
assets/
└── icons/                          # Alışkanlık ikon havuzu (spor, sağlık, zihin, müzik vb.)
    ├── sport_running.svg
    ├── health_water.svg
    ├── mind_book.svg
    ├── music_guitar.svg
    └── ...
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart            # Renkler, tipografi ve dark/light tema tanımları
│   │   └── app_sizes.dart            # Responsive S-M-L boyut standartları & Breakpointler
│   └── services/
│       ├── storage_service.dart      # SharedPreferences kalıcılık & tek seferlik mood flag
│       └── notification_service.dart
├── features/
│   ├── controllers/
│   │   ├── habit_controller.dart     # Alışkanlık ekleme, silme, tamamlama, filtreleme
│   │   ├── category_controller.dart  # 4 temel kategori + dinamik kategori ekleme
│   │   ├── mood_controller.dart      # Günlük mood & ilk girişte tek seferlik sorma
│   │   ├── pomodoro_controller.dart  # 25/5/15 dk odaklanma sayacı kontrolcüsü
│   │   └── roadmap_controller.dart   # Hedef ağacı ve aşama kontrolcüsü
│   ├── models/
│   │   ├── habit_model.dart          # İsim, ikon, günler, saat aralığı, hatırlatıcı, sayaç
│   │   ├── category_model.dart       # İsim, renk, ikon, isCustom
│   │   ├── mood_model.dart           # 5 duygu durumu modeli ve renkleri
│   │   ├── pomodoro_session_model.dart
│   │   └── roadmap_model.dart        # Aşama düğümleri ve kilit durumları
│   ├── views/                        # Her sayfa kendi açıklayıcı klasöründe (README.md ile)
│   │   ├── home/                     # Ana Ekran kontrol paneli
│   │   │   ├── home_view.dart
│   │   │   └── README.md
│   │   ├── roadmap/                  # Yol Haritası ve hedef ağacı
│   │   │   ├── roadmap_view.dart
│   │   │   └── README.md
│   │   ├── timer/                    # Odaklanma & Pomodoro sayacı
│   │   │   ├── pomodoro_view.dart
│   │   │   └── README.md
│   │   ├── analytics/                # İstatistikler ve veri analizi
│   │   │   ├── analytics_view.dart
│   │   │   └── README.md
│   │   ├── profile/                  # Profil, Level/XP, Rozetler & Tema
│   │   │   ├── profile_view.dart
│   │   │   └── README.md
│   │   ├── habit_form/               # Alışkanlık Ekle/Düzenle/Sil Modalı
│   │   │   ├── add_edit_habit_view.dart
│   │   │   └── README.md
│   │   └── navigation/               # Alt Navigasyon İskeleti (NavigationBar)
│   │       ├── main_navigation_view.dart
│   │       └── README.md
│   └── widgets/
│       ├── daily_mood_dialog.dart    # Günde 1 kez açılan tek seferlik mood modalı
│       ├── mood_selector_widget.dart # Responsive duygu durumu seçici
│       ├── daily_calendar_strip.dart # 7 günlük taşmayan responsive takvim şeridi
│       ├── habit_item_card.dart      # Geniş başlıklı, alt kontrollü sayaç kartı
│       └── streak_badge.dart         # Alev serisi rozeti
└── main.dart
```

## 6. Dokümantasyon Yol Haritamız (Sıradaki Adımlar)

Projenin tüm detaylarını eksiksiz inşa etmek için sırasıyla oluşturacağımız dosyalar:

- `PROJECT.md` (Tamamlandı - Genel Vizyon, Özellikler, Günlük Kayıtlar ve Mimari)
- `THEME.md` (Tamamlandı - Renk paletleri, tipografi, karanlık/aydınlık mod, S-M-L standartları)
- `DESIGN.md` (Tamamlandı - Kart tasarımları, Mood pop-up yapısı, grafik stilleri, taşma önleme kuralları)
- `sayfalar/SAYFA1.md` - `SAYFA6.md` (Her sayfanın detaylı UI elemanları, state akışı ve etkileşim kuralları)

## 7. Geliştirme, Analiz ve Test Komutları

Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır:

- **Statik kod analizi (0 uyarı ve 0 hata şart):**
  ```bash
  dart analyze lib
  ```
- **Projeyi çalıştırma:**
  ```bash
  flutter run
  ```

## 8. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe, teknik terimlerin özünü bozmadan, net ve doğrudan olacaktır.
- **Değişiklik Sunumları:** Yalnızca hedef satırları ve diff yapısını göster.
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
- **Doğrulama:** Kod yazdıktan sonra kullanıcıya doğrulama durumunu açıkça raporla.

## 9. Ajan Yetenekleri ve Yardımcı Araçlar

Projede geliştirme yapacak ajanlar ve geliştiriciler, `THEME.md`, `DESIGN.md` ve `.agents/skills/` dizini altındaki standartları kullanmalıdır:

- **Otomatik İskelet Betiği:** generate_feature.sh
- **Durum Akış Referansı:** state_flow.md
- **Altın Standart Referans Kod:** sample_screen.dart

## 10. Proje Kayıt Dosyaları (Günlük Kayıt Defteri)

### -- **Proje Kayıt Defteri : 1. Gün (23.10.2026)** --

**Günün Başarıları ve Tamamlanan İş Listesi:**

1. **Mimari ve Tasarım Sistemi Kurulumu:**
   - Flutter Material 3 tabanlı, **Mindful Emerald Rhythm** (Zümrüt Yeşili `#4EDEA3` ve Koyu Arduvaz `#0B1326`) tema sistemi kuruldu.
   - Aydınlık ve Karanlık mod dinamik desteği sağlandı.
   - `AppSizes` mimarisiyle Breakpointler (<360px Compact, 360-600px Normal, >600px Large) ve S-M-L (Küçük, Orta, Büyük) bileşen standartları tanımlandı.

2. **Ekranların (Views) İnşası ve Modüler Klasör Yapısı:**
   - `views/` dizini her sayfanın amacını anlatan bağımsız klasörlere bölündü ve her birine `README.md` dokümantasyonu eklendi:
     - `home/` (`home_view.dart` & `README.md`): Ana kontrol paneli, takvim şeridi, filtreleme, ilerleme kartı ve alışkanlık listesi.
     - `roadmap/` (`roadmap_view.dart` & `README.md`): Aşama aşama hedef ağacı, hazır şablonlar (5K Koşu, 21 Gün Şekersiz).
     - `timer/` (`pomodoro_view.dart` & `README.md`): 25/5/15 dk modlu entegre dairesel Pomodoro sayacı.
     - `analytics/` (`analytics_view.dart` & `README.md`): FL Chart başarı çubuk grafikleri, kategori pasta grafiği ve mood trendi.
     - `profile/` (`profile_view.dart` & `README.md`): Kullanıcı Level/XP kartı, rozetler vitrini, tema ve bildirim ayarları.
     - `habit_form/` (`add_edit_habit_view.dart` & `README.md`): Alışkanlık ekleme/düzenleme/silme, gün ve zaman aralığı seçici.
     - `navigation/` (`main_navigation_view.dart` & `README.md`): Alt navigasyon çubuğu ve günlük ilk giriş mood kontrolü.

3. **Taşma (Overflow) ve Metin Bölünmesi Hatalarının Giderilmesi:**
   - **Sayaç Kartı (74px Dikey Taşma ve Harf Harf Bölünme):** Sayaç kontrolleri `Row` içinden alınıp kartın alt satırına taşındı. Başlık tam genişliğe kavuştu (`maxLines: 2, overflow: TextOverflow.ellipsis`), dikey taşma ve kelimelerin tek tek alt alta kırılması tamamen önlendi.
   - **Takvim Şeridi (Sağdan Taşma):** 7 gün kutusu sabit 44px yerine `Expanded` ile sarılarak tüm ekranlara esnek (responsive) oturtuldu.

4. **Günlük Tek Seferlik Mood (Duygu Durumu) Mekanizması:**
   - `DailyMoodDialog` Bottom Sheet bileşeni geliştirildi.
   - Günün ilk açılışında `StorageService.isMoodPromptShownToday` ile kontrol edilerek kullanıcının modunu sorması sağlandı.
   - Kullanıcı seçim yaptığında veya "Daha Sonra" dediğinde flag kaydedilir; aynı gün içinde **asla tekrar sormaz**.
   - Seçilen mod ana sayfa başlığında şık `[🤩 Harika]` rozeti olarak gösterilerek kullanıcıya dilediğinde değiştirme imkanı sunuldu.

5. **Dokümantasyon Güncellemeleri:**
   - `THEME.md`, `DESIGN.md` ve `PROJECT.md` dokümanları responsive S-M-L matrisi, sayaç mimarisi ve 1. gün kayıtlarıyla güncellendi.
   - `dart analyze lib` ile 0 uyarı ve 0 hata ile doğrulandı.

6. **Aylık Aktivite Izgarası (Interactive Heatmap) Geliştirmesi:**
   - 7 kolonlu takvim şeması ve 5 kademeli zümrüt yeşili yoğunluk renklendirmesi inşa edildi.
   - Hücre üzerine gelindiğinde (Hover / Tooltip / MouseRegion) tarih ve tamamlanan alışkanlık sayısını gösteren canlı önizleme çubuğu ve masaüstü Tooltip eklendi.
   - Güne tıklandığında (Tap) o günün detaylarını (tarih, başarı oranı, mood, tamamlanan/eksik alışkanlıklar, kategori rozetleri ve saatleri) listeleyen interaktif Bottom Sheet modalı geliştirildi.

7. **Gerçek Yerel Bildirim Sistemi (Local Notifications):**
   - `flutter_local_notifications` (v22+) ve `timezone` paketleri projeye entegre edildi.
   - macOS, iOS ve Android platformları için dinamik bildirim izinleri bağlandı.
   - Profil sayfasına "Anlık Test Bildirimi Gönder" butonu eklendi.
   - Alışkanlıklar için belirlenen saatte (`09:45` vb.) günlük tekrarlanan yerel `zonedSchedule` hatırlatıcıları bağlandı.
   - Pomodoro odaklanma ve mola seansları tamamlandığında otomatik bildirim tetikleyicisi eklendi.
   - Tüm özelliklerin adım adım yapılış ve test yönergeleri `1.gün-23-ekim.md` dosyasında kaydedildi.

8. **Alışkanlık Onaylama/Silme Teyit Sistemi ve Yapılanlar/Yapılmayanlar Alt Açılır Listesi:**
   - Kazara silme ve onaylama işlemlerinin önüne geçmek için özel `ConfirmationDialog` bileşeni inşa edildi.
   - **Silme Durumu:** Kart kaydırılarak (Dismissible) veya formdan silinmek istendiğinde teyit istenir; onaylandığında veritabanından kalıcı olarak silinir.
   - **Onaylama Durumu:** Alışkanlık tamamlandığında (check veya sayaç hedefi) teyit istenir; onaylandığında verilerde saklanır ancak ana sayfadaki "Yapılacaklar" alanından "Tamamlananlar" alt açılır akordeon listesine taşınır.
   - "Tamamlananlar" bölümü açılır-kapanır (collapsible) yapıda tasarlanarak ana ekranın temiz kalması sağlandı.

9. **Gelişmiş Roadmap (Yol Haritası) Modülü ve Arka Plan Canlı Senkronizasyonu:**
   - **Hiyerarşik Mimari (Liste -> Detay):** `RoadmapListView` (aktif öne çıkan rota kartı, dikey aşama basamakları ağacı ve tamamlananlar akordeon arşivi) ve `RoadmapDetailView`.
   - **Dinamik Yol Haritası Oluşturma Sihirbazı (`CreateRoadmapSheet`):** `+` butonu ile kullanıcı dilediği kadar basamak ekleyebilir, hedef seri (streak) belirleyebilir ve mevcut alışkanlıklarından çoklu seçimle basamağa görev bağlayabilir.
   - **Single Source of Truth & Canlı Senkronizasyon:** `RoadmapController`, `HabitController`'ı sürekli dinler. Kullanıcı ana sayfada bir alışkanlığa tik attığı anda Roadmap ekranına gitmesine gerek kalmadan basamak ilerlemesi ve kilit açılmaları arka planda anında güncellenir.
   - **3 Kademeli Görsel Düğüm Ağacı (`RoadmapNodeTree`):** Kilitli (gri kilit, pasif hat), Aktif (parlayan rozet, aşama barı, bağlı günlük alışkanlık butonları) ve Tamamlanan (zümrüt zemin, onay tiki).
   - Dokümantasyon (`sayfalar/SAYFA2.md` ve `1.gün-23-ekim.md`) güncellendi.

---

-- **Proje Kayıt Defteri : 2. Gün (24.10.2026)  **
-- **Proje Kayıt Defteri : 3. Gün (25.10.2026)  **
-- **Proje Kayıt Defteri : 4. Gün (26.10.2026)  **
-- **Proje Kayıt Defteri : 5. Gün (27.10.2026)  **
-- **Proje Kayıt Defteri : 6. Gün (28.10.2026)  **
-- **Proje Kayıt Defteri : 7. Gün (29.10.2026)  **
-- **Proje Kayıt Defteri : 8. Gün (30.10.2026)  **
-- **Proje Kayıt Defteri : 9. Gün (31.10.2026)  **
-- **Proje Kayıt Defteri : 10. Gün (01.11.2026) **

## 11. Ajanın çıktı ve yanıt verme standartları

**Açıklamalar** Türkçe teknik terimlerin özünü bozmadan ve doğrudan olacaktır.
** Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.
**Dosya yolları** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
**Doğrulama** Kod yazdıktan sonra kullanıcı "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.

## 12 Kırmızı çizgiler kod kalite standartları
1 - **State Yönetim Standartları:**
    Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
    Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.