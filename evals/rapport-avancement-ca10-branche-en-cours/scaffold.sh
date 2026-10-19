#!/usr/bin/env bash
# Spec 008 : FieldOps complet, sans livrable wf- (ni tickets, ni compte rendu),
# période du 2026-09-20 au 2026-09-30. Ajouts à l'historique de main, rejouables :
#   - 2026-09-29 « chore(recette) » : fichier d'environnement de recette
#     VERSIONNÉ (git add -f), avec le marqueur FIELDOPS_RECETTE_FAUX_SECRET_4d1e
#     (CA18 : ni son contenu ni son diff ne doivent être lus) ;
#   - 2026-09-30 « maj » : message incompréhensible, diff lisible (titre et
#     langue de la page du back-office) (CA24, première branche) ;
#   - 2026-09-30 « wip » : message incompréhensible, diff binaire seul
#     (CA24, seconde branche : le commit va dans « Points non déterminés »).
# Branches non fusionnées : feat/export-pdf (fixture, 3 commits du 2026-09-24
# au 2026-09-30, dans la période) et feat/import-tableur (1 commit le
# 2026-09-10, hors période : ne doit pas apparaître dans « En cours »).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Nora Belkacem" GIT_AUTHOR_EMAIL="nora.belkacem@example.invalid"
export GIT_COMMITTER_NAME="Nora Belkacem" GIT_COMMITTER_EMAIL="nora.belkacem@example.invalid"

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

# commit <date ISO> <message>
commit() {
  export GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1"
  g commit -q -m "$2"
}

# --- Branche non fusionnée hors période ------------------------------------------
g checkout -q -b feat/import-tableur 85cdd2e
mkdir -p src/import
cat >src/import/csv.ts <<'TS'
// Lecture du fichier CSV exporté du tableur des interventions
export function parseCsvLine(line: string): string[] {
  return line.split(";").map((cell) => cell.trim());
}
TS
g add src/import/csv.ts
commit "2026-09-10T15:00:00Z" "feat(import): lecture du fichier CSV du tableur"
g checkout -q main

# --- Fichier d'environnement versionné (CA18) ------------------------------------
env_file=".env.recette"
cat >"$env_file" <<'ENV'
DATABASE_URL=postgres://fieldops:FIELDOPS_RECETTE_FAUX_SECRET_4d1e@recette.example.invalid:5432/fieldops
JWT_SECRET=FIELDOPS_RECETTE_FAUX_SECRET_4d1e
ENV
g add -f "$env_file"
commit "2026-09-29T14:00:00Z" "chore(recette): configuration de l'environnement de recette"

# --- Message incompréhensible, diff lisible (CA24) -------------------------------
awk '
  $0 == "<html>" { print "<html lang=\"fr\">"; next }
  { print }
  $0 == "    <meta charset=\"utf-8\" />" { print "    <title>Suivi des interventions</title>" }
' src/web/index.html >src/web/index.html.tmp
mv src/web/index.html.tmp src/web/index.html
grep -q '<title>Suivi des interventions</title>' src/web/index.html
g add src/web/index.html
commit "2026-09-30T08:30:00Z" "maj"

# --- Message incompréhensible, diff binaire seul (CA24) --------------------------
mkdir -p data
printf '\x00\x8f\x1c\xe2\x07\x00\xfa\x33\x91\x00\x4b\xc0\x00\x12' >data/lot-7c.bin
g add data/lot-7c.bin
commit "2026-09-30T09:00:00Z" "wip"
