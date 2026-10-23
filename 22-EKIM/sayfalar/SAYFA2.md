# Sayfa 2: Yol Haritası & Aşamalı Hedef Ağacı (sayfalar/SAYFA2.md)

## 1. Ekran Amacı ve Özeti

Kullanıcının büyük ve göz korkutucu hedeflerini (örneğin 30 günde 5 km koşmak, temel seviye gitar çalmak, 21 gün şekersiz beslenmek) parçalara bölerek adım adım ilerlediği **Roadmap (Yol Haritası)** modülüdür.

Kullanıcı artık birden fazla yol haritasına sahip olabilir, sıfırdan dinamik basamaklarla kendi hedeflerini oluşturabilir ve arka planda ana sayfada yapılan alışkanlıklar yol haritasını anında otomatik günceller.

---

## 2. Mimari Yenilikler ve Ekran Hiyerarşisi

### 2.1. Hiyerarşik Ekran Yapısı (Liste $\rightarrow$ Detay)
- **Liste Ekranı (`RoadmapListView`):**
  - **Aktif Yol Haritalarım:** Kullanıcının o an takip ettiği aktif yol haritası hero kartı ve altında dikey aşama basamakları ağacı yer alır.
  - **Tamamlanan Yol Haritaları Arşivi:** Biten haritalar için açılır/kapanır akordeon (ExpansionTile / Animated Accordion) yapısında arşiv kartları bulunur.
  - **FAB (+):** Ekranın sağ altındaki dinamik oluşturma butonu.
- **Detay Ekranı (`RoadmapDetailView`):**
  - Listeden herhangi bir karta veya düğüme tıklandığında açılan tam ekran rota detay görünümü.
  - Haritanın tüm basamak ağacını, bağlı mikro-alışkanlıkları ve manuel tamamlama/silme aksiyonlarını barındırır.

### 2.2. Dinamik Yol Haritası Oluşturma Sihirbazı (`CreateRoadmapSheet`)
- Kullanıcı `+` butonuyla sıfırdan kendi yol haritasını oluşturabilir.
- Başlık, kategori, emoji simgesi, tahmini süre ve ödül adı belirlenir.
- **Dinamik Basamak Oluşturucu:** Kullanıcı dilediği kadar aşama ekleyebilir, başlık ve açıklama yazabilir, hedef gün serisi (3, 7, 14, 21 gün) belirleyebilir ve kullanıcının mevcut alışkanlıklarından çoklu seçimle basamağa görev bağlayabilir.

### 2.3. Basamaklara Alışkanlık Bağlama Esnekliği
- Her yol haritası basamağına somut görevler bağlanabilir:
  - **Mevcut Alışkanlıklar:** Kullanıcının takip ettiği mikro-alışkanlıklardan ID referansıyla (`List<String> linkedHabitIds`) çoklu seçim yapılabilir.
  - **Özel Alışkanlıklar:** Basamağa özel hedef seri (`targetDaysStreak`) tanımlanır.

### 2.4. Arka Plan Canlı Senkronizasyonu (Single Source of Truth)
- **Veri Tekilliği:** `RoadmapNodeModel` içine alışkanlık verisi kopyalanmaz; sadece ID referansı (`linkedHabitIds`) ve hedef koşulu (`targetDaysStreak`) tutulur.
- **Otomatik Dinleyici:** `RoadmapController`, kurucu metodunda `HabitController`'ı parametre olarak alır ve `habitController.habitsNotifier.addListener(_onHabitsChanged)` ile sürekli dinler.
- **Canlı Tetiklenme:** Kullanıcı ana sayfada bir alışkanlığa tik attığı anda, kullanıcı Roadmap sayfasına hiç gitmese dahi basamak ilerlemesi ve kilit açılmaları arka planda anında güncellenir ve `StorageService` ile kalıcı olarak kaydedilir.

### 2.5. Düğüm Kilit ve Tamamlama Kriterleri
Görsel düğüm durumları 3 kesin aşamaya bağlandı:
1. **Kilitli (Locked):** Gri kilit ikonu, pasif gri yol çizgisi, uyarı kutusu (`"X. Basamak tamamlandığında açılacak"`).
2. **Aktif (Active):** Parlama (pulse/glow) efekti, numara rozeti, aşama ilerleme barı, **bağlı günlük alışkanlıklar listesi** ve tek dokunuşla tamamlama radyo butonları.
3. **Tamamlanan (Completed):** Dolu zümrüt yeşili zemin, onay tiki (`Icons.check`), seri tamamlandı rozeti ve bağlı alışkanlık etiketleri.

---

## 3. Klasör ve Dosya Yerleşimi

Projede standarda uygun olarak şu dosya yapısı inşa edilmiştir:
- `lib/features/models/roadmap_model.dart`: `RoadmapNodeModel` ve `RoadmapModel` veri sınıfları ve JSON serileştirme.
- `lib/features/controllers/roadmap_controller.dart`: State controller'ı ve arka plan `_onHabitsChanged` dinleyicisi.
- `lib/features/views/roadmap_list_view.dart`: Aktif yol haritası, düğüm ağacı ve tamamlananlar akordeon listesi.
- `lib/features/views/roadmap_detail_view.dart`: Yol haritası detay ekranı ve basamak aksiyonları.
- `lib/features/widgets/roadmap_card.dart`: Hero aktif harita kartı ve kompakt arşiv kartı.
- `lib/features/widgets/roadmap_node_tree.dart`: Dikey aşama basamakları ağacı ve interaktif görev toggle'ları.
- `lib/features/widgets/create_roadmap_sheet.dart`: Dinamik basamaklı yol haritası oluşturma sihirbazı.
- `lib/features/views/roadmap/roadmap_view.dart`: Navigation stack için güvenli yönlendirici (wrapper).

---

## 4. Veri Modelleri

```dart
class RoadmapNodeModel {
  final String id;
  final int stepNumber;
  final String title;
  final String description;
  final int targetDaysStreak;       // Bu aşamayı tamamlamak için gereken seri (gün)
  final List<String> linkedHabitIds; // Bağlı mikro-alışkanlık referans ID'leri
  final bool isCompleted;
  final bool isLocked;

  const RoadmapNodeModel({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.targetDaysStreak,
    required this.linkedHabitIds,
    this.isCompleted = false,
    this.isLocked = true,
  });

  RoadmapNodeModel copyWith({...});
  factory RoadmapNodeModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

class RoadmapModel {
  final String id;
  final String title;
  final String category;
  final String iconName;
  final String durationWeeks;
  final String nextReward;
  final bool isCompleted;
  final List<RoadmapNodeModel> nodes;

  const RoadmapModel({
    required this.id,
    required this.title,
    required this.category,
    required this.iconName,
    this.durationWeeks = '4 Hafta',
    this.nextReward = 'Odak Nişanı',
    this.isCompleted = false,
    required this.nodes,
  });

  double get progressPercentage; // Tamamlanan düğüm / Toplam düğüm yüzdesi
  double get progressRatio;      // 0.0 - 1.0 aralığı
  int get completedNodesCount;
  RoadmapNodeModel? get activeNode;

  RoadmapModel copyWith({...});
  factory RoadmapModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

---

## 5. Nasıl Test Edilir?

1. **Aktif Yol Haritasını Görüntüleme:**
   - Alt menüden 2. sekme olan **"Rota"** (Roadmap) sekmesine geçin.
   - "30 Günde Demir İrade & Zindelik" öne çıkan hero kartını ve altında 1. basamağın tamamlandığını, 2. basamağın aktif aşama olduğunu görün.
2. **Bağlı Alışkanlık Canlı Senkronizasyon Testi (Single Source of Truth):**
   - Rota ekranında Aktif Basamak altındaki bağlı alışkanlıklardan birine dokunarak tamamlayın (veya Ana Sayfaya gidip o alışkanlığı tamamlayın).
   - Rota ekranındaki ilerlemenin anında güncellendiğini ve kilitlerin otomatik açıldığını gözlemleyin.
3. **Yeni Yol Haritası Sihirbazı Testi:**
   - Ekranın sağ altındaki yeşil **"+"** butonuna basın.
   - Başlık, kategori, emoji ve basamakları belirleyin.
   - Mevcut mikro-alışkanlıklarınızdan basamağa alışkanlık bağlayın ve "Yol Haritasını Başlat" deyin. Yeni harita listeye eklenecektir.
4. **Tamamlananlar Arşivi Testi:**
   - Sayfanın altındaki "Tamamlanan Yol Haritaları (1)" akordeonuna dokunarak arşivi genişletip kapatın.