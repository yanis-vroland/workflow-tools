#!/usr/bin/env bash
# FieldOps sans spec (spec 014, CA6) : docs/specs/ est retiré par un commit
# déterministe, aucun livrable docs/wf/. L'option --dirty laisse une
# modification non commitée dans src/domain/scheduling.ts (CA20), qui n'est pas
# indexée et reste hors du commit de retrait.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-10-01T09:00:00Z" GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"
git rm -r -q -- docs/specs
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "docs: retrait des specs internes, déplacées dans l'outil de suivi"
