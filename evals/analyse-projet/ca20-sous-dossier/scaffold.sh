#!/usr/bin/env bash
# Spec 001, CA20 : projet lancé depuis un sous-dossier d'un dépôt git.
#
# Le répertoire de la session ($PWD) est imposé par claude plugin eval, et le
# scaffold n'écrit rien au-dessus. Le dépôt est donc construit avec
# core.worktree : son répertoire git est $PWD/.git, mais sa racine de travail
# est le dossier parent, dont $PWD est le sous-dossier « <nom de $PWD>/ ». Pour
# git, la session tourne bien dans un sous-dossier (git rev-parse --show-prefix
# non vide), comme dans un monorepo. Seul ce sous-dossier est extrait
# (sparse-checkout) et le reste du dossier parent est ignoré (.git/info/exclude).
#
# Historique : celui de FieldOps (build-fieldops.sh, sans fichier
# d'environnement), réécrit sous le préfixe « <nom de $PWD>/ », suivi de 12
# commits plus récents d'une autre équipe dans plateforme/, hors du
# sous-dossier :
#   - le dernier commit du dépôt (HEAD, 2026-10-06) n'est pas le dernier commit
#     du sous-dossier (2026-09-29) ;
#   - plateforme/deploy-commun.sh (12 commits) serait le fichier le plus modifié
#     si l'activité n'était pas limitée au sous-dossier ;
#   - une cinquième autrice, Inès Carmo, n'a jamais modifié le sous-dossier
#     (4 contributeurs attendus).
# Les hash dépendent du nom de $PWD : aucun correcteur ne les fige.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
here="$(pwd -P)"
parent="$(dirname "$here")"
prefix="$(basename "$here")"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export FILTER_BRANCH_SQUELCH_WARNING=1
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false \
    -c advice.detachedHead=false "$@"
}

# --- Dépôt de construction, hors de $PWD ------------------------------------------
build="$(mktemp -d)"
bash "$repo/tests/fixtures/build-fieldops.sh" --no-secret "$build/mono" >/dev/null
cd "$build/mono"

# FieldOps déplacé sous <prefix>/, historique compris (le filtre est évalué par
# git filter-branch, d'où les guillemets simples)
export PREFIX="$prefix"
# shellcheck disable=SC2016
g filter-branch -f --index-filter '
  git ls-files -s \
    | awk -v p="$PREFIX" '"'"'BEGIN { FS = OFS = "\t" } { $2 = p "/" $2; print }'"'"' \
    | GIT_INDEX_FILE="$GIT_INDEX_FILE.new" git update-index --index-info \
    && mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"
' -- main >/dev/null

# Commits d'une autre équipe, hors du sous-dossier
export GIT_AUTHOR_NAME="Inès Carmo" GIT_AUTHOR_EMAIL="ines.carmo@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
mkdir -p plateforme
printf '#!/usr/bin/env bash\n# Déploiement commun des applications du dépôt\nset -euo pipefail\n' \
  >plateforme/deploy-commun.sh
for i in $(seq 1 12); do
  day=$(((i + 1) / 2))
  hour=$((14 - i % 2 * 6))
  GIT_AUTHOR_DATE=$(printf '2026-10-%02dT%02d:00:00Z' "$day" "$hour")
  export GIT_AUTHOR_DATE GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE"
  printf 'echo "étape %s"\n' "$i" >>plateforme/deploy-commun.sh
  g add plateforme/deploy-commun.sh
  g commit -q -m "chore(plateforme): étape $i du déploiement commun"
done
cd "$here"

# --- Dépôt final : répertoire git dans $PWD, racine de travail au-dessus -------------
g init -q -b main
g config core.worktree "$parent"
g config core.sparseCheckout true
printf '/%s/\n' "$prefix" >.git/info/sparse-checkout
printf '/*\n!/%s/\n' "$prefix" >>.git/info/exclude
g fetch -q "$build/mono" main
g checkout -q -f -B main FETCH_HEAD

chmod -R u+w "$build"
rm -r "$build"

# --- Contrôles ------------------------------------------------------------------
[ "$(g rev-parse --show-prefix)" = "$prefix/" ] || {
  echo "Erreur interne : $PWD n'est pas un sous-dossier du dépôt." >&2
  exit 1
}
[ -z "$(g status --porcelain)" ] || {
  echo "Erreur interne : arbre de travail non propre." >&2
  g status --short >&2
  exit 1
}
[ -f src/api/routes/interventions.ts ] && [ ! -e "$parent/plateforme" ] || {
  echo "Erreur interne : extraction partielle incorrecte." >&2
  exit 1
}
