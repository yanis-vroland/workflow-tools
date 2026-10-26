#!/usr/bin/env bash
# FieldOps avec un livrable docs/wf/release-notes.md déjà commité
# (donnees/release-notes-precedent.md) : sections 1.2.0 (périmée : « Export
# Excel des factures », absent de l'historique), 1.1.0 (retouchée à la main) et
# 1.0.0 (spec 009, CA17). La relance pour la plage v1.1.0..v1.2.0 produit la
# version 1.2.0 (package.json) : sa section est mise à jour, les autres restent
# identiques octet pour octet.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

mkdir -p docs/wf
cp "$case_dir/donnees/release-notes-precedent.md" docs/wf/release-notes.md
export GIT_AUTHOR_DATE="2026-10-02T10:00:00Z" GIT_COMMITTER_DATE="2026-10-02T10:00:00Z"
git -c core.hooksPath=/dev/null add -- docs/wf/release-notes.md
git -c user.name="Hugo Brassac" -c user.email="hugo.brassac@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false \
  commit -q -m "docs: notes de version (wf-release-notes)"
