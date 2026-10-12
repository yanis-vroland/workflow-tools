#!/usr/bin/env bash
# Spec 001, CA18 : projet volumineux. FieldOps reçoit un dossier src/legacy/ de
# 2 000 modules générés (4 sous-dossiers de 500 fichiers, environ 236 000 lignes),
# trop gros pour être lu en entier dans la limite de tours du cas. Le tout est
# commité (commit déterministe) pour garder l'arbre de travail propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

for area in billing routing reports sync; do
  mkdir -p "src/legacy/$area"
  for i in $(seq -w 1 500); do
    {
      printf '// Module historique %s %s, repris de l'"'"'ancien back-office\n\n' "$area" "$i"
      for j in $(seq 1 29); do
        printf 'export function %s%s_%s(value: number): number {\n  return value * %s;\n}\n\n' \
          "$area" "$i" "$j" "$j"
      done
    } >"src/legacy/$area/module_$i.ts"
  done
done

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Théo Vasseur" GIT_AUTHOR_EMAIL="theo.vasseur@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add src/legacy
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "chore(legacy): import des modules de l'ancien back-office"
