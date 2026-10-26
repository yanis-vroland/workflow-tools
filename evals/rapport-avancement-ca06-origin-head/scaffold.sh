#!/usr/bin/env bash
# Spec 008, CA6 : clone de FieldOps dont la branche par défaut du dépôt distant
# s'appelle « principale » (origin/HEAD -> origin/principale). Une branche locale
# « main » existe aussi, restée sur v1.0.0 (2025-12-05) : l'outil doit suivre
# origin/HEAD et non ce nom. La branche feat/export-pdf n'est connue que comme
# branche distante (origin/feat/export-pdf).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
source_dir="$(mktemp -d)/fieldops"
bash "$repo/tests/fixtures/build-fieldops.sh" --no-secret "$source_dir"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
git -C "$source_dir" branch -m main principale

git clone -q "file://$source_dir" "$PWD"
git branch main v1.0.0
