# 🥚 Yumurta Maskot 3D Model & Flutter Entegrasyon Kılavuzu

Bu proje, klasörünüzdeki maskot referans görsellerine (**Mutlu, Üzgün, Kızgın, Canı Sıkılmış, Depresif, Yaratıcı** durumları ve **Koşma/Zıplama/Boşta** animasyonları) birebir sadık kalınarak oluşturulmuş **3 Boyutlu Maskot Modeli** ve **Flutter Cross-Platform (iOS, Android, macOS, Windows, Web)** altyapısını içerir.

---

## 📂 Oluşturulan Dosyalar

1. **[egg_mascot_studio.html](file:///Users/d1-16/Desktop/YUMURTA-MASKO/egg_mascot_studio.html)**:
   - Tarayıcınızda çalışan interaktif 3D stüdyo.
   - **Tüm Duygu Durumları:** Mutlu, Üzgün, Kızgın, Canı Sıkılmış, Depresif, Yaratıcı.
   - **Animasyonlar:** Boşta nefes alma (Idle), Koşma/Yürüme (Run cycle), Sevinç Zıplaması (Jump), Dans (Dance).
   - **360° Kamera & Kontroller:** Ön, Yan, Arka, 3/4 İzometrik açılar.
   - **Tek Tıkla GLB İndirme:** Üzerinde çalıştığınız duygu durumuyla beraber tek tıkla `.glb` formatında dışa aktarır.

2. **[yumurta_maskot.glb](file:///Users/d1-16/Desktop/YUMURTA-MASKO/yumurta_maskot.glb)**:
   - Standart **glTF 2.0 Binary (.glb)** 3D model dosyası.
   - Yumurta gövde, boynuzlar, kollar, bacaklar, sarı yüz ve uçan kalp aksesuarı PBR kaplamalarıyla paketlenmiştir.
   - Flutter, Blender, Unity, SceneKit, Unreal Engine vb. tüm 3D motorlarında doğrudan açılır.

3. **[generate_glb.py](file:///Users/d1-16/Desktop/YUMURTA-MASKO/generate_glb.py)**:
   - Bağımsız, harici kütüphane gerektirmeyen (Pure Python) GLB model üretici.

4. **[flutter_mascot_widget.dart](file:///Users/d1-16/Desktop/YUMURTA-MASKO/flutter_mascot_widget.dart)**:
   - Flutter projenize doğrudan kopyalayabileceğiniz hazır 3D widget.

---

## 🚀 1. İnteraktif 3D Modeli Hemen Tarayıcınızda İnceleyin

Mac Terminalinizde şu komutu çalıştırın (veya `egg_mascot_studio.html` dosyasına çift tıklayın):

```bash
open egg_mascot_studio.html
```

Açılan ekranda:
- Mouse ile maskotu **360 derece çevirebilir**, yakınlaştırıp uzaklaştırabilirsiniz.
- Sağdaki kartlardan **Mutlu, Üzgün, Kızgın, Canı Sıkılmış, Depresif, Yaratıcı** durumlarına tıkladığınızda yüz ifadesi, duruşu ve aksesuarları (uçan kalp, yağmur bulutu, ampul) anında değişir.
- **Koşma** ve **Zıplama** düğmelerine basarak görsellerdeki hareket döngülerini canlı izleyebilirsiniz.
- Üstteki **".GLB Olarak İndir"** butonuna basarak istediğiniz duygunun 3D dosyasını indirebilirsiniz.

---

## 📱 2. Flutter'da Kullanım (iOS, Android, macOS, Windows, Web)

Flutter'da `.glb` formatındaki 3D modelleri çalıştırmanın en kararlı ve performanslı yolu **`model_viewer_plus`** paketidir.

### Adım 1: `pubspec.yaml`
```yaml
dependencies:
  flutter:
    sdk: flutter
  model_viewer_plus: ^1.7.0

flutter:
  assets:
    - assets/models/yumurta_maskot.glb
```

### Adım 2: Platform İzinleri & Ayarları

- **Android (`android/app/src/main/AndroidManifest.xml`)**:
  `<manifest>` etiketinin içine şu satırı ekleyin:
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  ```
  `application` etiketine:
  ```xml
  android:usesCleartextTraffic="true"
  ```

- **iOS (`ios/Runner/Info.plist`)**:
  `<dict>` içine ekleyin:
  ```xml
  <key>io.flutter.embedded_views_preview</key>
  <true/>
  ```

- **macOS (`macos/Runner/DebugProfile.entitlements` & `Release.entitlements`)**:
  ```xml
  <key>com.apple.security.network.client</key>
  <true/>
  ```

### Adım 3: Widget'ı Çağırma

```dart
import 'package:flutter/material.dart';
import 'flutter_mascot_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7E5DB),
      appBar: AppBar(title: const Text('Bugün Nasıl Hissediyorsun?')),
      body: Center(
        child: YumurtaMaskot3DView(
          initialDuygu: MaskotDuygu.mutlu,
          height: 380,
          autoRotate: true,
        ),
      ),
    );
  }
}
```

---

## 🎨 3. Tasarım ve Karakter Detayları

Görsellerinizdeki referanslara göre uygulanan detaylar:
- **Ana Form:** Tabanı geniş, tepeye doğru incelen yumuşak pürüzsüz beyaz yumurta gövdesi (Mat seramik/vinil PBR kaplama).
- **Boynuzlar:** Başın üzerinde hafif dışa ve geriye kıvrılan iki adet sevimli boynuz.
- **Yüz (Yumurta Sarısı):** Gövdenin önündeki yumuşak oyuğa yerleşmiş parlak sıcak sarı kubbe yüz.
- **İfadeler & Duygular:**
  - **Mutlu:** Kalp şeklinde çikolata gözler, tebessüm, pembe yanaklar ve başın üzerinde nabız gibi atan 3D uçan kalp.
  - **Üzgün:** Düşük kaşlar, süzülen gözyaşı damlası, yanağa dokunan el duruşu.
  - **Kızgın:** Keskin çatık kaşlar, kabarık duruş, kızarık yanaklar, sinirli ayak vuruşları.
  - **Canı Sıkılmış:** Düz `- _ -` göz çizgileri, yana yaslanmış baş duruşu.
  - **Depresif:** Yere boylu boyunca uzanmış yatış duruşu (karttaki gibi), başın üzerinde yağmur damlatan fırtına bulutu.
  - **Yaratıcı:** Yıldız gibi parıldayan gözler, sevinçli gülüş, başın üzerinde ışık saçan 3D fikir ampulü.
- **Hareketler:** Idle (nefes alma), Koşma (bacak-kol sallantısı ve gövde sekmesi), Zıplama (sevinçle havalanıp kollarını açma), Dans.

