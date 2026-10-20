---
name: takego-feature-scaffold
description: TakeGO araç kiralama ve paylaşım projesinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini, sabit resim boyutlu ilan/detay/form UI ayrımını, dijital anahtar asistanını ve birim test iskeletini standartlara uygun olarak üretir.
---

# TakeGO Feature Scaffold (Modüler Ekran ve Özellik İskeleti)

Bu yetenek, **TakeGO** projesinde yeni bir ekran ya da işlev modülü (`car_listing`, `car_detail`, `create_listing`, `smart_key_assistant`) açarken Clean UI, sabit görsel boyutları ve reaktif `ValueNotifier` state kurallarına tam uyulmasını garanti altına alır.

---

## Temel Kurallar

1. **Asla Tek Dosyada Toplama:**
   UI (`_view.dart`), State Controller (`_controller.dart`), Veri Modeli (`_model.dart`) ve alt bileşen (`_widget.dart`) dosyaları ayrı ayrı açılmalıdır.
2. **`setState` Yönetimi:**
   Basit ve reaktif durumlar (kiralama periyodu seçimi, ilan filtreleme, benzin seviyesi, dijital kapı kilidi, sürüş sayacı) için `ValueNotifier` ve `ValueListenableBuilder` kullanılmalıdır. Doğrudan devasa `StatefulWidget` yazarak işi karmaşıklaştırma.
3. **Sabit Resim Boyutu (Fix Image Size) Zorunluluğu:**
   Projede gerçek araç fotoğrafları olmadığında dahi arayüzün kaymaması ve `RenderFlex overflow` hatası vermemesi için görsel alanları sabitlenmelidir:
   - **İlan Kartı (`car_card_widget.dart`):** `AspectRatio(aspectRatio: 16 / 9)` veya `height: 180.0`
   - **İlan Detay Ekranı (`car_detail_view.dart`):** `height: 260.0`, `width: double.infinity`
   - **İlan Verme Fotoğraf Kutusu (`create_listing_view.dart`):** `height: 140.0`
4. **Genel Kod Kalite Zorunluluğu:**
   - Mümkün olan tüm widget'larda `const` anahtar kelimesi zorunludur.
   - Renkler asla sabit (`Color(0xFF...)`) yazılmaz; `Theme.of(context).colorScheme` üzerinden okunur.
   - 40 satırı geçen `build` metotları `widget/` klasörü altındaki modüler bileşenlere bölünür.

---

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen modül adını (örn: `car_listing`, `create_listing`, `car_detail`, `smart_key_assistant`) `lib/features/<feature_name>` altına kur:

```text
lib/features/<feature_name>/
    controller/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    view/
        <feature_name>_view.dart
    widget/
        <feature_name>_card.dart
```

---

### Adım 2: Controller Dosyasını Yaz
`controller/<feature_name>_controller.dart` içinde iş mantığını ve `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/foundation.dart';
import '../models/car_model.dart';

class CarListingController {
  // Seçili kiralama periyodu (Günlük / Haftalık / Aylık)
  final ValueNotifier<RentalPeriodType> selectedPeriod =
      ValueNotifier<RentalPeriodType>(RentalPeriodType.daily);

  // Bellekteki aktif araç ilanları listesi
  final ValueNotifier<List<CarModel>> carsNotifier =
      ValueNotifier<List<CarModel>>([]);

  // Dijital Anahtar: Kapı kilidi ve sürüş durumu
  final ValueNotifier<bool> isCarUnlocked = ValueNotifier<bool>(false);
  final ValueNotifier<int> activeDriveSeconds = ValueNotifier<int>(0);

  void changePeriod(RentalPeriodType period) {
    selectedPeriod.value = period;
  }

  void addNewListing(CarModel newCar) {
    carsNotifier.value = [newCar, ...carsNotifier.value];
  }

  void toggleCarLock() {
    isCarUnlocked.value = !isCarUnlocked.value;
  }

  void dispose() {
    selectedPeriod.dispose();
    carsNotifier.dispose();
    isCarUnlocked.dispose();
    activeDriveSeconds.dispose();
  }
}
```

---

### Adım 3: Model Dosyasını Oluşturma
`models/car_model.dart` dosyasını; benzin durumu (`fuelPercent`), kiralama periyot fiyatları (`dailyPrice`, `weeklyPrice`, `monthlyPrice`), müsaitlik tarih aralığı (`availableFrom`, `availableTo`) ve `copyWith`, `fromJson`, `toJson` metotlarını içerecek şekilde `immutable` olarak tanımla:

```dart
import 'package:flutter/foundation.dart';

enum RentalPeriodType {
  daily,
  weekly,
  monthly;

  String get label {
    switch (this) {
      case RentalPeriodType.daily:
        return 'Günlük';
      case RentalPeriodType.weekly:
        return 'Haftalık';
      case RentalPeriodType.monthly:
        return 'Aylık';
    }
  }
}

@immutable
class CarModel {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final int fuelPercent; // %0 - %100 benzin/batarya durumu
  final bool isElectric;
  final String transmission; // Otomatik / Manuel
  final double dailyPrice;
  final double weeklyPrice;
  final double monthlyPrice;
  final DateTime availableFrom;
  final DateTime availableTo;
  final String location;
  final String? imageUrl;

  const CarModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.fuelPercent,
    required this.isElectric,
    required this.transmission,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.availableFrom,
    required this.availableTo,
    required this.location,
    this.imageUrl,
  });

  CarModel copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    String? plate,
    int? fuelPercent,
    bool? isElectric,
    String? transmission,
    double? dailyPrice,
    double? weeklyPrice,
    double? monthlyPrice,
    DateTime? availableFrom,
    DateTime? availableTo,
    String? location,
    String? imageUrl,
  }) {
    return CarModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      fuelPercent: fuelPercent ?? this.fuelPercent,
      isElectric: isElectric ?? this.isElectric,
      transmission: transmission ?? this.transmission,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      weeklyPrice: weeklyPrice ?? this.weeklyPrice,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 2024,
      plate: json['plate'] ?? '',
      fuelPercent: json['fuelPercent'] ?? 100,
      isElectric: json['isElectric'] ?? false,
      transmission: json['transmission'] ?? 'Otomatik',
      dailyPrice: (json['dailyPrice'] as num?)?.toDouble() ?? 0.0,
      weeklyPrice: (json['weeklyPrice'] as num?)?.toDouble() ?? 0.0,
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble() ?? 0.0,
      availableFrom: json['availableFrom'] != null
          ? DateTime.parse(json['availableFrom'])
          : DateTime.now(),
      availableTo: json['availableTo'] != null
          ? DateTime.parse(json['availableTo'])
          : DateTime.now().add(const Duration(days: 30)),
      location: json['location'] ?? 'İstanbul',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'plate': plate,
      'fuelPercent': fuelPercent,
      'isElectric': isElectric,
      'transmission': transmission,
      'dailyPrice': dailyPrice,
      'weeklyPrice': weeklyPrice,
      'monthlyPrice': monthlyPrice,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
```

---

### Adım 4: View Dosyasını Oluşturma
`view/<feature_name>_view.dart` dosyasında `StatelessWidget` ve `ValueListenableBuilder` kullanarak UI katmanını oluştur:

```dart
import 'package:flutter/material.dart';
import '../controller/car_listing_controller.dart';
import '../models/car_model.dart';
import '../widget/car_card_widget.dart';

class CarListingView extends StatelessWidget {
  final CarListingController controller;

  const CarListingView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TakeGO İlanlar'),
      ),
      body: Column(
        children: [
          // Periyot Seçici (Günlük / Haftalık / Aylık)
          ValueListenableBuilder<RentalPeriodType>(
            valueListenable: controller.selectedPeriod,
            builder: (context, currentPeriod, _) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<RentalPeriodType>(
                  segments: const [
                    ButtonSegment(value: RentalPeriodType.daily, label: Text('Günlük')),
                    ButtonSegment(value: RentalPeriodType.weekly, label: Text('Haftalık')),
                    ButtonSegment(value: RentalPeriodType.monthly, label: Text('Aylık')),
                  ],
                  selected: {currentPeriod},
                  onSelectionChanged: (set) => controller.changePeriod(set.first),
                ),
              );
            },
          ),

          // Araç İlan Listesi
          Expanded(
            child: ValueListenableBuilder<List<CarModel>>(
              valueListenable: controller.carsNotifier,
              builder: (context, cars, _) {
                return ValueListenableBuilder<RentalPeriodType>(
                  valueListenable: controller.selectedPeriod,
                  builder: (context, period, _) {
                    return ListView.builder(
                      itemCount: cars.length,
                      itemBuilder: (context, index) {
                        return CarCardWidget(
                          car: cars[index],
                          selectedPeriod: period,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### Adım 5: Sabit Resim Boyutlu Widget Dosyasını Oluşturma
`widget/car_card_widget.dart` dosyasında `AspectRatio(16 / 9)` sabit görsel alanı, benzin durumu ve tarih aralığını gösteren `StatelessWidget` oluştur:

```dart
import 'package:flutter/material.dart';
import '../models/car_model.dart';

class CarCardWidget extends StatelessWidget {
  final CarModel car;
  final RentalPeriodType selectedPeriod;
  final VoidCallback? onTap;

  const CarCardWidget({
    super.key,
    required this.car,
    this.selectedPeriod = RentalPeriodType.daily,
    this.onTap,
  });

  double get _activePrice {
    switch (selectedPeriod) {
      case RentalPeriodType.daily:
        return car.dailyPrice;
      case RentalPeriodType.weekly:
        return car.weeklyPrice;
      case RentalPeriodType.monthly:
        return car.monthlyPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SABİT GÖRSEL ALANI (16:9 Oran - Resim yoksa bile boyut bozulmaz)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: colors.surfaceContainerHighest,
                child: const Center(
                  child: Icon(Icons.directions_car_filled_outlined, size: 48),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${car.brand} ${car.model}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_activePrice.toStringAsFixed(0)} ₺ / ${selectedPeriod.label}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.local_gas_station, size: 16, color: colors.secondary),
                      const SizedBox(width: 4),
                      Text('Benzin: %${car.fuelPercent}'),
                      const Spacer(),
                      const Icon(Icons.date_range, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${car.availableFrom.day}.${car.availableFrom.month} - '
                        '${car.availableTo.day}.${car.availableTo.month}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Adım 6: Clean Architecture Kurallarına Uyum
- **Separation of Concerns:** Her dosyanın tek bir sorumluluğu olduğundan emin ol (Controller: durum ve hesaplama, Model: veri, View: sayfa düzeni, Widget: yeniden kullanılabilir küçük parçalar).
- **Fixed Image Containers:** İlan kartı (`16:9`), ilan detayı (`260px`) ve ilan verme formu (`140px`) görsel kutularının sabit yüksekliğini asla esnek/belirsiz bırakma.
- **Testability:** Her katman için birim ve widget testleri yazılabilir olmalıdır.

---

## Kullanım Örnekleri

### Örnek 1: İlan Verme ve Tarih Aralığı Seçimi (`DateTimeRangePicker`)
İlan verme ekranında kullanıcıdan günlük/haftalık/aylık fiyatların yanı sıra müsaitlik tarih aralığı alınırken:
```dart
Future<void> pickAvailabilityDates(
  BuildContext context,
  ValueNotifier<DateTimeRange> dateRangeNotifier,
) async {
  final picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    initialDateRange: dateRangeNotifier.value,
  );
  if (picked != null) {
    dateRangeNotifier.value = picked;
  }
}
```

### Örnek 2: Fark Yaratan Özellik — Dijital Anahtar ve Sürüş Sonu Uyarı Pop-up'ı
Kullanıcı sürüşü tamamladığında çalışan özet diyalog:
```dart
void showDriveSummaryDialog(BuildContext context, String carName, int minutes, double totalCost) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Sürüş Tamamlandı'),
      content: Text('$carName ile $minutes dakikalık sürüşünüz sona erdi.\nToplam Tutar: ${totalCost.toStringAsFixed(2)} ₺'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Onayla ve Kilitle'),
        ),
      ],
    ),
  );
}
```

---

## Ekstra İpuçları
- **Sabit Veri Yönetimi:** Başlangıç araç listesini `lib/core/constants/mock_cars.dart` içerisinde `const List<CarModel>` olarak tut ve yeni ilan eklendiğinde `CarListingController.addNewListing` ile listeyi reaktif güncelle.
- **Tema Uyumu:** Tek tema (`Cyber Drive`) üzerinde Gece ve Gündüz modları `ValueNotifier<ThemeMode>` ile kontrol edilir; tüm kartlar `Theme.of(context).colorScheme` üzerinden renk alır.
- **Testing:** `flutter analyze` (0 hata / 0 uyarı) ve `flutter test` komutlarını her modül sonrasında çalıştır.

---

## SSS (Sıkça Sorulan Sorular)

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
- **Cevap:** TakeGO projesinde yeni bir ekran veya işlev modülü (İlan Listesi, İlan Verme Formu, İlan Detay Sayfası, Dijital Anahtar & Yol Asistanı) oluştururken bu yeteneği kullanmalısın.

### Soru: Bu yeteneği hangi durumlarda kullanmamalıyım?
- **Cevap:** Mevcut bir ekranda küçük bir metin/renk düzeltmesi yaparken veya tek satırlık bir hatayı giderirken sıfırdan klasör açmak için bu yeteneği kullanmamalısın.

---

## 📂 Yardımcı Kaynaklar, Referanslar ve Betikler

### 1. Betikler (`script/` & `scripts/`)
- [generate_feature.sh](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/20-EKIM-ODEV/.agents/skills/takego-scaffold/script/generate_feature.sh): Bash ortamları için tam otomatik feature iskelet ve test oluşturucu.
- [generate_feature.ps1](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/20-EKIM-ODEV/.agents/skills/takego-scaffold/script/generate_feature.ps1): Windows PowerShell ortamları için yerel otomatik feature iskelet ve test oluşturucu.

### 2. Mimari Referans Belgeleri (`references/`)
- [state_flow.md](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/20-EKIM-ODEV/.agents/skills/takego-scaffold/references/state_flow.md): Reaktif durum akışı, Mermaid mimari diyagramları, `ValueNotifier` yaşam döngüsü ve anti-pattern rehberi.
- [theme_spec.md](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/20-EKIM-ODEV/.agents/skills/takego-scaffold/references/theme_spec.md): Cyber Drive Otomotiv Tasarım Sistemi, Clean Mobility Light / OLED Cockpit Dark renk kodları ve sabit resim boyut standartları.

### 3. Altın Standart Örnek Kodlar (`examples/`)
- [sample_screen.dart](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/20-EKIM-ODEV/.agents/skills/takego-scaffold/examples/sample_screen.dart): Clean UI, 16:9 sabit resim kutusu, `ValueNotifier`, benzin göstergesi ve dijital anahtar içeren eksiksiz çalışan örnek ekran.
- [sample_test.dart](file:///c:/Users/2025/Documents/GitHub/SOFTITO-4DONEM-YUZYUZE/20-EKIM-ODEV/.agents/skills/takego-scaffold/examples/sample_test.dart): `ValueNotifier` birim testleri ve 16:9 `AspectRatio` taşma önleme widget testlerini gösteren örnek test paketi.

