#!/usr/bin/env bash

# ==============================================================================
# Flutter Feature Scaffold Üretici Betiği (Clean UI & Reaktif State)
# Standart: project.md & SKILL.md kurallarına tam uyumlu özellik iskeleti kurar.
# ==============================================================================

set -euo pipefail

# Renkler
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parametre Kontrolü
if [ $# -lt 1 ]; then
    echo -e "${RED}Hata: Özellik (feature) adı belirtilmedi!${NC}"
    echo -e "${YELLOW}Kullanım:${NC} $0 <ozellik_adi>"
    echo -e "${YELLOW}Örnek:${NC}   $0 sleep_tracker"
    exit 1
fi

FEATURE_NAME="$1"

# Snake_case formatını doğrula / küçük harfe çevir
FEATURE_SNAKE=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')

# snake_case -> PascalCase dönüştürücü
to_pascal_case() {
    echo "$1" | awk -F_ '{for(i=1;i<=NF;i++) printf toupper(substr($i,1,1)) substr($i,2); print ""}'
}

FEATURE_PASCAL=$(to_pascal_case "$FEATURE_SNAKE")

# Proje Kök Dizinini Bulma (script klasörünün 4 üst dizini veya mevcut dizin)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Hedef Dizinler
FEATURE_DIR="$PROJECT_ROOT/lib/features/$FEATURE_SNAKE"
TEST_DIR="$PROJECT_ROOT/test/features/$FEATURE_SNAKE"

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}🚀 Yeni Feature Modülü Üretiliyor: ${GREEN}$FEATURE_SNAKE ($FEATURE_PASCAL)${NC}"
echo -e "${CYAN}================================================================${NC}"

# Klasörleri Oluşturma
echo -e "📁 Klasör yapısı oluşturuluyor..."
mkdir -p "$FEATURE_DIR/controllers"
mkdir -p "$FEATURE_DIR/models"
mkdir -p "$FEATURE_DIR/view"
mkdir -p "$FEATURE_DIR/widgets"
mkdir -p "$TEST_DIR"

# 1. Controller Dosyası (ValueNotifier Mimarisi)
CONTROLLER_FILE="$FEATURE_DIR/controllers/${FEATURE_SNAKE}_controller.dart"
echo -e "📄 Üretiliyor: ${YELLOW}$CONTROLLER_FILE${NC}"
cat <<EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_SNAKE}_model.dart';

/// $FEATURE_PASCAL Modülü için ValueNotifier Tabanlı Hafif Reaktif Kontrolcü
class ${FEATURE_PASCAL}Controller {
  final ValueNotifier<int> counterNotifier = ValueNotifier<int>(0);
  final ValueNotifier<List<${FEATURE_PASCAL}Model>> itemsNotifier =
      ValueNotifier<List<${FEATURE_PASCAL}Model>>(<${FEATURE_PASCAL}Model>[]);

  int get counter => counterNotifier.value;
  List<${FEATURE_PASCAL}Model> get items => itemsNotifier.value;

  /// Sayaç artırma
  void increment() {
    counterNotifier.value += 1;
  }

  /// Yeni veri ekleme (Reaktif listeyi güncelleme)
  void addItem(${FEATURE_PASCAL}Model item) {
    itemsNotifier.value = List<${FEATURE_PASCAL}Model>.from(itemsNotifier.value)..insert(0, item);
  }

  /// Kayıt silme
  void removeItem(String id) {
    itemsNotifier.value = itemsNotifier.value.where((item) => item.id != id).toList();
  }

  /// Sayaç ve verileri sıfırlama
  void reset() {
    counterNotifier.value = 0;
    itemsNotifier.value = <${FEATURE_PASCAL}Model>[];
  }

  /// Kaynakları serbest bırakma (Memory leak önleme)
  void dispose() {
    counterNotifier.dispose();
    itemsNotifier.dispose();
  }
}
EOF

# 2. Model Dosyası (Immutable, copyWith, fromJson, toJson)
MODEL_FILE="$FEATURE_DIR/models/${FEATURE_SNAKE}_model.dart"
echo -e "📄 Üretiliyor: ${YELLOW}$MODEL_FILE${NC}"
cat <<EOF > "$MODEL_FILE"
import 'package:flutter/foundation.dart';

/// $FEATURE_PASCAL İmmutable Veri Modeli
@immutable
class ${FEATURE_PASCAL}Model {
  final String id;
  final String title;
  final int value;
  final DateTime createdAt;

  const ${FEATURE_PASCAL}Model({
    required this.id,
    required this.title,
    required this.value,
    required this.createdAt,
  });

  /// İmmutable kopyalama metodu
  ${FEATURE_PASCAL}Model copyWith({
    String? id,
    String? title,
    int? value,
    DateTime? createdAt,
  }) {
    return ${FEATURE_PASCAL}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// JSON Parse için Factory Metot
  factory ${FEATURE_PASCAL}Model.fromJson(Map<String, dynamic> json) {
    return ${FEATURE_PASCAL}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// JSON Export Metodu
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${FEATURE_PASCAL}Model &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          value == other.value &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, title, value, createdAt);
}
EOF

# 3. Widget Dosyası (Modüler Kart)
WIDGET_FILE="$FEATURE_DIR/widgets/${FEATURE_SNAKE}_card.dart"
echo -e "📄 Üretiliyor: ${YELLOW}$WIDGET_FILE${NC}"
cat <<EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';
import '../models/${FEATURE_SNAKE}_model.dart';

/// $FEATURE_PASCAL Modülü için Modüler Kart Bileşeni
class ${FEATURE_PASCAL}Card extends StatelessWidget {
  final ${FEATURE_PASCAL}Model item;
  final VoidCallback? onDelete;

  const ${FEATURE_PASCAL}Card({
    super.key,
    required this.item,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.star_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Değer: \${item.value}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              color: theme.colorScheme.error,
              onPressed: onDelete,
              tooltip: 'Kaydı Sil',
            ),
        ],
      ),
    );
  }
}
EOF

# 4. View Dosyası (Clean UI, ValueListenableBuilder, <40 Satır Build)
VIEW_FILE="$FEATURE_DIR/view/${FEATURE_SNAKE}_view.dart"
echo -e "📄 Üretiliyor: ${YELLOW}$VIEW_FILE${NC}"
cat <<EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controllers/${FEATURE_SNAKE}_controller.dart';
import '../models/${FEATURE_SNAKE}_model.dart';
import '../widgets/${FEATURE_SNAKE}_card.dart';

/// $FEATURE_PASCAL Ana Ekran Görünümü (StatelessWidget + Clean UI)
class ${FEATURE_PASCAL}View extends StatelessWidget {
  final ${FEATURE_PASCAL}Controller controller;

  const ${FEATURE_PASCAL}View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$FEATURE_PASCAL Modülü'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context),
              const SizedBox(height: 16),
              _buildActionSection(context),
              const SizedBox(height: 20),
              _buildListSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: controller.counterNotifier,
      builder: (context, counter, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                'Toplam Sayaç',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '\$counter',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text('Sayaç Arttır'),
            onPressed: () => controller.increment(),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () => controller.reset(),
          child: const Text('Sıfırla'),
        ),
      ],
    );
  }

  Widget _buildListSection(BuildContext context) {
    return ValueListenableBuilder<List<${FEATURE_PASCAL}Model>>(
      valueListenable: controller.itemsNotifier,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('Henüz bir kayıt bulunmuyor.'),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ${FEATURE_PASCAL}Card(
              item: item,
              onDelete: () => controller.removeItem(item.id),
            );
          },
        );
      },
    );
  }
}
EOF

# 5. Birim Test İskeleti
TEST_FILE="$TEST_DIR/${FEATURE_SNAKE}_controller_test.dart"
echo -e "📄 Üretiliyor: ${YELLOW}$TEST_FILE${NC}"
cat <<EOF > "$TEST_FILE"
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim_v1/features/${FEATURE_SNAKE}/controllers/${FEATURE_SNAKE}_controller.dart';
import 'package:susadim_v1/features/${FEATURE_SNAKE}/models/${FEATURE_SNAKE}_model.dart';

void main() {
  group('${FEATURE_PASCAL}Controller Birim Testleri', () {
    late ${FEATURE_PASCAL}Controller controller;

    setUp(() {
      controller = ${FEATURE_PASCAL}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç değerleri sıfır ve boş liste olmalıdır', () {
      expect(controller.counter, 0);
      expect(controller.items.isEmpty, true);
    });

    test('increment metodu sayacı 1 arttırmalıdır', () {
      controller.increment();
      expect(controller.counter, 1);
      controller.increment();
      expect(controller.counter, 2);
    });

    test('addItem ve removeItem reaktif listeyi doğru güncellemelidir', () {
      final item = ${FEATURE_PASCAL}Model(
        id: '1',
        title: 'Örnek Kayıt',
        value: 100,
        createdAt: DateTime.now(),
      );

      controller.addItem(item);
      expect(controller.items.length, 1);
      expect(controller.items.first.title, 'Örnek Kayıt');

      controller.removeItem('1');
      expect(controller.items.isEmpty, true);
    });
  });
}
EOF

chmod +x "$CONTROLLER_FILE" "$MODEL_FILE" "$WIDGET_FILE" "$VIEW_FILE" "$TEST_FILE" 2>/dev/null || true

echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}✅ $FEATURE_PASCAL modülü başarıyla üretildi!${NC}"
echo -e "${GREEN}Konum: lib/features/$FEATURE_SNAKE/${NC}"
echo -e "${GREEN}================================================================${NC}"
