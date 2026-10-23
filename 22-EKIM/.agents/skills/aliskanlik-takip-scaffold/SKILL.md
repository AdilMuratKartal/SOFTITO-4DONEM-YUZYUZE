---
name: aliskanlik-takip-scaffold
description: Alışkanlık takip uygulamasında yeni modül/özellik (feature) iskeleti oluşturma, ValueNotifier durum akışını bağlama, alışkanlık ekleme/silme ve 4 temel kategori + dinamik kategori standartlarını uygulama kılavuzu.
---

# Alışkanlık Takip Scaffold & Geliştirme Becerisi (SKILL.md)

Bu beceri (skill); Flutter ile geliştirilen mikro-alışkanlık ve kişisel gelişim takip uygulamasında yeni bir özellik (feature), ekran (view), durum yöneticisi (controller) veya bileşen (widget) inşa ederken projenin mimari standartlarına %100 uyum sağlamak için kullanılır.

---

## 1. Ne Zaman Kullanılmalı?

- Uygulamaya yeni bir sayfa (Örn: `Sayfa 6 - Alışkanlık Ekle/Düzenle/Sil Modalı`) ekleneceği zaman.
- Alışkanlık oluşturma, silme, haftalık gün kontrolü (`1..7`), zaman aralığı (`09:45 - 15:36`) veya hatırlatıcı (`notification`) akışları yazılırken.
- 4 temel kategori (**Spor**, **Sağlık**, **Zihin**, **Müzik**) ve kullanıcı tanımlı dinamik kategori yönetimi entegre edilirken.
- Projede Feature-First (`controllers`, `models`, `views`, `widgets`) modül iskeleti açılırken.

---

## 2. Dahili Kaynaklar ve Yardımcı Araçlar

Bu beceri dizini altında 3 kritik referans ve yardımcı betik bulunmaktadır:

1. **Otomatik İskelet Betiği:** [generate_feature.sh](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/22-EKIM/.agents/skills/aliskanlik-takip-scaffold/script/generate_feature.sh)
   - Yeni bir modül için `controller`, `model`, `view` dosyalarını saniyeler içinde mimariye uygun olarak otomatik üretir.
   - Çalıştırma:
     ```bash
     bash .agents/skills/aliskanlik-takip-scaffold/script/generate_feature.sh <feature_name>
     ```
2. **Durum Akış Referansı:** [state_flow.md](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/22-EKIM/.agents/skills/aliskanlik-takip-scaffold/references/state_flow.md)
   - `ValueNotifier` ve `ValueListenableBuilder` yaşam döngüsü kuralları, ekleme/silme akışları ve kategori durum diyagramları.
3. **Altın Standart Referans Kod:** [sample_screen.dart](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/22-EKIM/.agents/skills/aliskanlik-takip-scaffold/examples/sample_screen.dart)
   - Sıfır hata ile çalışan, `Dismissible` silme, `ChoiceChip` kategori filtreleri ve zaman aralığı göstergelerini barındıran örnek ekran.

---

## 3. Temel Mimari ve Tasarım Kuralları

### 3.1. Durum Yönetimi (State Management)
- Ekran genelini baştan çizen `setState()` yerine daima izole çizim sağlayan `ValueNotifier<T>` ve `ValueListenableBuilder<T>` kullanılmalıdır.
- Controller sınıfları `initState()` içinde başlatılmalı, `dispose()` içinde mutlaka `.dispose()` edilmelidir.

### 3.2. Alışkanlık Ekleme Standartları
- **Alışkanlık İsmi:** `TextFormField` ile doğrulamalı (en az 3 karakter).
- **İkon Seçimi:** `assets/icons/` dizini altındaki SVG ikon setinden görsel seçim.
- **Haftalık Günler:** 7 gün (1..7) arasından çoklu seçim (`selectedDays`). Sadece seçilen günlerde ana ekranda listelenir.
- **Zaman Aralığı:** `TimeOfDay` formatında başlangıç ve bitiş saatleri (Örn: `09:45 - 15:36`).
- **Hatırlatıcı:** Açık/kapalı bildirim anahtarı (`hasReminder`).

### 3.3. Alışkanlık Silme Standartları
- Kart üzerinde sola kaydırma (`Dismissible(direction: DismissDirection.endToStart)`) desteği olmalıdır.
- `confirmDismiss` içinde mutlaka `AlertDialog` ile kullanıcıdan silme onayı istenmelidir.
- Düzenleme modalında kırmızı renkli "Alışkanlığı Kalıcı Olarak Sil" butonu bulunmalıdır.

### 3.4. Kategori Kuralları
- **4 Temel Kategori:**
  - 🏃 Spor: `#10B981`
  - 💧 Sağlık: `#0EA5E9`
  - 🧘 Zihin: `#8B5CF6`
  - 🎸 Müzik: `#EC4899`
- Kullanıcı dilediğinde `+ Kategori Ekle` butonuyla yeni kategori tanımlayabilmelidir.

### 3.5. Renk ve Opaklık Standartları (Flutter Material 3)
- Deprecated olan `color.withOpacity(0.2)` yerine **`color.withValues(alpha: 0.2)`** kullanılmalıdır.
- Sabit widget ve renk tanımlarında `const` anahtar kelimesi eksiksiz kullanılmalıdır.

---

## 4. Geliştirme Sonrası Doğrulama

Herhangi bir kod yazıldıktan veya değiştirildikten sonra mutlaka aşağıdaki komutlar çalıştırılmalı ve 0 hata / 0 uyarı teyit edilmelidir:

```bash
flutter analyze
flutter test
```
