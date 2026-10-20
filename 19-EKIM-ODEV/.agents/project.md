# Dijital Günlük Uygulaması

Bu döküman Flutter projesinde geliştirme yapacak olan Ajan(antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir klavuzdur.Projede üretilen her kod satırı burdaki kurallara UYMAK ZORUNDADIR.

## 1.Proje Özeti ve Teknolojiler

- **Uygulama adı:** iJournal (akıllı dijital günlük uygulaması)
- **Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformları
- **Flutter SDK:** 3.29.0
- **Dart SDK:** 3.0.0
- **Tasarım dili:** Material 3, Koyu ve Aydınlık Tema Desteği , Tema Seçebilme Özelliği;
  - NeoBrutalist
  - Minimalist
  - Journal
  - Hand-Drawn / Hand-Crafted
  - Rubber Hose Style (1920s - 1930s)

- **Tasarım Renk Paletleri:**

  ### 1. NeoBrutalist (Sert Kontrast, Kalın Kenarlıklar ve Pop Renkler)

  _Tasarım karakteri: 2-3px saf siyah kenarlıklar, keskin gölgeler, enerjik ve ham retro-modern hava._
  - **Gündüz (Light):**
    - `Background (Arka Plan):` `#FFFDF0` (Sıcak kırık beyaz)
    - `Surface (Kartlar/Kutular):` `#FFE500` (Canlı Neo Sarı) ve `#A3E635` (Asit Yeşili)
    - `Primary / Border (Çizgiler ve Metin):` `#000000` (Saf Siyah - 2-3px stroke)
    - `Secondary / Accent (Vurgu):` `#FF70A6` (Bubblegum Pembe) / `#00F0FF` (Elektrik Camgöbeği)
    - `Shadow (Sert Gölgeler):` `#000000` (Blur olmadan, 4px x 4px ofset)
  - **Gece (Dark):**
    - `Background (Arka Plan):` `#121212` (Derin zift siyahı)
    - `Surface (Kartlar/Kutular):` `#1E1E24` (Koyu antrasit)
    - `Primary / Border (Çizgiler ve Metin):` `#FFE500` (Neon Sarı kenarlıklar) ve `#FFFFFF` (Beyaz metin)
    - `Secondary / Accent (Vurgu):` `#CCFF00` (Fosforlu Lime) / `#FF4365` (Neon Kırmızı-Pembe)
    - `Shadow (Neon Glow / Sert Gölge):` `#000000` (veya `#FFE500` renkli sert gölge)

  ***

  ### 2. Minimalist (Sade, Dikkat Dağıtmayan İskandinav/İsviçre Tipografisi)

  _Tasarım karakteri: Geniş boşluklar, yumuşak mikro-kontrastlar, gözü yormayan saf odak._
  - **Gündüz (Light):**
    - `Background (Arka Plan):` `#FBFBFB` (Saf kağıt beyazı)
    - `Surface (Kartlar):` `#FFFFFF` (Temiz beyaz yüzey)
    - `Text Primary (Başlıklar/Metin):` `#1A1A1A` (Yumuşatılmış grafit siyah)
    - `Text Secondary (Tarih/İpuçları):` `#8E8E93` (Nötr gri)
    - `Accent / Outline (Vurgu/Ayrım):` `#4A6FA5` (Muted İskandinav Mavisi) / `#E5E5EA` (İnce çizgi)
  - **Gece (Dark):**
    - `Background (Arka Plan):` `#0F0F10` (OLED dostu saf siyah tonu)
    - `Surface (Kartlar):` `#1C1C1E` (Yükseltilmiş koyu gri katman)
    - `Text Primary (Metin):` `#F2F2F7` (Göz almayan yumuşak kırık beyaz)
    - `Text Secondary (Detaylar):` `#636366` (Kül grisi)
    - `Accent / Outline (Vurgu):` `#64D2FF` (Buz mavisi) / `#2C2C2E` (Ayrım çizgisi)

  ***

  ### 3. Journal (Klasik Deri Defter, Parşömen ve Dolma Kalem Mürekkebi)

  _Tasarım karakteri: Moleskine hissi, vintage defter dokusu, sepiya ve nostaljik günlük estetiği._
  - **Gündüz (Light):**
    - `Background (Arka Plan):` `#F5EFEB` (Sıcak keten parşömen)
    - `Surface (Sayfa Kartı):` `#FFFDF8` (Krem defter yaprağı)
    - `Text Primary (Mürekkep):` `#1B263B` (Gece mavisi dolma kalem mürekkebi)
    - `Secondary (Cilt/Bant):` `#D4A373` (Taba kraft deri tonu)
    - `Accent (Mühür/İşaret):` `#8A3324` (Koyu kiremit / mühür mumu kırmızısı)
  - **Gece (Dark):**
    - `Background (Arka Plan):` `#181512` (Eski koyu maun ağacı)
    - `Surface (Sayfa/Kart):` `#26211C` (Koyu tütün rengi deri katman)
    - `Text Primary (Metin):` `#E6DFD5` (Fildişi parşömen yazısı)
    - `Secondary (Çerçeveler):` `#C69C6D` (Pirinç/antika metal rengi)
    - `Accent (Vurgu):` `#D48C46` (Sıcak kehribar / mum alevi sarısı)

  ***

  ### 4. Hand-Drawn / Hand-Crafted (El Çizimi, Eskiz Defteri ve Kraft Kağıt)

  _Tasarım karakteri: Karalama kenarlıklar, kurşun kalem hissi, post-it ve washi-tape detayları._
  - **Gündüz (Light):**
    - `Background (Arka Plan):` `#F4EBD9` (Organik samanlı kraft kağıt)
    - `Surface (Post-it / Eskiz Kartı):` `#FFF9DE` (Pastel not kağıdı sarısı)
    - `Text & Doodles (Çizim/Metin):` `#2B2D42` (2B kurşun kalem antrasiti)
    - `Accent 1 (Fosforlu Kalem):` `#F4A261` (Pastel şeftali turuncusu)
    - `Accent 2 (Washi Tape/Bant):` `#81B29A` (Adaçayı yeşili el işi bandı)
  - **Gece (Dark - Kara Tahta Modu):**
    - `Background (Arka Plan):` `#1E2229` (Koyu okul kara tahtası)
    - `Surface (Kartlar):` `#2C313C` (Tebeşir tozu grisi)
    - `Text & Doodles (Tebeşir):` `#ECEFF1` (Yumuşak tebeşir beyazı)
    - `Accent 1 (Renkli Tebeşir):` `#FDE68A` (Açık sarı tebeşir)
    - `Accent 2 (Vurgu Tebeşiri):` `#FCA5A5` (Toz pembe tebeşir)

  ***

  ### 5. Rubber Hose Style (1920'ler - 1930'lar Vintage Animasyon & Sessiz Film)

  _Tasarım karakteri: Steamboat Willie, Fleischer çizgi filmleri, esnek kollar, grenli selüloit film._
  - **Gündüz (Light - Eskitme Selüloit / Technicolor):**
    - `Background (Arka Plan):` `#EFE5D0` (Sararmış vintage film şeridi)
    - `Surface (Karakter Kartı):` `#FFF8EA` (1930'lar krem çizgi film dolgusu)
    - `Text & Line-Art (Çini Mürekkebi):` `#111111` (Mat eski baskı siyahı)
    - `Accent (Vintage Kırmızı):` `#C84B31` (Erken dönem Technicolor kırmızısı)
    - `Secondary Accent (Eski Altın):` `#DDA15E` (Radyo çağı pirinç sarısı)
  - **Gece (Dark - Sinema Projektörü / Negatif Film):**
    - `Background (Arka Plan):` `#12100E` (Nitrat film siyahı / loş sinema salonu)
    - `Surface (Kartlar):` `#231F1B` (Sepiya gölge katmanı)
    - `Text Primary (Metin):` `#EDE0C8` (Projektör ışığı krem beyazı)
    - `Text & Line-Art (Çizgiler):` `#B58A63` (Eski film şeridi yanığı)
    - `Accent (Vurgu):` `#9B2226` (Kadife tiyatro perdesi bordosu)

---

# Mimari Yapı : Özellik bazlı

Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

lib/
│
├── core/ # Tüm uygulamada ortak kullanılan çekirdek yapılar
│ ├── constants/ # Sabitler
│ │ ├── app_strings.dart # Metin sabitleri
│ │ └── app_assets.dart # İkon, font ve görsel yolları
│ │
│ ├── theme/ # 5 Farklı Tema ve Renk Mimarisi
│ │ ├── models/
│ │ │ └── app_theme_type.dart # enum JournalTheme { neoBrutalist, minimalist, journal, handDrawn, rubberHose }
│ │ ├── palettes/ # 5 temanın renk kodları
│ │ │ ├── neo_brutalist_colors.dart
│ │ │ ├── minimalist_colors.dart
│ │ │ ├── journal_classic_colors.dart
│ │ │ ├── hand_drawn_colors.dart
│ │ │ └── rubber_hose_colors.dart
│ │ ├── extensions/ # Material 3 dışındaki özel stiller (ör. NeoBrutalist kalın kenarlık/gölge)
│ │ │ └── journal_theme_extension.dart
│ │ ├── controllers/
│ │ │ └── theme_controller.dart # ValueNotifier tabanlı tema değiştirici (Gece/Gündüz + 5 Tema)
│ │ └── app_themes.dart # ThemeData üreten ana factory sınıfı
│ │
│ ├── extensions/ # Dart uzantıları (Tarih formatlama, context.theme kısayolları vb.)
│ │ ├── context_extensions.dart # context.theme, context.colors pratik erişimleri
│ │ └── date_extensions.dart # Günlük tarih formatlayıcılar
│ │
│ └── services/ # Yerel depolama ve donanım servisleri (Hafif yerel çözümler)
│ └── storage_service.dart # Seçilen tema ve ayarları cihazda saklama
│
├── features/ # Modüler Özellikler (Her biri kendi içinde bağımsız)
│ │
│ ├── entry_editor/ # Günlük Yazma / Düzenleme Ekranı
│ │ ├── controllers/
│ │ │ └── entry_editor_controller.dart
│ │ ├── models/
│ │ │ └── journal_entry_model.dart # copyWith, fromJson, toJson içeren değişmez model
│ │ ├── view/
│ │ │ └── entry_editor_view.dart
│ │ └── widgets/
│ │ ├── mood_picker_widget.dart # Duygu durumu seçici
│ │ └── text_formatting_bar.dart # Yazı araç çubuğu
│ │
│ ├── timeline/ # Ana Akış / Geçmiş Günlükler Listesi
│ │ ├── controllers/
│ │ │ └── timeline_controller.dart
│ │ ├── models/
│ │ │ └── timeline_filter_model.dart
│ │ ├── view/
│ │ │ └── timeline_view.dart
│ │ └── widgets/
│ │ ├── entry_card_widget.dart # Temaya göre şekillenen günlük kartı
│ │ └── search_bar_widget.dart
│ │
│ ├── calendar_view/ # Takvim / Ay Bazlı Görünüm
│ │ ├── controllers/
│ │ │ └── calendar_controller.dart
│ │ ├── view/
│ │ │ └── calendar_view.dart
│ │ └── widgets/
│ │ └── day_cell_widget.dart
│ │
│ └── theme_selector/ # 5 Farklı Temayı Canlı Önizleme ve Seçme Modülü
│ ├── controllers/
│ │ └── theme_selector_controller.dart
│ ├── view/
│ │ └── theme_selector_view.dart
│ └── widgets/
│ └── theme_preview_card.dart # NeoBrutalist, RubberHose vb. önizleme kartı
│
└── main.dart # Yalnızca Controller başlatma ve MaterialApp teması

### sadece uygulama başlatma ve tema bölümleri

## 3 Kırmızı çizgiler kod kalite standartları

1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Durum yönetimi için ValueNotifier ve ChangeNotifier kullanılacaktır.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans Kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renkler doğrudan koda sabit (Color(0xFF...)) olarak YAZILMAYACAKTIR.
Renkler her zaman Theme.of(context) veya context.colors üzerinden okunacaktır.
Temaya özel kenarlık ve gölgeler ThemeExtension üzerinden okunacaktır.
Büyük build methodları yasaktır 40 satırı geçen build metodları özel widgetlara yazılacaktır.

3 - **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4 Geliştirme analiz ve test komutları

Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

- **Statik kod analizi(0 uyarı ve 0 hata şart):**
  ``bash
  flutter analyze

````

* **Birim ve widget testleri:**
```bash
flutter test
````

- **Projeyi çalıştırma:**

```bash
flutter run
```

## 5 Ajanın çıktı ve yanıt verme standartları

**Açıklamalar** Türkçe teknik terimlerin özünü bozmadan ve doğrudan olacaktır.
**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.
**Dosya yolları** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
**Doğrulama** Kod yazdıktan sonra kullanıcı "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.

# 6 Çekirdek Özellikler (Core Features)

1. **Günlük Yazma ve Düzenleme (Entry Editor):** Zengin metin yazımı, duygu durumu (mood picker) seçimi ve etiket ekleme.
2. **Akış ve Takvim (Timeline & Calendar):** Günlükleri tarihe göre listeleme, arama ve filtreleme.
3. **Canlı Tema Değiştirici (Theme Selector):** 5 tema arasında tek dokunuşla anında geçiş ve canlı kart önizlemesi. Gece ve Gündüz modları arasında tek tuşla geçiş (ThemeMode.light / ThemeMode.dark).
4. **Yerel Veri Saklama (Offline-First):** Günlükler ve seçilen tema tercihi yerel depolamada saklanacaktır.

# 7 Uygulama Logosu Tasarımı ve Entegrasyonu

Uygulama amacı, vizyonu öne alınıp, buna uygun tasarım tasarlayıp, uygulamaya eklenecek

# 8 Tema Mimarisi ve ThemeExtension Standartları

Durum: Tema durumu ThemeController içinde ValueNotifier<ThemeMode> ve ValueNotifier<JournalTheme> ile yönetilir.

1. **Özel Bileşen Stilleri (JournalThemeExtension):**

- NeoBrutalist için 3px sert kenarlık ve blur içermeyen sert gölge.
- Minimalist için 0px kenarlık ve hafif margin boşluğu.
- Journal için dikişli kenarlık veya parşömen doku çizgisi.
- Hand-Drawn için hafif açılı (wobbly/sketch) kenarlık hissi.
- Rubber Hose için kalın karikatür konturu (cartoon ink border).

## 9 Tema Değiştirici ve Kullanıcı Deneyimi (UX)

**Kullanıcı Etkileşimi:** AppBar üzerinde kullanıcı tek dokunuşla (Güneş / Ay ikonu) anında mod geçişi yapabilecektir.

**Performans:** Temel Materyal renkleri colorScheme'den gelir.  
 Koyu/Aydınlık geçişi için `Theme.of(context).brightness` kontrol edilir.  
 Temayı değiştirirken tüm uygulama widget'ları yeniden çizilmeyecektir.

## 10 Ajan Yetenekleri ve Yardımcı Araçlar

Projede geliştirme yapacak ajanlar .agents/skills/ dizini altındaki standartları kullanmalıdır:

- Tema Sistemi Yeteneği: .agents/skills/theme-system/SKILL.md
- Özellik İskeleti Yeteneği: .agents/skills/feature-scaffold/SKILL.md
