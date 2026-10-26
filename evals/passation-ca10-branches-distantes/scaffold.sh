#!/usr/bin/env bash
# FieldOps avec des références distantes connues localement, sans aucun dépôt
# distant joignable (spec 016, CA10) :
#   - refs/remotes/origin/main = main, et origin/HEAD pointe sur origin/main
#     (branche principale déterminée par origin/HEAD) ;
#   - origin/feat/notifications-push : 2 commits d'avance sur main, dernier
#     commit le 2026-10-05, autrice fictive ;
#   - fix/libelles : branche locale déjà fusionnée (main~2), à ne pas lister ;
#   - feat/export-pdf : branche locale non fusionnée (3 commits, 2026-09-30) ;
#   - modification non commitée (--dirty) dans src/domain/scheduling.ts.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Inès Royer" GIT_AUTHOR_EMAIL="ines.royer@example.invalid"
export GIT_COMMITTER_NAME="Inès Royer" GIT_COMMITTER_EMAIL="ines.royer@example.invalid"

tree=$(git rev-parse 'main^{tree}')
export GIT_AUTHOR_DATE="2026-10-02T10:00:00Z" GIT_COMMITTER_DATE="2026-10-02T10:00:00Z"
first=$(git commit-tree "$tree" -p main -m "feat(notifications): préférences de notification push")
export GIT_AUTHOR_DATE="2026-10-05T15:30:00Z" GIT_COMMITTER_DATE="2026-10-05T15:30:00Z"
second=$(git commit-tree "$tree" -p "$first" -m "feat(notifications): envoi des notifications push")

git update-ref refs/remotes/origin/main main
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
git update-ref refs/remotes/origin/feat/notifications-push "$second"
git branch fix/libelles main~2
