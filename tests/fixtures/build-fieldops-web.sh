#!/usr/bin/env bash
# Variante « web seul » de FieldOps : construit la fixture avec son historique
# (build-fieldops.sh), puis retire l'application compagnon Flutter (mobile/) et
# les mentions correspondantes du README, dans un commit déterministe.
# Le projet obtenu n'est plus un monorepo (spec 002, CA9 et CA12).
#
# Usage : bash tests/fixtures/build-fieldops-web.sh [--dirty] [--no-secret] <destination>
#
# Les options sont transmises à build-fieldops.sh. Avec --dirty, la modification
# non commitée de src/domain/scheduling.ts reste hors du commit de retrait : le
# hash de HEAD est donc le même avec ou sans --dirty.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$script_dir/build-fieldops.sh" "$@"

# Dernier argument : la destination
dest="${*: -1}"
cd "$dest"

export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null
export TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

g rm -r -q -- mobile
# Retire du README la puce et la section qui renvoient à mobile/ (accents graves
# littéraux, pas de substitution)
# shellcheck disable=SC2016
sed -e '/(Flutter) dans `mobile\/`/d' -e '/^## Application mobile$/,/^Voir `mobile\/README.md`.$/d' \
  README.md >README.md.tmp
mv README.md.tmp README.md
g add -- README.md

export GIT_AUTHOR_NAME="Léa Marchetti" GIT_AUTHOR_EMAIL="lea.marchetti@example.invalid"
export GIT_COMMITTER_NAME="Léa Marchetti" GIT_COMMITTER_EMAIL="lea.marchetti@example.invalid"
export GIT_AUTHOR_DATE="2026-10-01T09:00:00Z" GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"
g commit -q -m "chore: retrait de l'application compagnon, déplacée dans son propre dépôt"

echo "FieldOps web seul construit dans $dest (HEAD $(g rev-parse --short HEAD))."
