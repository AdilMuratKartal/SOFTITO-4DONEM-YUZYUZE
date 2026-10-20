# TakeGO - Akıllı Araç Kiralama, İlan ve Paylaşım Platformu

Bu doküman, Flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

---

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** TakeGO (Araç Kiralama, Bireysel İlan Verme, Dijital Anahtar ve Anlık Paylaşım Platformu)
- **Hedef Platformlar:** iOS ve Android öncelikli, ardından Web ve Masaüstü platformları
- **Flutter SDK:** 3.29.0
- **Dart SDK:** 3.0.0
- **Tasarım Dili:** Material 3, Koyu ve Aydınlık Tema Desteği (OLED Cockpit Dark Gece Paleti / Clean Mobility Light Gündüz Paleti) — *Çoklu tema seçimi yoktur; tek bir kurumsal otomotiv teması ve onun Gece/Gündüz modları vardır.*

### Görsel ve Kart Boyut Standartları (Sabit Resim Boyutları)
Şu anda gerçek araç fotoğrafları dinamik olarak sunucudan gelmediği için arayüzde taşmaları ve tasarım bozulmalarını önlemek adına tüm resim alanları sabitlenmiştir:
- **İlan Kartı Görseli (Liste Ekranı):** Sabit `AspectRatio(aspectRatio: 16 / 9)` veya `height: 180.0`, `width: double.infinity`. Köşe yuvarlaklığı: `BorderRadius.circular(16)`.
- **İlan Detay Görseli (Detay Ekranı):** Sabit `height: 260.0`, `width: double.infinity`. `BoxFit.cover` ve yüklenemeyen durumlar için temaya uygun şık **gri silüet/placeholder kutusu**.
- **İlan Verme Fotoğraf Yükleme Alanı:** Sabit `height: 140.0`, kesikli kenarlık (dashed border) veya temaya uygun dolgulu yükleme alanı.

### Tasarım Renk Paletleri (Cyber Drive Otomotiv Paleti)

* **Gündüz Modu (Clean Mobility Light):**
  - `Background (Arka Plan):` `#F6F8FA` (Temiz asfalt grisi / kırık beyaz)
  - `Surface (Kartlar ve Paneller):` `#FFFFFF` (Saf beyaz yükseltilmiş yüzey)
  - `Primary (Ana Vurgu - Elektrik Mavisi):` `#0066FF` (Güven, hız ve teknoloji hissi)
  - `Secondary (İkincil Vurgu - Enerji Yeşili):` `#00D084` (Aktif ilan, benzin/şarj durumu ve onay)
  - `Text Primary (Başlıklar ve Araç Modeli):` `#111827` (Derin antrasit siyah)
  - `Text Secondary (Detaylar ve Fiyat Birimi):` `#6B7280` (Orta ton nötr gri)
  - `Border / Divider (Çizgiler):` `#E5E7EB` (İnce kart kenarlığı)
  - `Image Placeholder (Resim Alanı Dolgusu):` `#E2E8F0` (Açık metalik gri silüet dolgusu)
  - `Warning / Alert (Uyarı ve Kilit):` `#F59E0B` (Amber sarısı) / `#EF4444` (Kırmızı)

* **Gece Modu (OLED Cockpit Dark - Gece Sürüşü):**
  - `Background (Arka Plan):` `#0B0E14` (Gece sürüşünde gözü yormayan derin kabin siyahı)
  - `Surface (Kartlar ve Paneller):` `#161B26` (Koyu kokpit antrasiti)
  - `Primary (Ana Vurgu - Neon Mavi):` `#2F80ED` (Karanlıkta net okunan elektrik mavisi)
  - `Secondary (İkincil Vurgu - Fosforlu Yeşil):` `#10B981` (Aktif kilit ve şarj göstergesi)
  - `Text Primary (Başlıklar):` `#F9FAFB` (Yumuşak saf beyaz)
  - `Text Secondary (Detaylar):` `#9CA3AF` (Metalik gümüş gri)
  - `Border / Divider (Çizgiler):` `#242C3D` (Loş kokpit çerçevesi)
  - `Image Placeholder (Resim Alanı Dolgusu):` `#1F2937` (Koyu antrasit silüet dolgusu)
  - `Warning / Alert (Uyarı ve Kilit):` `#FBBF24` (Parlak kehribar) / `#F87171` (Kırmızı)

---

## 2. Mimari Yapı: Özellik Bazlı (Feature-First)

Kodlar kesinlikle tek bir yerde toplanmayacaktır. Yalnızca geliştirilen aktif modüller `features/` altında kendi klasöründe kodlanacak; gereksiz veya boş klasör yapılandırmaları oluşturulmayacaktır.

```text
lib/
    core/
        extensions/
            context_extensions.dart
            date_extensions.dart
        constants/
            app_colors.dart
            mock_cars.dart
        theme/
            app_theme.dart
            theme_controller.dart

    features/
        car_listing/                  # İlanları Listeleme ve Arama
            controller/
                car_listing_controller.dart
            models/
                car_model.dart
                rental_period_type.dart # enum RentalPeriodType { daily, weekly, monthly }
            view/
                car_listing_view.dart
            widget/
                car_card_widget.dart   # 16:9 sabit resim boyutlu ilan kartı
                period_filter_chips.dart

        car_detail/                   # İlan İnceleme ve Rezervasyon
            controller/
                car_detail_controller.dart
            view/
                car_detail_view.dart
            widget/
                car_image_banner.dart  # 260px sabit görsel alanı
                fuel_gauge_widget.dart # Benzin/batarya grafik göstergesi
                price_breakdown_card.dart

        create_listing/               # Yeni Araç İlanı Verme Formu
            controller/
                create_listing_controller.dart
            view/
                create_listing_view.dart
            widget/
                image_upload_placeholder.dart # Sabit boyutlu resim seçici
                date_range_picker_widget.dart # Tarih seçim alanı (günlük/haftalık/aylık)
                fuel_input_slider.dart

        smart_key_assistant/          # Fark Yaratan Özellik: Dijital Kilit & Asistan
            controller/
                smart_key_controller.dart
            models/
                assistant_message_model.dart
            view/
                smart_key_sheet.dart
            widget/
                quick_assistant_dialog.dart
                key_action_button.dart

    main.dart
```

### `main.dart` Sorumluluğu
Sadece uygulama başlatma (`runApp`), `ThemeController` dinleme ve ana navigasyon barını bağlama görevini üstlenir; içinde karmaşık iş mantığı yer almaz.

---

## 3. Kırmızı Çizgiler ve Kod Kalite Standartları

1. **State Yönetim Standartları:**
   - Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
   - Durum yönetimi için `ValueNotifier` ve `ValueListenableBuilder` kullanılacaktır.
   - Sadece yerel arayüz durumunu yöneten (örneğin slider kaydırma, metin alanı kontrolü, sekme animasyonu) `StatefulWidget` kabul edilir.

2. **UI ve Görsel Boyut Kuralları:**
   - Statik tüm widget'larda `const` kullanımı ZORUNLUDUR.
   - **Görsel Boyut Standardı:** İlan kartlarındaki araç resmi alanı mutlaka `height: 180` (veya `AspectRatio 16/9`), detay sayfasındaki ise `height: 260` olarak sabitlenecek; taşma (`RenderFlex overflow`) kesinlikle engellenecektir.
   - Renk ve metin stilleri kesinlikle `app_colors.dart` ve `app_theme.dart` üzerinden okunacaktır; sayfa içine sabit `Color(0xFF...)` yazmak yasaktır.
   - 40 satırı geçen `build` metotları yasaktır; alt bileşenler `widget/` altına taşınacaktır.

3. **Yasaklı Paketler ve Sabit Veri Esası:**
   - Onay almadan harici ağır state paketleri (`Bloc`, `Riverpod`, `GetX` vb.) EKLENMEYECEKTİR.
   - Yeni ilan eklendiğinde veya ilanlar listelendiğinde veriler `core/constants/mock_cars.dart` üzerindeki bellek içi (in-memory) listeye tip güvenli olarak (`CarModel`) eklenecektir.

---

## 4. Geliştirme, Analiz ve Test Komutları

Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır:

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
  ```bash
  flutter analyze
  ```

* **Birim ve widget testleri:**
  ```bash
  flutter test
  ```

* **Projeyi çalıştırma:**
  ```bash
  flutter run
  ```

---

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe, teknik terimlerin özünü bozmadan, net ve doğrudan olacaktır.
- **Değişiklik Sunumları:** 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; yalnızca hedef satırları ve diff yapısını göster.
- **Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
- **Doğrulama:** Kod yazdıktan sonra kullanıcıya *"Şimdi `flutter analyze` ile kontrol edebilirsin"* şeklinde doğrulama yönergeleri ver.

---

## 6. Çekirdek Özellikler (Core Features)

### 1. İlanları Listeleme ve İnceleme (`car_listing`)
- **İlan Kartı (`car_card_widget.dart`):**
  - **Sabit Görsel Alanı:** 16:9 oranında sabit çerçeve. Resim yoksa şık araç ikonu/silüeti ile placeholder gösterilir.
  - **Yakıt/Şarj Göstergesi:** İlan kartı üzerinde anlık benzin seviyesi (örn. `%75 Depo`) veya batarya durumu renkli rozet (badge) olarak yer alır.
  - **Kiralama Periyodu & Fiyat Etiketi:** Kullanıcı filtrede Günlük, Haftalık veya Aylık seçimine göre aracın birim fiyatını dinamik görür (Örn: *1.850 ₺ / Gün* veya *11.500 ₺ / Hafta*).
  - Vites tipi (Otomatik/Manuel), koltuk sayısı ve lokasyon mesafesi kart üzerinde rozetlerle listelenir.

### 2. İlan Verme Formu (`create_listing`)
Kullanıcı kendi aracını sisteme eklemek istediğinde zengin detaylarla ilan oluşturur:
- **Sabit Boyutlu Fotoğraf Çerçevesi:** 140px yüksekliğinde, kullanıcıya fotoğraf yükleme hissi veren estetik önizleme alanı.
- **Araç Temel Bilgileri:** Marka, Model, Üretim Yılı, Plaka, Vites Türü (Otomatik / Manuel).
- **Benzin / Yakıt Seviyesi:** Kaydırılabilir slider veya sayısal seçimle aracın teslim anındaki benzin seviyesi (`%0 - %100`).
- **Kiralama Süresi ve Tarih Seçimi:**
  - Kiralama periyodu opsiyonları: **Günlük**, **Haftalık**, **Aylık** fiyat giriş alanları.
  - **Tarih Aralığı Seçicisi (`DateTimeRange`):** Aracın hangi tarihler arasında kiralanmaya uygun olduğunun takvimden seçilmesi.
- **Kaydet ve Yayınla:** `ValueNotifier` üzerinden doğrulanıp anında ilan listesine eklenir.

### 3. İlan Detay Ekranı (`car_detail`)
- **Detay Görsel Banner'ı:** 260px sabit yüksekliğinde kapak alanı.
- **Kapsamlı Araç Özellikleri:** Benzin durumu göstergesi, kasko/sigorta bilgisi, teslim alma adresi.
- **Tarih ve Süre Hesaplayıcı:** Kullanıcı kiralayacağı gün/hafta sayısını seçtiğinde toplam tutarı anında hesaplayan dinamik özet kartı (`price_breakdown_card.dart`).
- **Rezervasyon Yap & Dijital Anahtarı Al Butonu:** Rezervasyon tamamlandığında doğrudan dijital kilit modülüne yönlendirir.

### 4. Fark Yaratan Özellik: Akıllı Dijital Anahtar & Canlı Yol Asistanı (`smart_key_assistant`)
- **Dijital Kokpit Anahtarı:** Araç kiralandığında fiziksel anahtara gerek kalmadan **Kapıları Aç/Kilitle**, **Farları Yak (Otoparkta Bul)** ve **Bagajı Aç** fonksiyonları çalışır.
- **Sürüş Sayacı & Özet Dialog:** Canlı sürüş sayacı çalışır; sürüş bittiğinde toplam süre ve yakıt tüketimini özetleyen şık bir **Uyarı Pop-up'ı (Dialog)** ekrana gelir.
- **Yol Asistanı Diyaloğu:** *"Yakıt kapağı nasıl açılır?"*, *"Haftalık kiralama uzatılabilir mi?"*, *"Park yasağı var mı?"* gibi sorulara hazır yanıt veren interaktif balon sohbeti.

---

## 7. Uygulama Logosu Tasarımı ve Entegrasyonu

- **TakeGO**'nun hız, paylaşım ve özgürlük temasını yansıtan modern mobilite logosu tasarlanacak; üst barda ve uygulama açılışında yer alacaktır.

---

## 8. Tema Desteği: Karanlık ve Aydınlık Mod Standartları

Uygulama hem gece sürüş kokpiti (**OLED Cockpit Dark**) hem de aydınlık gündüz (**Clean Mobility Light**) paletlerini destekleyecektir:
1. **Mimari:** Harici ağır state yönetim paketleri kullanılmayacaktır; yerel `ChangeNotifier` veya `ValueNotifier<ThemeMode>` tabanlı `ThemeController` ile tema durumu yönetilecektir.
2. **Kullanıcı Etkileşimi:** `AppBar` üzerinde kullanıcı tek dokunuşla (Güneş / Ay ikonu) anında Gece ve Gündüz modu arasında geçiş yapabilecektir.
3. **UI Uyum:** Kartlar, sabit resim placeholder'ları ve butonlar doğrudan sabit koyu/açık renklere kilitlenmeyecek; `Theme.of(context)` ve `colorScheme` üzerinden her iki moda da kusursuz uyum sağlayacaktır.
4. **Kalite:** 0 uyarı/hata (`flutter analyze`) ve tüm temalı testlerin (`flutter test`) eksiksiz geçmesi zorunludur.

---

## 9. Ajan Yetenekleri ve Yardımcı Araçlar

Projede geliştirme yapacak ajanlar ve geliştiriciler, `.agents/skills/` dizini altındaki standartları kullanmalıdır:
- **Otomatik İskelet Betiği:** generate\_feature.sh
- **Durum Akış Referansı:** state\_flow.md
- **Altın Standart Referans Kod:** sample\_screen.dart