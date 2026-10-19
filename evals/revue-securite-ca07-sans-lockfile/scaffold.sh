#!/usr/bin/env bash
# Spec 010, CA7 : projet sans lockfile. FieldOps web seul (build-fieldops-web.sh,
# sans faux fichier d'environnement), dont package-lock.json est retiré dans un
# commit déterministe : seules les contraintes de package.json restent.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" --no-secret "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Léa Marchetti" GIT_AUTHOR_EMAIL="lea.marchetti@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-02T09:00:00Z" GIT_COMMITTER_DATE="2026-10-02T09:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false rm -q package-lock.json
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "chore: retrait du fichier de verrouillage"
