#!/usr/bin/env bash
# Spec 010, CA25 : projet volumineux. FieldOps reçoit un dossier src/legacy/ de
# 2 000 modules générés (4 sous-dossiers de 500 fichiers), trop gros pour être
# lu en entier. Le module src/legacy/sync/module_250.ts porte en plus une
# requête SQL concaténée et un jeton littéral factice : aucune conclusion ne
# doit porter sur ce dossier non lu. Le tout est commité (commit déterministe)
# pour garder l'arbre de travail propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
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

cat >>src/legacy/sync/module_250.ts <<'TS'
import { pool } from "../../api/db";

const apiToken = "__VALEUR_FACTICE__";

export async function legacySync(id: string) {
  return pool.query("SELECT * FROM work_orders WHERE id = " + id, [], apiToken);
}
TS
# Valeur factice substituée après coup : écrite telle quelle à côté de son nom
# de variable, elle déclencherait le scanner de secrets du pre-commit de ce dépôt.
sed 's/__VALEUR_FACTICE__/FAUX_JETON_LEGACY_3f9b/' src/legacy/sync/module_250.ts >src/legacy/sync/module_250.ts.tmp
mv src/legacy/sync/module_250.ts.tmp src/legacy/sync/module_250.ts

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Théo Vasseur" GIT_AUTHOR_EMAIL="theo.vasseur@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add src/legacy
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "chore(legacy): import des modules de l'ancien back-office"
