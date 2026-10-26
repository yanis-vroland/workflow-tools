#!/usr/bin/env bash
# Spec 008, CA4 (bornes et fuseaux) et sécurité des commandes git.
#
# FieldOps complet, puis quatre commits sur main autour de la période demandée
# (2026-10-01 au 2026-10-05), datés dans des fuseaux décalés. Seule la date de
# commit écrite dans le commit (%cs) compte, quel que soit le fuseau de la
# machine :
#   A 2026-10-01T00:30+09:00 (%cs 10-01, 09-30 en UTC)   -> dans la période
#   B 2026-09-30T23:30-05:00 (%cs 09-30, 10-01 en UTC)   -> hors période
#   D 2026-10-06T00:30+09:00 (%cs 10-06, 10-05 en UTC)   -> hors période
#   C 2026-10-05T23:30-08:00 (%cs 10-05, 10-06 en UTC)   -> dans la période
# (ordre de l'historique : A, B, D, C, chronologique en UTC).
#
# Deux branches non fusionnées aux noms piégés, chacune avec un commit dans la
# période : x'$(touch${IFS}pwned)' (apostrophe et substitution de commande) et
# --output=pwned.txt (option git, créée par update-ref, git branch la
# refusant). Aucune ne doit être insérée dans une commande : aucun fichier
# pwned ne doit apparaître.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Hugo Brassac" GIT_AUTHOR_EMAIL="hugo.brassac@example.invalid"
export GIT_COMMITTER_NAME="Hugo Brassac" GIT_COMMITTER_EMAIL="hugo.brassac@example.invalid"

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

# commit <date ISO avec fuseau> <fichier> <ligne> <message>
commit() {
  export GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1"
  mkdir -p "$(dirname "$2")"
  printf '%s\n' "$3" >>"$2"
  g add -- "$2"
  g commit -q -m "$4"
}

commit "2026-10-01T00:30:00+09:00" src/web/pages/Agenda.tsx \
  "export const AGENDA_TITLE = \"Agenda de la semaine\";" \
  "feat(agenda): vue de la semaine dans le back-office"
commit "2026-09-30T23:30:00-05:00" src/web/pages/Agenda.tsx \
  "export const AGENDA_COLORS = [\"#2a7\", \"#c33\"];" \
  "feat(agenda): couleurs des créneaux"
commit "2026-10-06T00:30:00+09:00" src/web/pages/Agenda.tsx \
  "export const AGENDA_PRINT = true;" \
  "feat(agenda): impression de l'agenda"
commit "2026-10-05T23:30:00-08:00" src/web/pages/Agenda.tsx \
  "export const AGENDA_WEEKEND = false;" \
  "feat(agenda): masquage des fins de semaine"

base=$(g rev-parse HEAD)

# Branche au nom piégé (apostrophe, substitution de commande)
trap_name="x'\$(touch\${IFS}pwned)'"
g checkout -q -b "$trap_name" "$base"
commit "2026-10-02T10:00:00Z" src/web/pages/Map.tsx \
  "export const MAP_ZOOM = 12;" \
  "feat(carte): zoom par défaut de la carte"
g checkout -q main

# Branche dont le nom est une option git (refusée par git branch)
option_ref="refs/heads/--output=pwned.txt"
g checkout -q --detach "$base"
commit "2026-10-03T10:00:00Z" src/web/pages/Export.tsx \
  "export const EXPORT_FORMAT = \"csv\";" \
  "feat(export): format d'export par défaut"
g update-ref "$option_ref" HEAD
g checkout -q main

[ -z "$(g status --porcelain)" ]
