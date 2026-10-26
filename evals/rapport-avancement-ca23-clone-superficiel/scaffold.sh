#!/usr/bin/env bash
# Spec 008, CA23 : clone superficiel de FieldOps (3 derniers commits de main,
# du 2026-09-22 au 2026-09-29). La période demandée commence le 2026-09-01 :
# l'historique disponible ne la couvre qu'à partir du 2026-09-22 (le commit du
# 2026-09-08 est absent du clone).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
source_dir="$(mktemp -d)/fieldops"
bash "$repo/tests/fixtures/build-fieldops.sh" --no-secret "$source_dir"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
git clone -q --depth 3 --branch main "file://$source_dir" "$PWD"
