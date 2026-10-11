#!/usr/bin/env bash
# Spec 001, CA16 : clone superficiel de FieldOps (5 derniers commits de main,
# du 2026-08-26 au 2026-09-29). Le premier commit réel (2025-08-04) est hors de
# l'historique disponible.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
source_dir="$(mktemp -d)/fieldops"
bash "$repo/tests/fixtures/build-fieldops.sh" --no-secret "$source_dir"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
git clone -q --depth 5 --branch main "file://$source_dir" "$PWD"
