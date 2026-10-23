# Mindful Emerald Rhythm Tasarım Sistemi & Tema Kuralları (THEME.md)

Bu doküman; `OTHER-DESIGN.md` dosyasındaki **Mindful Emerald Rhythm** tasarım spesifikasyonunu esas alan renk standartlarını, yüzey derinlik hiyerarşisini, tipografi ölçeklerini, bileşen kurallarını ve Flutter `ThemeData` yapılandırmasını içerir.

---

## 1. Tasarım Felsefesi & Marka Kimliği

**Mindful Emerald Rhythm**, sıfır sürtünmeli alışkanlık takibini ve olumlu psikolojik pekiştirmeyi hedefler:
- **Zümrüt Yeşili Odaklı Dinamizm:** Koyu arduvaz (`#0B1326`) arka plan üzerinde parlayan canlandırıcı zümrüt yeşili (`#4EDEA3`) başarma hissini tetikler.
- **Keskin 1px Hairline Geometri:** Ağır bulanık gölgeler yerine modern, net 1px konturlar (`border-dark: #2D3449`, `outline-variant: #3C4A42`) ve hassas katman kontrastları kullanılır.
- **Ergonomi ve Hızlı Etkileşim:** Başparmak erişiminde optimize edilmiş tek dokunuşlu aksiyonlar, 38px dairesel onay butonları, elastik dokunsal geri bildirim (Haptic Feedback) ve akıllı durum geçişleri.

---

## 2. Renk Paleti (Mindful Emerald Rhythm Color Tokens)

### 2.1. Yüzey ve Tuval Mimarisi (Surface Hierarchy)
| Rol | Token Adı | Hex Değeri | Flutter Değeri | Kullanım Alanı |
| :--- | :--- | :--- | :--- | :--- |
| **Scaffold Arka Planı** | `background / surface` | `#0B1326` | `Color(0xFF0B1326)` | Ana Scaffold ve SafeArea tabanı |
| **Kart & Modül Zemini** | `surface-container` | `#171F33` | `Color(0xFF171F33)` | Alışkanlık kartları, form alanları, takvim şeridi |
| **Yükseltilmiş Kontroller** | `surface-container-high`| `#222A3D` | `Color(0xFF222A3D)` | İnaktif ikon kutuları, açılır paneller, sayaç zeminleri |
| **En Yüksek Yüzey** | `surface-container-highest` | `#2D3449`| `Color(0xFF2D3449)` | Kenarlıklar, derin yüzey ayırıcıları |
| **Parlak Yüzey** | `surface-bright` | `#31394D` | `Color(0xFF31394D)` | Hover ve aktif buton vurguları |

### 2.2. Tipografi ve Metin Kontrast Renkleri
| Rol | Token Adı | Hex Değeri | Flutter Değeri | Açıklama |
| :--- | :--- | :--- | :--- | :--- |
| **Birincil Metin** | `on-surface` | `#DAE2FD` | `Color(0xFFDAE2FD)` | Yüksek kontrastlı başlıklar, kart metinleri |
| **İkincil Metin** | `on-surface-variant` | `#BBCABF` | `Color(0xFFBBCABF)` | Hedef detayları, pasif etiketler, ipuçları |
| **Dış Hat (Outline)** | `outline` | `#86948A` | `Color(0xFF86948A)` | İnaktif ikonlar ve ikincil buton çizgileri |
| **Varyant Hat** | `outline-variant` | `#3C4A42` | `Color(0xFF3C4A42)` | Standart 1px kart sınır çizgileri |

### 2.3. Vurgu ve Aksiyon Renkleri (Action Engine)
| Rol | Token Adı | Hex Değeri | Flutter Değeri | Kullanım Alanı |
| :--- | :--- | :--- | :--- | :--- |
| **Primary (Ana Vurgu)**| `primary` | `#4EDEA3` | `Color(0xFF4EDEA3)` | Tamamlama tikleri, kaydet butonları, aktif çipler |
| **On Primary (Yazı)** | `on-primary` | `#003824` | `Color(0xFF003824)` | Primary buton içi koyu kontrast metin ve ikonlar |
| **Primary Container** | `primary-container`| `#10B981` | `Color(0xFF10B981)` | Başarı rozetleri, aktif gün zeminleri |
| **Secondary (Kehribar)**| `secondary` | `#FFB95F` | `Color(0xFFFFB95F)` | Seri (Streak) alev ikonları, odaklanma sayacı |
| **On Secondary** | `on-secondary` | `#472A00` | `Color(0xFF472A00)` | Kehribar zemin üzeri koyu kontrast metin |
| **Tertiary (Buz Mavisi)**| `tertiary` | `#ADC6FF` | `Color(0xFFADC6FF)` | Zaman aralığı etiketleri (`09:45 - 15:36`), saat ikonları |
| **Danger / Error** | `danger / error` | `#EF4444` | `Color(0xFFEF4444)` | Swipe-to-delete zeminleri, silme butonları |

---

## 3. Alışkanlık Kategori Renkleri (4 Temel Kategori + Özel)

1. **Spor (Fitness, Egzersiz, Koşu):** `#4EDEA3` (Zümrüt Yeşili) — Yumuşak Zemin: `#4EDEA3` (%15 alpha)
2. **Sağlık (Su, Beslenme, Uyku):** `#34D399` (Canlı Nane) — Yumuşak Zemin: `#34D399` (%15 alpha)
3. **Zihin (Kitap, Meditasyon, Zihin):** `#ADC6FF` (Buz Mavisi) — Yumuşak Zemin: `#ADC6FF` (%15 alpha)
4. **Müzik (Enstrüman, Sanat, Pratik):** `#FFB95F` (Sıcak Kehribar) — Yumuşak Zemin: `#FFB95F` (%15 alpha)

**Dinamik Kategori Paleti (Form Üzerinden Seçilebilir 5 Renk):**
- Zümrüt: `#4EDEA3`
- Kehribar: `#FFB95F`
- Buz Mavisi: `#ADC6FF`
- Nane Yeşili: `#34D399`
- Sıcak Turuncu: `#FB923C`

---

## 4. Mood Tracker (Duygu Durumu) Skalası
Tüm duygusal durumlar eşit doygunlukta kalibre edilmiştir:
- **Harika (Great - 🤩):** `#10B981` (Zümrüt Yeşili) — Aktif Zemin: `#10B981` (%18 alpha)
- **İyi (Good - 🙂):** `#34D399` (Açık Zümrüt) — Aktif Zemin: `#34D399` (%18 alpha)
- **Normal (Neutral - 😐):** `#FBBF24` (Sarı / Amber) — Aktif Zemin: `#FBBF24` (%18 alpha)
- **Kötü (Bad - 😕):** `#FB923C` (Turuncu) — Aktif Zemin: `#FB923C` (%18 alpha)
- **Berbat (Terrible - 😫):** `#F87171` (Mercan Kırmızısı) — Aktif Zemin: `#F87171` (%18 alpha)

---

## 5. Tipografi Mimarisi (Plus Jakarta Sans)

| Düzey | Boyut | Satır Yüksekliği | Kalınlık | Karakter Aralığı (Tracking) |
| :--- | :--- | :--- | :--- | :--- |
| `display-timer` | 36px - 42px | 44px | 700 / 800 | -0.02em |
| `headline-section` | 18px | 24px | 700 | -0.01em |
| `title-card` | 15px | 20px | 600 | 0 |
| `body-default` | 14px | 20px | 400 | 0 |
| `body-subdued` | 13px | 18px | 500 | 0 |
| `label-badge` | 12px | 16px | 700 | +0.02em |
| `label-meta` | 12px | 16px | 600 | +0.01em |
| `label-caption` | 12px | 16px | 400 | 0 |
| `label-micro-active` | 11px | 14px | 700 | 0 |
| `label-micro-default`| 11px | 14px | 500 | 0 |

---

## 6. Şekiller, Radius ve Boşluk Standartları

- **Kartlar & Modüller:** 16px radius (`0.75rem - 1rem`).
- **İkon Kutuları & Küçük Kontroller:** 12px radius (`0.75rem`).
- **Pill Rozetler (Streak/Hafta İçi):** 20px radius.
- **Tamamlama Butonları:** 38px dairesel tam dokunma alanı.
- **Sayfa Kenar Boşlukları:** 16px yatay (`1rem`), 12px dikey (`0.75rem`).
- **Kartlar Arası Boşluk:** 12px dikey boşluk.

---

## 7. Responsive Boyut Mimarisi & S-M-L Standartları (`AppSizes`)

Uygulamanın küçük ekranlarda (320px - 360px), tabletlerde veya masaüstü pencerelerinde taşma (RenderFlex overflow) yaşamaması ve metinlerin tek karaktere bölünerek aşağı taşmaması için önceden belirlenmiş katı boyut kuralları uygulanır.

### 7.1. Kırılım Noktaları (Responsive Breakpoints)
| Seviye | Genişlik Aralığı | Hedef Cihaz / Görünüm | Düzen Davranışı |
| :--- | :--- | :--- | :--- |
| **Kompakt (Compact)** | `< 360px` | Küçük ekranlı telefonlar, dar pencereler | Metinler `TextOverflow.ellipsis`, `FittedBox`, rozetler mikro boyutta |
| **Standart (Medium)** | `360px - 600px` | Standart akıllı telefonlar | Varsayılan akışkan tasarım, tam etiketler |
| **Geniş (Large)** | `> 600px` | Tabletler, katlanabilirler, masaüstü | Merkezlenmiş maksimum genişlikli kolon (`max-width: 600px`) |

### 7.2. Önceden Tanımlı Bileşen Boyut Matrisi (Küçük, Orta, Büyük)

| Bileşen | Küçük (S) | Orta (M - Varsayılan) | Büyük (L) | Açıklama & Taşma Önleme Kuralı |
| :--- | :--- | :--- | :--- | :--- |
| **İkon Kutusu (Icon Box)** | `28x28 px` | `38x38 px` | `48x48 px` | Alışkanlık kategori ikonları standart `38x38px` (M) kullanılır. |
| **İkon Boyutu (Icon Size)** | `16 px` | `20 px` | `24 px` (XL: 28px) | Net okunabilirlik için orantılı glif ölçeği. |
| **Aksiyon Butonları (Buttons)**| `32 px` yükseklik | `44 px` yükseklik | `52 px` yükseklik | Stepper sayaç butonları `32x32px`, onay çemberi `38x38px`. |
| **Dokunma Alanı (Touch Target)**| Min `44x44 px` | Min `48x48 px` | Min `56x56 px` | WCAG erişilebilirlik standardı; küçük butonlarda `padding` ile sağlanır. |
| **Takvim Günü (Calendar Day)** | Min Genişlik: `36 px` | Min Yükseklik: `62 px` | Akışkan `Expanded` | **Sabit 44px genişlik YASAKTIR.** 7 gün `Expanded` ile eşit bölünür. |
| **Alışkanlık Kartı (Habit Card)**| Min Yükseklik: `74 px` (Tik) | Min Yükseklik: `114 px` (Sayaç)| Otomatik Yükseklik | **Sabit yükseklik YASAKTIR.** İçerik kadar dikey esner, dikey taşma engellenir. |
| **İlerleme Çubuğu (Progress)** | `4 px` yükseklik | `6 px` yükseklik | `8 px` yükseklik | Kart içi sayaç ilerlemelerinde `6px` kalınlık ve `6px` radius kullanılır. |

### 7.3. Taşma (Overflow) ve Metin Kayması Önleme Kuralları
1. **Yatay Satır (Row) İçi Başlıklar:** Başlık içeren tüm sütunlar MUTLAKA `Expanded` içine alınmalıdır. Başlık yanına asla geniş sayaç kontrolleri (`[-] 1500 / 2000 ml [+]`) konulmamalıdır; bu durum başlığa 30px bırakıp harf harf dikey taşmaya (`Su / İç / (Mikr / o / ...)` ve `74 PIXELS OVERFLOW`) yol açar.
2. **Sayaçlı Kart Yerleşimi:** Sayaçlı alışkanlıklarda başlık, kategori ve süre üst satırda tam genişlikte yer alır. Sayaç artır/azalt kontrolleri ve ilerleme çubuğu ise kartın ALTINA tam genişlikli bir bar olarak yerleşir.
3. **Metin Kısıtlama (Text Truncation):** 
   - Kart Başlıkları: `maxLines: 2`, `overflow: TextOverflow.ellipsis`.
   - Süre ve Kategori Rozetleri: `maxLines: 1`, `overflow: TextOverflow.ellipsis`.
   - Gün İlerleme Başlığı: `Flexible` içinde `maxLines: 1`, `overflow: TextOverflow.ellipsis`.
4. **Haftalık Takvim Şeridi:** 7 gün bir `Row` içinde `Expanded` widget'ı ile sarılır. Hiçbir cihazda sağdan taşma (Right Overflow) yapamaz.

---

## 8. Günlük Mood Check-In Akışı (Single-Prompt Daily Policy)

Kullanıcıyı boğmayan ve bilişsel yük oluşturmayan duygu durumu (mood) takibi için belirlenen sistem kuralları:

1. **Günün İlk Girişinde Tek Seferlik Sorma:**
   - Uygulama açılışında `StorageService.isMoodPromptShownToday(dateKey)` ve `StorageService.getTodayMood(dateKey)` sorgulanır.
   - Eğer kullanıcı o gün henüz mood seçmemişse ve modal henüz gösterilmemişse, açılışta modern `DailyMoodDialog` Bottom Sheet açılır.
2. **Asla Tekrar Sormama Garantisi:**
   - Kullanıcı 5 mooddan birini seçtiğinde veya "Daha Sonra (Bugün Tekrar Sorma)" butonuna bastığında `mood_prompt_shown_YYYY-MM-DD = true` olarak kaydedilir.
   - Aynı gün boyunca uygulama kapatılıp açılsa dahi dialog bir daha ASLA otomatik açılmaz.
3. **Ana Sayfa Entegrasyonu (Sıfır Kalabalık):**
   - Mod kaydedildikten sonra ana sayfadaki büyük mod seçim kutusu gizlenir; dikey alan alışkanlık kartlarına bırakılır.
   - Seçilen mod, üst başlıkta interaktif şık bir hap rozet olarak (`[🤩 Harika]`) gösterilir.
   - Kullanıcı gün içinde modunu değiştirmek isterse bu rozete tıklayarak seçimini güncelleyebilir.