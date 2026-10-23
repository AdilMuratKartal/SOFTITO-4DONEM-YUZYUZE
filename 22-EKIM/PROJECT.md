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
│   ├── constants/
│   ├── theme/
│   ├── services/
│   │   └── notification_service.dart # Hatırlatıcı bildirim servisi
│   └── utils/
├── features/
│   ├── controllers/
│   │   ├── habit_controller.dart     # Ekleme, silme, tamamlama, filtreleme
│   │   ├── category_controller.dart  # 4 temel kategori + dinamik kategori ekleme
│   │   ├── mood_controller.dart
│   │   ├── pomodoro_controller.dart
│   │   ├── roadmap_controller.dart
│   │   └── profile_controller.dart
│   ├── models/
│   │   ├── habit_model.dart          # İsim, ikon, günler, saat aralığı, hatırlatıcı
│   │   ├── category_model.dart       # İsim, renk, ikon, isCustom
│   │   ├── mood_model.dart
│   │   ├── pomodoro_session_model.dart
│   │   ├── roadmap_node_model.dart
│   │   └── user_level_model.dart
│   ├── views/
│   │   ├── home_view.dart             # Sayfa 1
│   │   ├── roadmap_view.dart          # Sayfa 2
│   │   ├── pomodoro_view.dart         # Sayfa 3
│   │   ├── analytics_view.dart        # Sayfa 4
│   │   ├── profile_view.dart          # Sayfa 5
│   │   └── add_edit_habit_view.dart   # Sayfa 6 (Alışkanlık Ekle/Düzenle/Sil Modalı)
│   └── widgets/
│       ├── habit_item_card.dart       # Zaman aralıklı, silinebilir kart
│       ├── habit_icon_picker.dart     # assets/icons/ ikon seçici
│       ├── week_day_selector.dart     # Haftalık gün seçim çipleri
│       ├── time_range_picker.dart     # 09:45 - 15:36 saat aralığı seçici
│       ├── category_chips_bar.dart    # Kategori filtreleri & + Ekle butonu
│       ├── mood_picker_sheet.dart
│       ├── pomodoro_timer_dial.dart
│       ├── roadmap_tree_widget.dart
│       └── streak_counter_badge.dart
└── main.dart
```

## 6. Dokümantasyon Yol Haritamız (Sıradaki Adımlar)

Projenin tüm detaylarını eksiksiz inşa etmek için sırasıyla oluşturacağımız dosyalar:

PROJECT.md (Tamamlandı - Genel Vizyon, Özellikler ve Mimari)
THEME.md (Renk paletleri, tipografi, karanlık/aydınlık mod, kategori renkleri)
DESIGN.md (Kart tasarımları, Mood pop-up yapısı, grafik stilleri, ortak widget kuralları)
SAYFA1.md - SAYFA5.md (Her sayfanın detaylı UI elemanları, state akışı ve etkileşim kuralları)

## 7. Geliştirme, Analiz ve Test Komutları

Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlakaq alttaki komutların çalıştığını doğrulamalıdır:

- **Statik kod analizi (0 uyarı ve 0 hata şart):**

  ```bash
  flutter analyze
  ```

- **Birim ve widget testleri:**

  ```bash
  flutter test
  ```

- **Projeyi çalıştırma:**
  ```bash
  flutter run
  ```

## 8. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe, teknik terimlerin özünü bozmadan, net ve doğrudan olacaktır.
- **Değişiklik Sunumları:** 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; yalnızca hedef satırları ve diff yapısını göster.
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
- **Doğrulama:** Kod yazdıktan sonra kullanıcıya _"Şimdi `flutter analyze` ile kontrol edebilirsin"_ şeklinde doğrulama yönergeleri ver.

## 9. Ajan Yetenekleri ve Yardımcı Araçlar

Projede geliştirme yapacak ajanlar ve geliştiriciler, `THEME.md`, `DESING.md`, `sayfalar/SAYFA1.md` - `SAYFA5.md` ve `.agents/skills/` dizini altındaki standartları kullanmalıdır:

- **Otomatik İskelet Betiği:** generate_feature.sh
- **Durum Akış Referansı:** state_flow.md
- **Altın Standart Referans Kod:** sample_screen.dart
