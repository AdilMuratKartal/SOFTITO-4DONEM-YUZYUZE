#!/usr/bin/env bash
# ==============================================================================
# iJournal - Feature Scaffold Generator Script
# Bu betik, iJournal projesinde yeni bir modül (özellik) için Clean UI,
# ValueNotifier durum yönetimi ve temaya duyarlı widget yapısına sahip
# 4 katmanlı (controllers, models, view, widgets) klasör ve dosya iskeletini üretir.
#
# Kullanım:
#   ./generate_feature.sh <feature_name>
# Örnek:
#   ./generate_feature.sh timeline
#   ./generate_feature.sh entry_editor
# ==============================================================================

set -euo pipefail

# Renk kodları (Terminal çıktıları için)
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. Parametre Kontrolü
if [ $# -lt 1 ]; then
  echo -e "${RED}[HATA] Özellik adı belirtilmedi!${NC}"
  echo -e "${YELLOW}Kullanım: $0 <feature_name>${NC}"
  echo "Örnek:"
  echo "  $0 timeline"
  echo "  $0 entry_editor"
  exit 1
fi

RAW_NAME="$1"

# Snake_case formatına çevir (küçük harf ve tireleri alt çizgiye dönüştür)
FEATURE_NAME=$(echo "$RAW_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')

# PascalCase formatı üret (Örnek: entry_editor -> EntryEditor)
PASCAL_NAME=$(echo "$FEATURE_NAME" | awk -F_ '{for(i=1;i<=NF;i++) printf toupper(substr($i,1,1)) substr($i,2); print ""}')

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}  iJournal Feature Scaffold Üretici                  ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e "Özellik Adı (snake_case) : ${GREEN}${FEATURE_NAME}${NC}"
echo -e "Sınıf Ön Eki (PascalCase): ${GREEN}${PASCAL_NAME}${NC}"

# Proje kök dizinini belirle
# Script dizini: .agents/skills/feature-scaffold/script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../" && pwd)"

FEATURE_DIR="${PROJECT_ROOT}/lib/features/${FEATURE_NAME}"
TEST_DIR="${PROJECT_ROOT}/test/features/${FEATURE_NAME}/controllers"

echo -e "\nHedef Dizin: ${YELLOW}${FEATURE_DIR}${NC}"

# 2. Dizinleri Oluştur
mkdir -p "${FEATURE_DIR}/controllers"
mkdir -p "${FEATURE_DIR}/models"
mkdir -p "${FEATURE_DIR}/view"
mkdir -p "${FEATURE_DIR}/widgets"
mkdir -p "${TEST_DIR}"

echo -e "${GREEN}✓ Modül klasörleri başarıyla oluşturuldu.${NC}"

# 3. Controller Dosyası Üretimi
CONTROLLER_FILE="${FEATURE_DIR}/controllers/${FEATURE_NAME}_controller.dart"
cat <<EOF > "${CONTROLLER_FILE}"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// ${PASCAL_NAME} iş mantığını ve reaktif durumlarını yöneten Controller.
///
/// UI'dan tamamen bağımsızdır ve sayfa düzeyinde setState KULLANMAZ.
/// Tüm reaktif durumlar [ValueNotifier] ile tutulur.
class ${PASCAL_NAME}Controller {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<List<${PASCAL_NAME}Item>> itemsNotifier =
      ValueNotifier<List<${PASCAL_NAME}Item>>([]);
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  /// Verileri yerel servis veya önbellekten yükler.
  Future<void> loadData() async {
    isLoadingNotifier.value = true;
    errorNotifier.value = null;

    try {
      // TODO: core/services/storage_service üzerinden veri oku
      await Future.delayed(const Duration(milliseconds: 250));
      itemsNotifier.value = [
        ${PASCAL_NAME}Item(
          id: '1',
          title: 'İlk ${PASCAL_NAME} Kaydı',
          description: 'iJournal 5 tema sistemiyle tam uyumlu örnek içerik.',
          createdAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      errorNotifier.value = 'Veriler yüklenirken bir sorun oluştu: \$e';
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  /// Yeni bir öğe ekler.
  void addItem(${PASCAL_NAME}Item item) {
    itemsNotifier.value = [...itemsNotifier.value, item];
  }

  /// ID değerine göre öğe siler.
  void removeItem(String id) {
    itemsNotifier.value =
        itemsNotifier.value.where((item) => item.id != id).toList();
  }

  /// Bellek sızıntılarını önlemek için tüm notifier'ları temizler.
  void dispose() {
    isLoadingNotifier.dispose();
    itemsNotifier.dispose();
    errorNotifier.dispose();
  }
}
EOF
echo -e "${GREEN}✓ Controller: ${CONTROLLER_FILE}${NC}"

# 4. Model Dosyası Üretimi
MODEL_FILE="${FEATURE_DIR}/models/${FEATURE_NAME}_model.dart"
cat <<EOF > "${MODEL_FILE}"
import 'package:flutter/foundation.dart';

/// ${PASCAL_NAME} modülü için değişmez (immutable) veri modeli.
@immutable
class ${PASCAL_NAME}Item {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  const ${PASCAL_NAME}Item({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  ${PASCAL_NAME}Item copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return ${PASCAL_NAME}Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ${PASCAL_NAME}Item.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Item(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${PASCAL_NAME}Item &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ^ createdAt.hashCode;
}
EOF
echo -e "${GREEN}✓ Model: ${MODEL_FILE}${NC}"

# 5. Modüler Alt Kart Widget'ı Üretimi
WIDGET_FILE="${FEATURE_DIR}/widgets/${FEATURE_NAME}_card_widget.dart"
cat <<EOF > "${WIDGET_FILE}"
import 'package:flutter/material.dart';
import 'package:ijournal/core/extensions/context_extensions.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// Temaya duyarlı ${PASCAL_NAME} kart bileşeni.
///
/// Renkler doğrudan koda sabit YAZILMAZ; [context.colors] ve
/// [context.journalStyle] üzerinden okunur. 40 satır kuralına uygun olarak
/// ana View dosyasından ayrıştırılmıştır.
class ${PASCAL_NAME}CardWidget extends StatelessWidget {
  final ${PASCAL_NAME}Item item;
  final VoidCallback? onTap;

  const ${PASCAL_NAME}CardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(style.borderRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: style.headerFont.copyWith(
                    color: context.colors.onSurface,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: TextStyle(
                    color: context.colors.onSurface.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
EOF
echo -e "${GREEN}✓ Alt Widget: ${WIDGET_FILE}${NC}"

# 6. View Dosyası Üretimi (Clean UI, 40 satır altı build)
VIEW_FILE="${FEATURE_DIR}/view/${FEATURE_NAME}_view.dart"
cat <<EOF > "${VIEW_FILE}"
import 'package:flutter/material.dart';
import 'package:ijournal/core/extensions/context_extensions.dart';
import '../controllers/${FEATURE_NAME}_controller.dart';
import '../models/${FEATURE_NAME}_model.dart';
import '../widgets/${FEATURE_NAME}_card_widget.dart';

/// ${PASCAL_NAME} ana görünüm ekranı.
///
/// Clean UI ve ValueNotifier mimarisine sadık kalır.
/// Sayfa düzeyinde ağır setState barındırmaz.
class ${PASCAL_NAME}View extends StatefulWidget {
  const ${PASCAL_NAME}View({super.key});

  @override
  State<${PASCAL_NAME}View> createState() => _${PASCAL_NAME}ViewState();
}

class _${PASCAL_NAME}ViewState extends State<${PASCAL_NAME}View> {
  late final ${PASCAL_NAME}Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = ${PASCAL_NAME}Controller();
    _controller.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Scaffold(
      appBar: AppBar(
        title: Text('${PASCAL_NAME}', style: style.headerFont),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _controller.loadData,
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _controller.isLoadingNotifier,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContentList();
        },
      ),
    );
  }

  Widget _buildContentList() {
    return ValueListenableBuilder<List<${PASCAL_NAME}Item>>(
      valueListenable: _controller.itemsNotifier,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return const Center(
            child: Text('Henüz kayıt bulunmuyor.'),
          );
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ${PASCAL_NAME}CardWidget(item: items[index]);
          },
        );
      },
    );
  }
}
EOF
echo -e "${GREEN}✓ View: ${VIEW_FILE}${NC}"

# 7. Birim Testi Dosyası Üretimi
TEST_FILE="${TEST_DIR}/${FEATURE_NAME}_controller_test.dart"
cat <<EOF > "${TEST_FILE}"
import 'package:flutter_test/flutter_test.dart';
import 'package:ijournal/features/${FEATURE_NAME}/controllers/${FEATURE_NAME}_controller.dart';
import 'package:ijournal/features/${FEATURE_NAME}/models/${FEATURE_NAME}_model.dart';

void main() {
  group('${PASCAL_NAME}Controller Testleri', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumları doğru atanmalıdır', () {
      expect(controller.isLoadingNotifier.value, isFalse);
      expect(controller.itemsNotifier.value, isEmpty);
      expect(controller.errorNotifier.value, isNull);
    });

    test('loadData çağrıldığında öğeler listelenmelidir', () async {
      await controller.loadData();
      expect(controller.isLoadingNotifier.value, isFalse);
      expect(controller.itemsNotifier.value.isNotEmpty, isTrue);
    });

    test('addItem çağrıldığında yeni öğe listeye eklenmelidir', () {
      final item = ${PASCAL_NAME}Item(
        id: '99',
        title: 'Test Başlık',
        description: 'Test Açıklama',
        createdAt: DateTime.now(),
      );

      controller.addItem(item);
      expect(controller.itemsNotifier.value.contains(item), isTrue);
    });

    test('removeItem çağrıldığında ilgili öğe listeden çıkarılmalıdır', () {
      final item = ${PASCAL_NAME}Item(
        id: '100',
        title: 'Silinecek Öğe',
        description: 'Açıklama',
        createdAt: DateTime.now(),
      );

      controller.addItem(item);
      expect(controller.itemsNotifier.value.any((i) => i.id == '100'), isTrue);

      controller.removeItem('100');
      expect(controller.itemsNotifier.value.any((i) => i.id == '100'), isFalse);
    });
  });
}
EOF
echo -e "${GREEN}✓ Birim Testi: ${TEST_FILE}${NC}"

echo -e "\n${BLUE}======================================================${NC}"
echo -e "${GREEN}✓ ${PASCAL_NAME} özelliği standartlara tam uyumlu olarak oluşturuldu!${NC}"
echo -e "${YELLOW}Şimdi şu komutlarla kod kalitesini doğrulayabilirsiniz:${NC}"
echo -e "  flutter analyze"
echo -e "  flutter test test/features/${FEATURE_NAME}/controllers/${FEATURE_NAME}_controller_test.dart"
echo -e "${BLUE}======================================================${NC}"
