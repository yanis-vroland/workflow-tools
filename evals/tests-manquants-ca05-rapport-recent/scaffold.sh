#!/usr/bin/env bash
# Spec 012, CA5, variante : FieldOps complet avec un rapport de couverture web
# (coverage/coverage-summary.json, ignoré par git) produit au lancement de
# l'eval, donc postérieur au dernier commit (2026-09-29). Le livrable l'exploite
# sans le dire antérieur au dernier commit. Arbre de travail propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p coverage
cat >coverage/coverage-summary.json <<'JSON'
{
  "total": {
    "lines": { "total": 22, "covered": 18, "skipped": 0, "pct": 81.82 },
    "branches": { "total": 8, "covered": 5, "skipped": 0, "pct": 62.5 }
  },
  "src/domain/invoice.ts": {
    "lines": { "total": 22, "covered": 18, "skipped": 0, "pct": 81.82 },
    "branches": { "total": 8, "covered": 5, "skipped": 0, "pct": 62.5 }
  }
}
JSON

if [ -n "$(git status --porcelain)" ]; then
  echo "Arbre de travail non propre après le scaffold." >&2
  git status --short >&2
  exit 1
fi
