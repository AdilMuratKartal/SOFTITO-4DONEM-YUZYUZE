#!/usr/bin/env bash
# ==============================================================================
# Randevu Sistemi Feature & Scaffold Oluşturucu (generate_feature.sh)
#
# Kullanım:
#   ./generate_feature.sh <feature_name>
#   Örnek:
#     ./generate_feature.sh appointment
#     ./generate_feature.sh listing
#     ./generate_feature.sh chat
#     ./generate_feature.sh --scaffold-all   (Tüm proje dizin ve JSON iskeletini kurar)
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
echo -e "${CYAN}${BOLD}   Randevu Platformu Feature & Scaffold Oluşturucu  ${NC}"
echo -e "${CYAN}${BOLD}====================================================${NC}"

# Proje kök dizinini belirle (lib klasörünü ara)
find_project_root() {
    local cur_dir="$PWD"
    while [ "$cur_dir" != "/" ] && [ "$cur_dir" != "." ] && [ -n "$cur_dir" ]; do
        if [ -d "$cur_dir/lib" ]; then
            echo "$cur_dir"
            return 0
        fi
        if [ -d "$cur_dir/21-EKIM" ]; then
            if [ -d "$cur_dir/21-EKIM/lib" ]; then
                echo "$cur_dir/21-EKIM"
                return 0
            fi
        fi
        cur_dir="$(dirname "$cur_dir")"
    done
    # Bulunamazsa mevcut dizin veya 21-EKIM kökü kabul edilir
    if [ -d "$PWD/21-EKIM" ]; then
        echo "$PWD/21-EKIM"
    else
        echo "$PWD"
    fi
}

PROJECT_ROOT="$(find_project_root)"
echo -e "${GREEN}Proje Çalışma Dizini:${NC} $PROJECT_ROOT"

# Tüm proje iskeletini oluşturma fonksiyonu
scaffold_all() {
    echo -e "${YELLOW}Proje temel klasör yapısı ve yerel JSON veri setleri oluşturuluyor...${NC}"
    
    mkdir -p "$PROJECT_ROOT/assets/data"
    mkdir -p "$PROJECT_ROOT/assets/images"
    mkdir -p "$PROJECT_ROOT/lib/core/constants"
    mkdir -p "$PROJECT_ROOT/lib/core/services"
    mkdir -p "$PROJECT_ROOT/lib/core/theme"
    mkdir -p "$PROJECT_ROOT/lib/models"
    mkdir -p "$PROJECT_ROOT/lib/providers"
    mkdir -p "$PROJECT_ROOT/lib/views/auth"
    mkdir -p "$PROJECT_ROOT/lib/views/customer"
    mkdir -p "$PROJECT_ROOT/lib/views/provider"
    mkdir -p "$PROJECT_ROOT/lib/views/shared/widgets"
    mkdir -p "$PROJECT_ROOT/test"

    # Örnek JSON veri setleri (Yoksa oluştur)
    if [ ! -f "$PROJECT_ROOT/assets/data/users.json" ]; then
        cat << 'EOF' > "$PROJECT_ROOT/assets/data/users.json"
[
  {
    "id": "usr-c1",
    "role": "customer",
    "name": "Ahmet Yılmaz",
    "email": "ahmet@example.com",
    "phone": "05551112233",
    "savedAddress": "Kadıköy Moda Caddesi No:12 D:4, İstanbul"
  },
  {
    "id": "usr-p1",
    "role": "provider",
    "name": "Mehmet Usta (Hızlı Tesisat)",
    "email": "mehmet@tesisat.com",
    "phone": "05329998877",
    "shopAddress": "Üsküdar Selimiye Mah. Usta Sok. No:5, İstanbul",
    "sector": "Tesisat"
  }
]
EOF
        echo -e "${GREEN}✓${NC} assets/data/users.json oluşturuldu."
    fi

    if [ ! -f "$PROJECT_ROOT/assets/data/listings.json" ]; then
        cat << 'EOF' > "$PROJECT_ROOT/assets/data/listings.json"
[
  {
    "id": "lst-001",
    "providerId": "usr-p1",
    "providerName": "Mehmet Usta (Hızlı Tesisat)",
    "title": "Ev & Ofis Su Tesisatı Tamiri",
    "sector": "Tesisat",
    "district": "Kadıköy / Üsküdar",
    "shopAddress": "Üsküdar Selimiye Mah. Usta Sok. No:5, İstanbul",
    "locationType": "her_ikisi",
    "basePrice": 350.0,
    "timeSlots": ["09:00", "10:30", "13:00", "15:00", "17:00"],
    "availableDays": ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma"]
  }
]
EOF
        echo -e "${GREEN}✓${NC} assets/data/listings.json oluşturuldu."
    fi

    if [ ! -f "$PROJECT_ROOT/assets/data/appointments.json" ]; then
        cat << 'EOF' > "$PROJECT_ROOT/assets/data/appointments.json"
[
  {
    "id": "apt-101",
    "listingId": "lst-001",
    "customerId": "usr-c1",
    "providerId": "usr-p1",
    "serviceTitle": "Mutfak Bataryası Değişimi",
    "description": "Su sızdırıyor, yeni batarya takılacak.",
    "appointmentDate": "2026-10-22",
    "appointmentTime": "10:30",
    "offeredPrice": 400.0,
    "locationType": "sen_gel",
    "address": "Kadıköy Moda Caddesi No:12 D:4, İstanbul",
    "status": "beklemede",
    "lastOfferBy": "customer",
    "createdAt": "2026-10-21T10:00:00Z"
  }
]
EOF
        echo -e "${GREEN}✓${NC} assets/data/appointments.json oluşturuldu."
    fi

    if [ ! -f "$PROJECT_ROOT/assets/data/messages.json" ]; then
        cat << 'EOF' > "$PROJECT_ROOT/assets/data/messages.json"
[
  {
    "id": "msg-001",
    "appointmentId": "apt-101",
    "senderId": "usr-c1",
    "message": "Merhaba usta, bataryayı siz mi temin ediyorsunuz?",
    "timestamp": "10:05",
    "createdAt": "2026-10-21T10:05:00Z"
  }
]
EOF
        echo -e "${GREEN}✓${NC} assets/data/messages.json oluşturuldu."
    fi

    echo -e "${GREEN}${BOLD}Tüm proje iskeleti başarıyla hazırlandı!${NC}"
    exit 0
}

# Parametre kontrolü
FEATURE_NAME="${1:-}"

if [ "$FEATURE_NAME" == "--scaffold-all" ] || [ "$FEATURE_NAME" == "-all" ]; then
    scaffold_all
fi

if [ -z "$FEATURE_NAME" ]; then
    echo -e "${YELLOW}Bir modül adı belirtilmedi.${NC}"
    read -rp "Oluşturulacak modül adını giriniz (örn: appointment, listing, chat veya 'all'): " FEATURE_NAME
fi

if [ "$FEATURE_NAME" == "all" ] || [ "$FEATURE_NAME" == "--scaffold-all" ]; then
    scaffold_all
fi

# Küçük harfe çevir ve geçersiz karakterleri temizle
FEATURE_NAME="$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')"

if [[ ! "$FEATURE_NAME" =~ ^[a-z0-9_]+$ ]]; then
    echo -e "${RED}HATA: Modül adı yalnızca küçük harf, rakam ve alt çizgi (_) içerebilir.${NC}"
    exit 1
fi

to_pascal_case() {
    echo "$1" | awk -F_ '{for(i=1;i<=NF;i++) printf "%s", toupper(substr($i,1,1)) substr($i,2)}'
}

PASCAL_NAME="$(to_pascal_case "$FEATURE_NAME")"

echo -e "${CYAN}Modül Oluşturuluyor:${NC} $FEATURE_NAME (${PASCAL_NAME})"

MODEL_DIR="$PROJECT_ROOT/lib/models"
PROVIDER_DIR="$PROJECT_ROOT/lib/providers"
VIEW_DIR="$PROJECT_ROOT/lib/views/$FEATURE_NAME"
WIDGET_DIR="$PROJECT_ROOT/lib/views/shared/widgets"
TEST_DIR="$PROJECT_ROOT/test"

mkdir -p "$MODEL_DIR" "$PROVIDER_DIR" "$VIEW_DIR" "$WIDGET_DIR" "$TEST_DIR"

# 1. Model Dosyası
MODEL_FILE="$MODEL_DIR/${FEATURE_NAME}_model.dart"
if [ ! -f "$MODEL_FILE" ]; then
    cat << EOF > "$MODEL_FILE"
import 'package:flutter/foundation.dart';

@immutable
class ${PASCAL_NAME}Model {
  final String id;
  final String title;
  final String status;
  final DateTime createdAt;

  const ${PASCAL_NAME}Model({
    required this.id,
    required this.title,
    this.status = 'beklemede',
    required this.createdAt,
  });

  ${PASCAL_NAME}Model copyWith({
    String? id,
    String? title,
    String? status,
    DateTime? createdAt,
  }) {
    return ${PASCAL_NAME}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ${PASCAL_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'beklemede',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
EOF
    echo -e "${GREEN}✓${NC} $MODEL_FILE oluşturuldu."
fi

# 2. Provider Dosyası
PROVIDER_FILE="$PROVIDER_DIR/${FEATURE_NAME}_provider.dart"
if [ ! -f "$PROVIDER_FILE" ]; then
    cat << EOF > "$PROVIDER_FILE"
import 'package:flutter/material.dart';
import '../models/${FEATURE_NAME}_model.dart';

class ${PASCAL_NAME}Provider extends ChangeNotifier {
  List<${PASCAL_NAME}Model> _items = [];
  bool _isLoading = false;

  List<${PASCAL_NAME}Model> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  void addItem(${PASCAL_NAME}Model item) {
    _items = [item, ..._items];
    notifyListeners();
  }

  void updateStatus(String id, String newStatus) {
    _items = _items.map((item) {
      if (item.id == id) {
        return item.copyWith(status: newStatus);
      }
      return item;
    }).toList();
    notifyListeners();
  }
}
EOF
    echo -e "${GREEN}✓${NC} $PROVIDER_FILE oluşturuldu."
fi

# 3. View Dosyası
VIEW_FILE="$VIEW_DIR/${FEATURE_NAME}_screen.dart"
if [ ! -f "$VIEW_FILE" ]; then
    cat << EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ${PASCAL_NAME}Screen extends StatelessWidget {
  const ${PASCAL_NAME}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('${PASCAL_NAME} Modülü'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text(
            '${PASCAL_NAME} Ekranı Hazır',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
EOF
    echo -e "${GREEN}✓${NC} $VIEW_FILE oluşturuldu."
fi

echo -e "\n${GREEN}${BOLD}Başarılı!${NC} $FEATURE_NAME modülü oluşturuldu."
echo -e "Şimdi şu komutlarla kontrol edebilirsin:"
echo -e "  ${CYAN}flutter analyze${NC}"
echo -e "  ${CYAN}flutter test${NC}"
EOF
