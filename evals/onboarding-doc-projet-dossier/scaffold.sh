#!/usr/bin/env bash
# FieldOps avec un livrable wf-doc-projet au format dossier
# (docs/wf/doc-projet/index.md, fonctionnalites.md, structure.md), commité pour
# garder l'arbre de travail propre (spec 003, CA12, format dossier de la spec 002).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

# commit_paths <message> <chemin>… : commit déterministe, sans configuration de la machine
commit_paths() {
  local message=$1
  shift
  export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
  export GIT_AUTHOR_DATE="2026-09-30T12:00:00Z" GIT_COMMITTER_DATE="2026-09-30T12:00:00Z"
  git add -- "$@"
  git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "$message"
}

mkdir -p docs/wf/doc-projet
cat >docs/wf/doc-projet/index.md <<'MD'
# Documentation du projet FieldOps

Outil : wf-doc-projet · Date : 2026-09-30 · Commit : 5b26289

- [Fonctionnalités](fonctionnalites.md)
- [Structure du code](structure.md)

## Vue d'ensemble

FieldOps gère les interventions des techniciens terrain (`README.md`).

## Architecture

L'API (`src/api/server.ts`) sert le back-office (`src/web/`) et l'application mobile (`mobile/`).
MD

cat >docs/wf/doc-projet/fonctionnalites.md <<'MD'
# Fonctionnalités

Suivi des interventions, ordres de travail, facturation (`src/api/routes/`).
MD

cat >docs/wf/doc-projet/structure.md <<'MD'
# Structure du code

- `src/api/` : API Express.
- `src/domain/` : règles métier.
- `mobile/lib/` : application Flutter.
MD

commit_paths "docs: documentation du projet (wf-doc-projet)" docs/wf/doc-projet
