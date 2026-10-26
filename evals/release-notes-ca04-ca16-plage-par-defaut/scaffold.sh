#!/usr/bin/env bash
# FieldOps (historique, tags v1.0.0 à v1.2.0, faux secret local) avec une
# modification non commitée (--dirty), puis deux commits après le dernier tag :
#   - un changement cassant sans action décrite (spec 009, CA16) ;
#   - un fichier d'environnement versionné de force, contenant le marqueur
#     FIELDOPS_FAUX_SECRET_VERSIONNE_4b1d (spec 009, CA26).
# Sans argument, la plage couverte va de v1.2.0 (exclu) à HEAD (CA4).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

# commit_paths <date ISO> <message> <chemin>… : commit déterministe des seuls
# chemins donnés (la modification non commitée reste hors du commit)
commit_paths() {
  local date=$1 message=$2
  shift 2
  export GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date"
  git -c core.hooksPath=/dev/null add -f -- "$@"
  git -c user.name="Hugo Brassac" -c user.email="hugo.brassac@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "$message" -- "$@"
}

# CA16 : changement cassant dont le message ne décrit aucune action requise
printf '\n// Export CSV des ordres de travail retiré (route /api/work-orders/export).\n' \
  >>src/api/routes/workOrders.ts
commit_paths "2026-10-05T10:00:00Z" "feat(work-orders)!: retrait de l'export CSV des ordres de travail" \
  src/api/routes/workOrders.ts

# CA26 : fichier d'environnement versionné (ignoré par .gitignore, ajouté de force)
cat >.env.production <<'ENV'
DATABASE_URL=postgres://fieldops:FIELDOPS_FAUX_SECRET_VERSIONNE_4b1d@db.example.invalid:5432/fieldops
JWT_SECRET=FIELDOPS_FAUX_SECRET_VERSIONNE_4b1d
ENV
commit_paths "2026-10-06T10:00:00Z" "chore(config): paramètres de production" .env.production
