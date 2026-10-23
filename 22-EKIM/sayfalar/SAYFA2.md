# Sayfa 2: Yol Haritası & Aşamalı Hedef Ağacı (sayfalar/SAYFA2.md)

## 1. Ekran Amacı ve Özeti

Kullanıcının büyük ve göz korkutucu hedeflerini (örneğin 5 km koşmak, temel seviye gitar çalmak, 21 gün şekersiz beslenmek) parçalara bölerek adım adım ilerlediği **Roadmap (Yol Haritası)** modülüdür. 

Kullanıcı iki farklı şekilde yol haritası kullanabilir:
1. **Hazır Şablonlar (Pre-built Roadmaps):** Sistem tarafından tanımlı, popüler mikro-alışkanlık zincirleri.
2. **Özel Yol Haritası (Custom Roadmaps):** Kullanıcının kendi belirlediği ana hedefi aşamalara (Node/Düğüm) ayırdığı kişisel rota.

---

## 2. Arayüz Hiyerarşisi ve Bileşen Düzeni

```text
+-----------------------------------------------------------------------+
|  Yol Haritaları                                          [ + Yeni Yol]|
+-----------------------------------------------------------------------+
|  Sekmeler: [ (✓) Aktif Yol Haritam ]     [ (🧭) Şablonları Keşfet ]   |
+-----------------------------------------------------------------------+
|  [ Aktif Rota Kartı ]                                                 |
|  🎯 0'dan 5K Koşuya (30 Günlük Adaptasyon)                           |
|  İlerleme: 3 / 8 Aşama Tamamlandı (%37.5)                [ 🔥 12 Gün] |
|  [==========================-----------------------------------------]|
+-----------------------------------------------------------------------+
|  AŞAMA AĞACI (Dikey Düğümler):                                        |
|                                                                       |
|   ( ✓ )  1. Aşama: Günde 15 Dk Tempolu Yürüyüş (Tamamlandı)          |
|     │                                                                 |
|   ( ✓ )  2. Aşama: 1 Dk Koşu / 2 Dk Yürüyüş İnterval (Tamamlandı)    |
|     │                                                                 |
|   ( ⚡ ) 3. Aşama: Kesintisiz 1.5 Km Hafif Koşu (AKTİF / DEVAM EDİYOR) |
|   ┌─┴─────────────────────────────────────────────────────────────┐   |
|   │ Detay: Haftada 3 gün, nabzı zorlamadan 1.5 km mesafe tamamla. │   |
|   │ Günlük Görev: Bugün 1.5 km koşuyu tamamla.                     │   |
|   │ [ Alışkanlık Olarak Ekle ]          [ Aşamayı Tamamla (✓) ]   │   |
|   └─┬─────────────────────────────────────────────────────────────┘   |
|     │                                                                 |
|   ( 🔒 ) 4. Aşama: Kesintisiz 2.5 Km Koşu (KİLİTLİ)                   |
|     │                                                                 |
|   ( 🔒 ) 5. Aşama: Hedef 5K Koşusu (KİLİTLİ - FİNAL ROZETİ 🏆)       |
+-----------------------------------------------------------------------+
```

### 2.1. Üst Sekme Geçişi (Tab Toggle)
- **Aktif Yol Haritam:** Kullanıcının o an takip ettiği ilerleme ağacını ve düğümleri gösterir.
- **Şablonları Keşfet:** "21 Günde Şekersiz Yaşam", "Gitar Akorlarına Giriş", "Erken Uyanma Rutini" gibi hazır kartların bulunduğu keşif vitrini.

### 2.2. Düğüm (Node) Durumları ve Tasarım Kuralları
- **Tamamlanan Düğüm (Completed Node):**
  - İkon: Dolu yeşil zemin üzerinde beyaz tik (`Icons.check`).
  - Çizgi: Bir sonraki düğüme bağlanan hat kesintisiz zümrüt yeşilidir (`AppColors.primary`).
- **Aktif Düğüm (Active / In-Progress Node):**
  - İkon: Vurgulu zemin (`AppColors.primary`), etrafında hafif nefes alma (pulse/glow) animasyonu.
  - Açılır Kart (Expanded): Altında aşamanın detay açıklaması, günlük mikro adımı ve aksiyon butonları (`Aşamayı Tamamla`, `Ana Ekrana Alışkanlık Olarak Bağla`).
- **Kilitli Düğüm (Locked Node):**
  - İkon: Gri zemin, asma kilit ikonu (`Icons.lock_outline`).
  - Çizgi: Bir sonraki düğüme bağlanan hat kesikli gridir (`AppColors.borderLight`).
  - Tıklandığında kullanıcıya *"Bu aşamayı açmak için önceki aşamayı tamamlamalısın"* uyarısı (SnackBar) verir.

---

## 3. Durum Yönetimi (State Architecture)

### 3.1. `RoadmapController` (`features/controllers/roadmap_controller.dart`)
- `ValueNotifier<List<RoadmapModel>> roadmapsNotifier`: Kullanıcının kayıtlı tüm yol haritalarını tutar.
- `ValueNotifier<RoadmapModel?> activeRoadmapNotifier`: Şu anda ekranda açık olan aktif yol haritasını tutar.
- `ValueNotifier<int> activeTabNotifier`: `0` (Aktif Ağaç) veya `1` (Şablonlar) indeksini tutar.

**Metotlar:**
- `selectRoadmap(String roadmapId)`: Seçilen yol haritasını aktif yapar.
- `completeNode(String roadmapId, String nodeId)`: İlgili aşamayı tamamlar, sonraki düğümün kilidini otomatik açar (`isLocked = false`), XP puanı ekler.
- `linkNodeToDailyHabit(RoadmapNodeModel node)`: Aşamadaki mikro adımı Sayfa 1'deki günlük alışkanlık listesine otomatik bir görev olarak kaydeder.
- `createCustomRoadmap(RoadmapModel newRoadmap)`: Kullanıcının kendi oluşturduğu yeni yol haritasını listeye ekler.

---

## 4. Veri Modelleri

### 4.1. `RoadmapNodeModel` (`features/models/roadmap_node_model.dart`)
```dart
enum NodeStatus { completed, active, locked }

class RoadmapNodeModel {
  final String id;
  final int orderIndex;
  final String title;
  final String description;
  final String dailyMicroAction;
  final NodeStatus status;
  final int rewardXp;

  const RoadmapNodeModel({
    required this.id,
    required this.orderIndex,
    required this.title,
    required this.description,
    required this.dailyMicroAction,
    required this.status,
    this.rewardXp = 50,
  });

  RoadmapNodeModel copyWith({
    NodeStatus? status,
  }) {
    return RoadmapNodeModel(
      id: id,
      orderIndex: orderIndex,
      title: title,
      description: description,
      dailyMicroAction: dailyMicroAction,
      status: status ?? this.status,
      rewardXp: rewardXp,
    );
  }

  factory RoadmapNodeModel.fromJson(Map<String, dynamic> json) {
    return RoadmapNodeModel(
      id: json['id'],
      orderIndex: json['orderIndex'],
      title: json['title'],
      description: json['description'],
      dailyMicroAction: json['dailyMicroAction'] ?? '',
      status: NodeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => NodeStatus.locked,
      ),
      rewardXp: json['rewardXp'] ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderIndex': orderIndex,
      'title': title,
      'description': description,
      'dailyMicroAction': dailyMicroAction,
      'status': status.name,
      'rewardXp': rewardXp,
    };
  }
}
```

### 4.2. `RoadmapModel` (`features/models/roadmap_model.dart`)
```dart
import 'roadmap_node_model.dart';

class RoadmapModel {
  final String id;
  final String title;
  final String category;
  final String iconName;
  final bool isTemplate;
  final List<RoadmapNodeModel> nodes;

  const RoadmapModel({
    required this.id,
    required this.title,
    required this.category,
    required this.iconName,
    required this.isTemplate,
    required this.nodes,
  });

  int get completedCount => nodes.where((n) => n.status == NodeStatus.completed).length;
  double get progressRatio => nodes.isEmpty ? 0.0 : completedCount / nodes.length;

  RoadmapModel copyWith({
    List<RoadmapNodeModel>? nodes,
  }) {
    return RoadmapModel(
      id: id,
      title: title,
      category: category,
      iconName: iconName,
      isTemplate: isTemplate,
      nodes: nodes ?? this.nodes,
    );
  }

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    return RoadmapModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      iconName: json['iconName'] ?? 'flag',
      isTemplate: json['isTemplate'] ?? false,
      nodes: (json['nodes'] as List)
          .map((item) => RoadmapNodeModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'iconName': iconName,
      'isTemplate': isTemplate,
      'nodes': nodes.map((n) => n.toJson()).toList(),
    };
  }
}
```

---

## 5. View Kod İskeleti (`features/views/roadmap_view.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/roadmap_controller.dart';
import '../models/roadmap_model.dart';
import '../models/roadmap_node_model.dart';
import '../widgets/roadmap_node_card.dart';

class RoadmapView extends StatefulWidget {
  const RoadmapView({super.key});

  @override
  State<RoadmapView> createState() => _RoadmapViewState();
}

class _RoadmapViewState extends State<RoadmapView> {
  late final RoadmapController _roadmapController;

  @override
  void initState() {
    super.initState();
    _roadmapController = RoadmapController();
    _roadmapController.loadInitialRoadmaps();
  }

  @override
  void dispose() {
    _roadmapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Yol Haritaları'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Yeni Hedef Ağacı Oluştur',
            onPressed: () {
              // Özel Yol Haritası Oluşturma Modalı
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabSelector(),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _roadmapController.activeTabNotifier,
                builder: (context, currentTab, _) {
                  return currentTab == 0
                      ? _buildActiveRoadmapView()
                      : _buildTemplatesDiscoveryView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return ValueListenableBuilder<int>(
      valueListenable: _roadmapController.activeTabNotifier,
      builder: (context, activeTab, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _roadmapController.changeTab(0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: activeTab == 0 ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Aktif Yol Haritam',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: activeTab == 0 ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _roadmapController.changeTab(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: activeTab == 1 ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Şablonları Keşfet',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: activeTab == 1 ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveRoadmapView() {
    return ValueListenableBuilder<RoadmapModel?>(
      valueListenable: _roadmapController.activeRoadmapNotifier,
      builder: (context, activeRoadmap, _) {
        if (activeRoadmap == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.alt_route_rounded, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 12),
                const Text('Aktif bir yol haritanız yok.'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _roadmapController.changeTab(1),
                  child: const Text('Şablonlardan Seç'),
                )
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildRoadmapOverviewHeader(activeRoadmap),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeRoadmap.nodes.length,
              itemBuilder: (context, index) {
                final node = activeRoadmap.nodes[index];
                final isLast = index == activeRoadmap.nodes.length - 1;
                return RoadmapNodeCard(
                  node: node,
                  isLastNode: isLast,
                  onCompleteNode: () => _roadmapController.completeNode(activeRoadmap.id, node.id),
                  onLinkHabit: () => _roadmapController.linkNodeToDailyHabit(node),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoadmapOverviewHeader(RoadmapModel roadmap) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                roadmap.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  roadmap.category,
                  style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'İlerleme: ${roadmap.completedCount} / ${roadmap.nodes.length} Aşama',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                '%${(roadmap.progressRatio * 100).toInt()}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: roadmap.progressRatio,
              minHeight: 6,
              backgroundColor: AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesDiscoveryView() {
    return ValueListenableBuilder<List<RoadmapModel>>(
      valueListenable: _roadmapController.roadmapsNotifier,
      builder: (context, allRoadmaps, _) {
        final templates = allRoadmaps.where((r) => r.isTemplate).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.route_rounded, color: AppColors.primary),
                ),
                title: Text(template.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${template.nodes.length} Aşamalı Yol Haritası • ${template.category}'),
                trailing: ElevatedButton(
                  onPressed: () => _roadmapController.selectRoadmap(template.id),
                  child: const Text('Başla'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
```