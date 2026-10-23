#!/usr/bin/env bash
# ==============================================================================
# generate_feature.sh - Alışkanlık Takip Uygulaması Feature İskelet Üretici
# ==============================================================================
# Kullanım:
#   bash generate_feature.sh <feature_name>
# Örnek:
#   bash generate_feature.sh habit
#   bash generate_feature.sh category
# ==============================================================================

set -e

if [ -z "$1" ]; then
  echo "Hata: Lütfen bir modül (feature) adı belirtin!"
  echo "Kullanım: bash generate_feature.sh <feature_name>"
  exit 1
fi

FEATURE_NAME=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
FEATURE_PASCAL=$(echo "$FEATURE_NAME" | perl -pe 's/(^|_)./uc($&)/ge;s/_//g')

BASE_DIR="lib/features"
CONTROLLER_DIR="${BASE_DIR}/controllers"
MODEL_DIR="${BASE_DIR}/models"
VIEW_DIR="${BASE_DIR}/views"
WIDGET_DIR="${BASE_DIR}/widgets"

echo "==> '${FEATURE_NAME}' (${FEATURE_PASCAL}) için modül dizinleri kontrol ediliyor..."
mkdir -p "${CONTROLLER_DIR}" "${MODEL_DIR}" "${VIEW_DIR}" "${WIDGET_DIR}"

# 1. Model Dosyası
MODEL_FILE="${MODEL_DIR}/${FEATURE_NAME}_model.dart"
if [ ! -f "${MODEL_FILE}" ]; then
  cat <<EOF > "${MODEL_FILE}"
import 'package:flutter/foundation.dart';

@immutable
class ${FEATURE_PASCAL}Model {
  final String id;
  final String title;
  final String categoryId;
  final String iconPath;
  final List<int> selectedDays; // [1..7]
  final String startTime;
  final String endTime;
  final bool hasReminder;
  final bool isCompleted;
  final int streakDays;
  final DateTime createdAt;

  const ${FEATURE_PASCAL}Model({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.iconPath,
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7],
    required this.startTime,
    required this.endTime,
    this.hasReminder = false,
    this.isCompleted = false,
    this.streakDays = 0,
    required this.createdAt,
  });

  ${FEATURE_PASCAL}Model copyWith({
    String? title,
    String? categoryId,
    String? iconPath,
    List<int>? selectedDays,
    String? startTime,
    String? endTime,
    bool? hasReminder,
    bool? isCompleted,
    int? streakDays,
  }) {
    return ${FEATURE_PASCAL}Model(
      id: id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      iconPath: iconPath ?? this.iconPath,
      selectedDays: selectedDays ?? this.selectedDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hasReminder: hasReminder ?? this.hasReminder,
      isCompleted: isCompleted ?? this.isCompleted,
      streakDays: streakDays ?? this.streakDays,
      createdAt: createdAt,
    );
  }
}
EOF
  echo " -> Model oluşturuldu: ${MODEL_FILE}"
else
  echo " -> Model zaten mevcut: ${MODEL_FILE}"
fi

# 2. Controller Dosyası (ValueNotifier Mimarisi)
CONTROLLER_FILE="${CONTROLLER_DIR}/${FEATURE_NAME}_controller.dart"
if [ ! -f "${CONTROLLER_FILE}" ]; then
  cat <<EOF > "${CONTROLLER_FILE}"
import 'package:flutter/material.dart';
import '../models/${FEATURE_NAME}_model.dart';

class ${FEATURE_PASCAL}Controller {
  final ValueNotifier<List<${FEATURE_PASCAL}Model>> itemsNotifier =
      ValueNotifier<List<${FEATURE_PASCAL}Model>>([]);
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String> selectedFilterNotifier = ValueNotifier<String>('all');

  void addItem(${FEATURE_PASCAL}Model item) {
    itemsNotifier.value = [...itemsNotifier.value, item];
  }

  void deleteItem(String id) {
    itemsNotifier.value = itemsNotifier.value.where((element) => element.id != id).toList();
  }

  void toggleItem(String id) {
    itemsNotifier.value = itemsNotifier.value.map((element) {
      if (element.id == id) {
        final newCompleted = !element.isCompleted;
        final newStreak = newCompleted ? element.streakDays + 1 : (element.streakDays > 0 ? element.streakDays - 1 : 0);
        return element.copyWith(
          isCompleted: newCompleted,
          streakDays: newStreak,
        );
      }
      return element;
    }).toList();
  }

  void setFilter(String filter) {
    selectedFilterNotifier.value = filter;
  }

  void dispose() {
    itemsNotifier.dispose();
    isLoadingNotifier.dispose();
    selectedFilterNotifier.dispose();
  }
}
EOF
  echo " -> Controller oluşturuldu: ${CONTROLLER_FILE}"
else
  echo " -> Controller zaten mevcut: ${CONTROLLER_FILE}"
fi

# 3. View Dosyası
VIEW_FILE="${VIEW_DIR}/${FEATURE_NAME}_view.dart"
if [ ! -f "${VIEW_FILE}" ]; then
  cat <<EOF > "${VIEW_FILE}"
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/${FEATURE_NAME}_controller.dart';
import '../models/${FEATURE_NAME}_model.dart';

class ${FEATURE_PASCAL}View extends StatefulWidget {
  const ${FEATURE_PASCAL}View({super.key});

  @override
  State<${FEATURE_PASCAL}View> createState() => _${FEATURE_PASCAL}ViewState();
}

class _${FEATURE_PASCAL}ViewState extends State<${FEATURE_PASCAL}View> {
  late final ${FEATURE_PASCAL}Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = ${FEATURE_PASCAL}Controller();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${FEATURE_PASCAL} Takibi'),
      ),
      body: ValueListenableBuilder<List<${FEATURE_PASCAL}Model>>(
        valueListenable: _controller.itemsNotifier,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('Henüz veri bulunmuyor.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text('\${item.startTime} - \${item.endTime}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                  onPressed: () => _controller.deleteItem(item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
EOF
  echo " -> View oluşturuldu: ${VIEW_FILE}"
else
  echo " -> View zaten mevcut: ${VIEW_FILE}"
fi

echo "==> '${FEATURE_NAME}' iskelet üretimi başarıyla tamamlandı!"
