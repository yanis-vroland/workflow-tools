#!/usr/bin/env bash
# Spec 011, CA27 : projet volumineux. FieldOps web seul reçoit un dossier
# src/web/legacy/ de 2 000 composants React générés (4 sous-dossiers de 500
# fichiers), trop nombreux pour être lus dans la limite de tours du cas. Le tout
# est commité (commit déterministe) pour garder l'arbre de travail propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"

for area in contrats devis equipes stocks; do
  mkdir -p "src/web/legacy/$area"
  for i in $(seq -w 1 500); do
    {
      printf 'import React from "react";\n\n'
      printf '// Écran historique %s %s, repris de l'"'"'ancien back-office\n\n' "$area" "$i"
      printf 'export function Ecran%s({ rows }: { rows: string[] }) {\n' "$i"
      printf '  return (\n    <section>\n      <h2>%s %s</h2>\n' "$area" "$i"
      printf '      <ul>\n        {rows.map((row) => (\n          <li key={row}>{row}</li>\n        ))}\n      </ul>\n'
      printf '    </section>\n  );\n}\n'
    } >"src/web/legacy/$area/Ecran$i.tsx"
  done
done

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Théo Vasseur" GIT_AUTHOR_EMAIL="theo.vasseur@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-02T10:00:00Z" GIT_COMMITTER_DATE="2026-10-02T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add src/web/legacy
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "chore(legacy): import des écrans de l'ancien back-office"
