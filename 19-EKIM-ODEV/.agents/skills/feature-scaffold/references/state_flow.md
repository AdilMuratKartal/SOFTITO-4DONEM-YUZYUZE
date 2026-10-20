# iJournal Özellik İskeleti Durum ve Mimari Akış Rehberi (State Flow)

Bu doküman, **iJournal** projesinde geliştirilen her yeni modülün (`lib/features/<feature_name>/`) uymak zorunda olduğu veri akışını, durum yönetimini ve Clean UI standartlarını tanımlar.

---

## 1. Mimari Katmanlar ve Sorumluluk Ayrımı

Projede kodların tek bir dosyada veya katmanda toplanması kesinlikle yasaktır. Her modül 4 ana klasör ve bir test klasöründen oluşur:

```text
lib/features/<feature_name>/
├── controllers/    # Reaktif durumlar (ValueNotifier), iş mantığı, servis haberleşmesi
├── models/         # Immutable veri modelleri, copyWith, fromJson, toJson
├── view/           # Ekran iskeleti (Scaffold, AppBar), Clean UI, ValueListenableBuilder
└── widgets/        # 40 satırı aşmayan alt bileşenler, temaya duyarlı kartlar/butonlar
test/features/<feature_name>/
└── controllers/    # UI bağımsız birim testleri (flutter_test)
```

### Katman Sorumluluk Matrisi

| Katman | Sorumluluk | İzin Verilen | Yasak Olanlar |
| :--- | :--- | :--- | :--- |
| **`controllers/`** | Veri yükleme, iş mantığı, reaktif durum yönetimi | `ValueNotifier`, `ChangeNotifier`, Service çağrıları | `BuildContext`, UI widget'ları, doğrudan `setState` |
| **`models/`** | Veri taşıma, serileştirme | `@immutable`, `final` alanlar, `copyWith`, `json` | Değişken (`var`/`mutable`) alanlar, iş mantığı |
| **`view/`** | Ekran yerleşimi, gezinme | `StatelessWidget`, lokal `StatefulWidget`, `ValueListenableBuilder` | 40+ satır `build`, ağır `setState`, sabit `Color(...)` |
| **`widgets/`** | Modüler parçalar, temaya duyarlı kartlar | `context.colors`, `context.journalStyle`, `const` | Ekran seviyesi kontrol, doğrudan servis bağımlılığı |
| **`test/`** | Doğrulama | Unit test, mock çağrılar, notifier state assert | UI bağımlılığı |

---

## 2. Reaktif Durum Akış Şeması (Mermaid)

iJournal mimarisinde veri akışı **tek yönlüdür (Unidirectional Data Flow)**. UI hiçbir zaman doğrudan servislerle konuşmaz; tüm işlemler `Controller` üzerinden akar:

```mermaid
flowchart TD
    subgraph UI_Katmani["Arayüz Katmanı (lib/features/view & widgets)"]
        UserAction["Kullanıcı Etkileşimi (Dokunma / Yazma)"]
        VLB["ValueListenableBuilder<T>"]
        SubWidgets["Temaya Duyarlı Alt Widget'lar (context.colors & journalStyle)"]
    end

    subgraph Controller_Katmani["Kontrolcü Katmanı (lib/features/controllers)"]
        Controller["FeatureController"]
        VN_State["ValueNotifier<State> (isLoading, items, error)"]
    end

    subgraph Core_Servisler["Çekirdek Servisler (lib/core/services)"]
        StorageService["StorageService (Yerel Depolama / SQLite / Hive / SharedPreferences)"]
        ThemeController["ThemeController (Aktif Tema & Mod)"]
    end

    UserAction -->|Metot Çağrısı (controller.addItem)| Controller
    Controller -->|Asenkron İşlem| StorageService
    StorageService -->|Ham Veri| Controller
    Controller -->|Değer Güncellemesi (notifier.value = ...)| VN_State
    VN_State -.->|Reaktif Bildirim| VLB
    VLB -->|Yalnızca Etkilenen Parçayı Çiz| SubWidgets
    ThemeController -.->|Tema / Mod Değişimi| SubWidgets
```

---

## 3. Kırmızı Çizgiler ve Uygulama Kuralları

### Kural 1: Sayfa Düzeyinde `setState` Yasağı
- Ekran genelini kapsayan veya bir veri listesini güncellemek için sayfa seviyesinde `setState(() {})` çağrısı **KULLANILAMAZ**.
- Sadece ve sadece `ValueNotifier` ve `ValueListenableBuilder` kullanılacaktır.
- İstisna: Yalnızca lokal arayüz durumları (örneğin metin kontrolü `TextEditingController` ve odak kontrolü `FocusNode`) için `StatefulWidget` kullanılabilir.

### Kural 2: 40 Satır `build` Metot Limiti
- Hiçbir `build` metodu 40 satırı geçemez.
- 40 satırı aşan veya mantıksal bir bütün oluşturan her UI parçası (kartlar, filtre barları, özel butonlar) derhal `widgets/` klasörüne bağımsız bir `StatelessWidget` olarak taşınmalıdır.

### Kural 3: Sıfır Sabit Renk ve Stil Bağımsızlığı
- Widget'larda kesinlikle doğrudan `Color(0xFF...)` veya sabit gölge/kenarlık tanımlanamaz.
- Renkler daima `context.colors` (`Theme.of(context).colorScheme`) üzerinden alınmalıdır.
- Kenarlık kalınlığı, rengi, köşe yuvarlaklığı, kart gölgeleri ve başlık fontları daima `context.journalStyle` (`JournalThemeStyle ThemeExtension`) üzerinden çekilmelidir.
- Bu sayede yazılan özellik, iJournal'ın 5 temasına (NeoBrutalist, Minimalist, Journal, Hand-Drawn, Rubber Hose) tek bir satır ekstra kod yazmadan anında tam uyum sağlar.

### Kural 4: Bellek Sızıntısı (Memory Leak) Önleme
- Controller içinde tanımlanan her `ValueNotifier` mutlaka `dispose()` metodunda kapatılmalıdır.
- View içinde açılan her `TextEditingController` ve `FocusNode`, `State.dispose()` yaşam döngüsünde dispose edilmelidir.

```dart
// Controller dispose örneği
void dispose() {
  isLoadingNotifier.dispose();
  itemsNotifier.dispose();
  errorNotifier.dispose();
}

// View dispose örneği
@override
void dispose() {
  _textController.dispose();
  _controller.dispose();
  super.dispose();
}
```

### Kural 5: `const` Optimizasyonu
- Durumu değişmeyen tüm widget yapıcılarında `const` kullanımı zorunludur.
- Bu kural Flutter'ın widget ağacında gereksiz re-render işlemlerini engeller ve 60/120 FPS akıcılığı korur.

---

## 4. Testlenebilirlik ve Birim Test Rehberi

Her özellik modülü için Controller seviyesinde tam izole birim testleri yazılmalıdır. Controller hiçbir Flutter UI motoruna veya BuildContext'e ihtiyaç duymadığından testler milisaniyeler içinde koşar:

```dart
test('Yeni öğe eklendiğinde itemsNotifier güncellenmelidir', () {
  final controller = TimelineController();
  final item = JournalEntry(id: '1', title: 'Başlık', content: 'İçerik', createdAt: DateTime.now());

  controller.addItem(item);

  expect(controller.itemsNotifier.value.contains(item), isTrue);
  controller.dispose();
});
```

---

## 5. Doğrulama Komutları

Geliştirme tamamlandıktan sonra proje şu komutlarla doğrulanmalıdır:

```bash
flutter analyze
flutter test test/features/<feature_name>/controllers/
```
