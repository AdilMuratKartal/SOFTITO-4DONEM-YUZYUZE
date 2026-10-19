#Fitness su takip uygulaması
bu döküman Flutter projesinde geliştirme yapacak olan Ajan(antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir klavuzdurçProjede üretilen her kod satırı burdaki kurallara UYMAK ZORUNDADIR.


##1.Proje Özeti ve Teknolojiler
- **Uygulama adı:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması)
- **Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformları
- **Flutter SDK:** 3.29.0
- **Dart SDK:** 3.0.0 
- **Tasarım dili:** Material 3, Koyu ve Aydınlık Tema Desteği (Dark Obsidian & Neon Gece Paleti / Clean Fresh Cyan & Lime Gündüz Paleti)


---

# Mimari Yapı : Özellik bazlı
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
core/
extension'lar
        constants/app_colors.dart
        theme/app_theme.dart

    features/
        water_tracker/
            controller/
            models/
            view/
            widget/
        workout/
            controller/
            models/
            view/
            widget/
    
     main.dart
```

### sadece uygulama başlatma ve tema bölümleri

## 3 Kırmızı çizgiler kod kalite standartları
1 - **State Yönetim Standartları:**
    Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
    Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans Kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyasına yazılacaktır
Büyük build methodları yasaktır 40 satırı geçen build metodları özel widgetlara yazılacaktır.

3 - **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4 Geliştirme analiz ve test komutları
Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi(0 uyarı ve 0 hata şart):**
``bash
flutter analyze 
````

* **Birim ve widget testleri:**
```bash 
flutter test
`````
* **Projeyi çalıştırma:**
```bash
flutter run
````

## 5 Ajanın çıktı ve yanıt verme standartları

**Açıklamalar** Türkçe teknik terimlerin özünü bozmadan ve doğrudan olacaktır.
** Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.
**Dosya yolları** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
**Doğrulama** Kod yazdıktan sonra kullanıcı "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.

# 6 Feature Ekleme 
Su takibi sayfasında bir zamanlayıcı ekle, süreyi kullanıcı belirlesin, süre bitince uyarı pop up çıksın

# 7 Uygulama Logosu Tasarımı ve Entegrasyonu
Uygulama amacı, vizyonu öne alınıp, buna uygun tasarım tasarlayıp, uygulamaya eklenecek

# 8 Tema Desteği: Karanlık ve Aydınlık Mod Standartları
Uygulama hem gece spor salonu (Dark Obsidian & Neon) hem de aydınlık (Clean Fresh Cyan & Energizing Lime) paletlerini destekleyecektir.
1. **Mimari:** Harici ağır state yönetim paketleri kullanılmayacaktır; yerel `ChangeNotifier` veya `ValueNotifier<ThemeMode>` tabanlı `ThemeController` ile tema durumu yönetilecektir.
2. **Kullanıcı Etkileşimi:** AppBar üzerinde kullanıcı tek dokunuşla (Güneş / Ay ikonu) anında mod geçişi yapabilecektir.
3. **UI Uyum:** Renkler ve kartlar doğrudan sabit koyu renklere kilitlenmeyecek; `Theme.of(context)` ve `colorScheme` üzerinden her iki temaya da kusursuz uyum sağlayacaktır.
4. **Kalite:** 0 uyarı/hata (`flutter analyze`) ve tüm temalı testlerin (`flutter test`) eksiksiz geçmesi zorunludur.

# 9 Ajan Yetenekleri ve Yardımcı Araçlar
Projede geliştirme yapacak ajanlar ve geliştiriciler, `.agents/skills/` dizini altındaki standartları kullanmalıdır:
- **Otomatik İskelet Betiği:** [generate_feature.sh](file:///Users/d1-16/Desktop/19-EKIM/2-/.agents/skills/script/generate_feature.sh)
- **Durum Akış Referansı:** [state_flow.md](file:///Users/d1-16/Desktop/19-EKIM/2-/.agents/skills/references/state_flow.md)
- **Altın Standart Referans Kod:** [sample_screen.dart](file:///Users/d1-16/Desktop/19-EKIM/2-/.agents/skills/examples/sample_screen.dart)