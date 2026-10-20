#!/usr/bin/env bash
# ==============================================================================
# iJournal - Theme System Script Router & Safe Delegate
#
# DİKKAT:
# Özellik (feature) iskeleti oluşturma sorumluluğu "feature-scaffold" yeteneğine
# aittir: (.agents/skills/feature-scaffold/script/generate_feature.sh)
#
# Tema sisteminin kendi kurulum scripti ise:
# (.agents/skills/theme-system/script/setup_theme_core.sh)
#
# Bu dosya, olası çakışmaları ve yanlış çalıştırmaları önlemek amacıyla
# akıllı yönlendirme (routing/delegation) yapar.
# ==============================================================================

set -euo pipefail

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FEATURE_SCAFFOLD_SCRIPT="${SCRIPT_DIR}/../../feature-scaffold/script/generate_feature.sh"
THEME_CORE_SCRIPT="${SCRIPT_DIR}/setup_theme_core.sh"

echo -e "${BLUE}======================================================${NC}"
echo -e "${YELLOW}[BİLGİ] theme-system/script/generate_feature.sh çağrıldı.${NC}"
echo -e "${BLUE}======================================================${NC}"

if [ $# -ge 1 ]; then
  echo -e "Özellik oluşturma isteği algılandı: ${GREEN}$1${NC}"
  echo -e "İşlem yetkili betiğe devrediliyor: ${YELLOW}feature-scaffold/script/generate_feature.sh${NC}\n"
  
  if [ -f "${FEATURE_SCAFFOLD_SCRIPT}" ]; then
    bash "${FEATURE_SCAFFOLD_SCRIPT}" "$@"
    exit 0
  else
    echo -e "${RED}[HATA] ${FEATURE_SCAFFOLD_SCRIPT} bulunamadı!${NC}"
    exit 1
  fi
else
  echo -e "${YELLOW}Kullanım Seçenekleri:${NC}"
  echo -e "1) Yeni bir modül/ekran iskeleti üretmek için:"
  echo -e "   ${GREEN}$0 <feature_name>${NC} (ör. $0 timeline)"
  echo -e "   -> Otomatik olarak feature-scaffold yeteneğini çalıştırır.\n"
  echo -e "2) Tema çekirdek altyapısını kurmak için:"
  echo -e "   ${GREEN}${THEME_CORE_SCRIPT}${NC}\n"
fi
