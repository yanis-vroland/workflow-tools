#!/usr/bin/env bash
# FieldOps avec un livrable wf-doc-projet au format fichier unique
# (docs/wf/doc-projet.md), commité pour garder l'arbre de travail propre
# (spec 003, CA12).
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

mkdir -p docs/wf
cat >docs/wf/doc-projet.md <<'MD'
# Documentation du projet FieldOps

Outil : wf-doc-projet · Date : 2026-09-30 · Commit : 5b26289

## Vue d'ensemble

FieldOps gère les interventions des techniciens terrain (`README.md`).

## Stack technique

API Express et back-office React (`package.json`), application Flutter (`mobile/pubspec.yaml`).

## Architecture

L'API (`src/api/server.ts`) sert le back-office (`src/web/`) et l'application mobile (`mobile/`).

## Fonctionnalités

Suivi des interventions, ordres de travail, facturation (`src/api/routes/`).

## Structure du code

- `src/api/` : API Express.
- `src/domain/` : règles métier.
- `mobile/lib/` : application Flutter.

## Installation et lancement

Voir `README.md`.
MD

commit_paths "docs: documentation du projet (wf-doc-projet)" docs/wf/doc-projet.md
