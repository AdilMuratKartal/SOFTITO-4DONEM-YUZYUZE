#!/usr/bin/env bash
# ==============================================================================
# TakeGO Feature Scaffold Oluşturucu (generate_feature.sh)
#
# Kullanım:
#   ./generate_feature.sh <feature_name>
#   Örnek: ./generate_feature.sh car_listing
#          ./generate_feature.sh car_detail
#          ./generate_feature.sh create_listing
#          ./generate_feature.sh smart_key_assistant
# ==============================================================================

set -euo pipefail

# Renk tanımlamaları
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${CYAN}${BOLD}====================================================${NC}"
echo -e "${CYAN}${BOLD}       TakeGO Feature İskelet Oluşturucu            ${NC}"
echo -e "${CYAN}${BOLD}====================================================${NC}"

# Parametre kontrolü
FEATURE_NAME="${1:-}"

if [ -z "$FEATURE_NAME" ]; then
    echo -e "${YELLOW}Bir modül adı belirtilmedi.${NC}"
    read -rp "Oluşturulacak modül adını giriniz (örn: car_listing): " FEATURE_NAME
fi

# Küçük harfe çevir ve geçersiz karakterleri kontrol et
FEATURE_NAME="$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')"

if [[ ! "$FEATURE_NAME" =~ ^[a-z0-9_]+$ ]]; then
    echo -e "${RED}HATA: Modül adı yalnızca küçük harf, rakam ve alt çizgi (_) içerebilir.${NC}"
    exit 1
fi

# PascalCase ve TitleCase dönüşümleri
to_pascal_case() {
    echo "$1" | awk -F_ '{for(i=1;i<=NF;i++) printf "%s", toupper(substr($i,1,1)) substr($i,2)}'
}

PASCAL_NAME="$(to_pascal_case "$FEATURE_NAME")"

# Proje kök dizinini belirle (lib klasörünü ara)
find_project_root() {
    local cur_dir="$PWD"
    while [ "$cur_dir" != "/" ] && [ "$cur_dir" != "." ] && [ -n "$cur_dir" ]; do
        if [ -d "$cur_dir/lib" ]; then
            echo "$cur_dir"
            return 0
        fi
        # Üst klasördeki 20-EKIM-ODEV klasörünü kontrol et
        if [ -d "$cur_dir/20-EKIM-ODEV" ]; then
            if [ -d "$cur_dir/20-EKIM-ODEV/lib" ]; then
                echo "$cur_dir/20-EKIM-ODEV"
                return 0
            fi
        fi
        local parent_dir
        parent_dir="$(dirname "$cur_dir")"
        if [ "$parent_dir" = "$cur_dir" ]; then
            break
        fi
        cur_dir="$parent_dir"
    done
    # Bulunamazsa mevcut çalışma dizinini dön
    echo "$PWD"
}

PROJECT_ROOT="$(find_project_root)"
FEATURE_DIR="$PROJECT_ROOT/lib/features/$FEATURE_NAME"
TEST_DIR="$PROJECT_ROOT/test/features/$FEATURE_NAME"

echo -e "Hedef Proje Dizini: ${BOLD}$PROJECT_ROOT${NC}"
echo -e "Modül Adı:         ${GREEN}${BOLD}$FEATURE_NAME ($PASCAL_NAME)${NC}"
echo ""

# Klasörleri oluştur
mkdir -p "$FEATURE_DIR/controller"
mkdir -p "$FEATURE_DIR/models"
mkdir -p "$FEATURE_DIR/view"
mkdir -p "$FEATURE_DIR/widget"
mkdir -p "$TEST_DIR"

# 1. CONTROLLER OLUŞTUR
CONTROLLER_FILE="$FEATURE_DIR/controller/${FEATURE_NAME}_controller.dart"
if [ ! -f "$CONTROLLER_FILE" ]; then
    cat <<EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// TakeGO Standart ${PASCAL_NAME}Controller
///
/// Durum yönetimi saf [ValueNotifier] ile sağlanır.
/// Sayfa kapandığında mutlaka [dispose] çağrılmalıdır.
class ${PASCAL_NAME}Controller {
  /// Yükleme durumu
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// Hata veya bilgilendirme mesajı
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  /// Ana veri listesi bildiricisi
  final ValueNotifier<List<${PASCAL_NAME}Model>> itemsNotifier =
      ValueNotifier<List<${PASCAL_NAME}Model>>([]);

  /// İlk verileri yükle
  Future<void> loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      // Simüle veri yükleme
      await Future<void>.delayed(const Duration(milliseconds: 300));
      itemsNotifier.value = [
        ${PASCAL_NAME}Model(
          id: 'item-1',
          title: 'TakeGO Örnek Kayıt',
          createdAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      errorMessage.value = 'Veri yüklenirken hata oluştu: \$e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Yeni kayıt ekle
  void addItem(${PASCAL_NAME}Model item) {
    itemsNotifier.value = [item, ...itemsNotifier.value];
  }

  /// Bellek sızıntılarını önlemek için dinleyicileri serbest bırak
  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    itemsNotifier.dispose();
  }
}
EOF
    echo -e "  [+] Oluşturuldu: ${GREEN}$CONTROLLER_FILE${NC}"
else
    echo -e "  [.] Zaten mevcut: ${YELLOW}$CONTROLLER_FILE${NC}"
fi

# 2. MODEL OLUŞTUR
MODEL_FILE="$FEATURE_DIR/models/${FEATURE_NAME}_model.dart"
if [ ! -f "$MODEL_FILE" ]; then
    cat <<EOF > "$MODEL_FILE"
import 'package:flutter/foundation.dart';

/// TakeGO Standart Değişmez (Immutable) ${PASCAL_NAME}Model
@immutable
class ${PASCAL_NAME}Model {
  final String id;
  final String title;
  final DateTime createdAt;

  const ${PASCAL_NAME}Model({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  ${PASCAL_NAME}Model copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
  }) {
    return ${PASCAL_NAME}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ${PASCAL_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${PASCAL_NAME}Model &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
EOF
    echo -e "  [+] Oluşturuldu: ${GREEN}$MODEL_FILE${NC}"
else
    echo -e "  [.] Zaten mevcut: ${YELLOW}$MODEL_FILE${NC}"
fi

# 3. WIDGET (SABİT RESİM BOYUTLU KART) OLUŞTUR
WIDGET_FILE="$FEATURE_DIR/widget/${FEATURE_NAME}_card.dart"
if [ ! -f "$WIDGET_FILE" ]; then
    cat <<EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// TakeGO Sabit Görsel Oranlı ${PASCAL_NAME}Card
///
/// Kırmızı Çizgi Kuralı: İlan kartlarında 16:9 sabit görsel oranı korunmalı,
/// taşmaları önlemek için AspectRatio(16/9) veya sabit yükseklik kullanılmalıdır.
class ${PASCAL_NAME}Card extends StatelessWidget {
  final ${PASCAL_NAME}Model item;
  final VoidCallback? onTap;

  const ${PASCAL_NAME}Card({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SABİT 16:9 GÖRSEL ALANI
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: colors.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.directions_car_filled_outlined,
                    size: 48,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kayıt: \${item.createdAt.day}.\${item.createdAt.month}.\${item.createdAt.year}',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
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
EOF
    echo -e "  [+] Oluşturuldu: ${GREEN}$WIDGET_FILE${NC}"
else
    echo -e "  [.] Zaten mevcut: ${YELLOW}$WIDGET_FILE${NC}"
fi

# 4. VIEW (SAYFA) OLUŞTUR
VIEW_FILE="$FEATURE_DIR/view/${FEATURE_NAME}_view.dart"
if [ ! -f "$VIEW_FILE" ]; then
    cat <<EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controller/${FEATURE_NAME}_controller.dart';
import '../models/${FEATURE_NAME}_model.dart';
import '../widget/${FEATURE_NAME}_card.dart';

/// TakeGO ${PASCAL_NAME}View
///
/// [StatelessWidget] ve [ValueListenableBuilder] mimarisi ile
/// sadece durumun değiştiği arayüz bileşenleri yeniden çizilir.
class ${PASCAL_NAME}View extends StatelessWidget {
  final ${PASCAL_NAME}Controller controller;

  const ${PASCAL_NAME}View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TakeGO - ${PASCAL_NAME}'),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<List<${PASCAL_NAME}Model>>(
            valueListenable: controller.itemsNotifier,
            builder: (context, items, _) {
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Henüz kayıt bulunmuyor.',
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                );
              }

              return ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  return ${PASCAL_NAME}Card(item: items[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
EOF
    echo -e "  [+] Oluşturuldu: ${GREEN}$VIEW_FILE${NC}"
else
    echo -e "  [.] Zaten mevcut: ${YELLOW}$VIEW_FILE${NC}"
fi

# 5. TEST DOSYASI OLUŞTUR
TEST_FILE="$TEST_DIR/${FEATURE_NAME}_test.dart"
if [ ! -f "$TEST_FILE" ]; then
    cat <<EOF > "$TEST_FILE"
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Proje içi importlar için göreceli yollar
import '../../../lib/features/${FEATURE_NAME}/controller/${FEATURE_NAME}_controller.dart';
import '../../../lib/features/${FEATURE_NAME}/models/${FEATURE_NAME}_model.dart';
import '../../../lib/features/${FEATURE_NAME}/view/${FEATURE_NAME}_view.dart';
import '../../../lib/features/${FEATURE_NAME}/widget/${FEATURE_NAME}_card.dart';

void main() {
  group('${PASCAL_NAME} Unit & State Tests', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumları doğru tanımlanmalıdır', () {
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
      expect(controller.itemsNotifier.value, isEmpty);
    });

    test('loadInitialData sonrası veri listesi güncellenmelidir', () async {
      await controller.loadInitialData();
      expect(controller.itemsNotifier.value.isNotEmpty, isTrue);
      expect(controller.isLoading.value, isFalse);
    });

    test('addItem yeni kaydı listenin başına eklemelidir', () {
      final newItem = ${PASCAL_NAME}Model(
        id: 'test-123',
        title: 'Birim Test Kaydı',
        createdAt: DateTime.now(),
      );
      controller.addItem(newItem);
      expect(controller.itemsNotifier.value.first.id, equals('test-123'));
    });
  });

  group('${PASCAL_NAME} Widget Tests', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('View bileşeni hatasız çizilmelidir', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ${PASCAL_NAME}View(controller: controller),
        ),
      );

      expect(find.text('TakeGO - ${PASCAL_NAME}'), findsOneWidget);
    });

    testWidgets('Sabit oranlı 16:9 kart bileşeni taşma yapmadan çizilmelidir', (tester) async {
      final testItem = ${PASCAL_NAME}Model(
        id: 'card-1',
        title: 'Sabit Görsel Testi',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ${PASCAL_NAME}Card(item: testItem),
          ),
        ),
      );

      expect(find.text('Sabit Görsel Testi'), findsOneWidget);
      expect(find.byType(AspectRatio), findsOneWidget);
    });
  });
}
EOF
    echo -e "  [+] Oluşturuldu: ${GREEN}$TEST_FILE${NC}"
else
    echo -e "  [.] Zaten mevcut: ${YELLOW}$TEST_FILE${NC}"
fi

echo ""
echo -e "${GREEN}${BOLD}✔ '${FEATURE_NAME}' modülü başarıyla oluşturuldu!${NC}"
echo -e "Çalıştırılacak doğrulama komutları:"
echo -e "  ${CYAN}flutter analyze${NC}"
echo -e "  ${CYAN}flutter test $TEST_FILE${NC}"
echo -e "${CYAN}${BOLD}====================================================${NC}"
