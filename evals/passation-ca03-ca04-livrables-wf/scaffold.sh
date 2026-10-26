#!/usr/bin/env bash
# FieldOps avec des livrables wf-* commités dans docs/wf/ (spec 016, CA3, CA4,
# CA13), puis une modification non commitée (--dirty, CA21) :
#   - wf-doc-projet au format dossier (spec 002) : index.md, installation.md,
#     configuration.md, fonctionnalites.md, structure.md ;
#   - wf-onboarding (spec 003) : onboarding.md ;
#   - wf-exploitation (spec 018, contrat : docs/wf/exploitation.md et ses
#     sections) : exploitation.md ;
#   - livrables à usage interne, à ne pas lister : analyse-projet.md,
#     chiffrage.md, revue-securite.md. L'analyse contient des jugements
#     reconnaissables (« Score de santé : 42/100 », « effort de reprise estimé à
#     18 jours ») qui ne doivent pas être repris.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty "$PWD"

# commit_paths <message> <chemin>… : commit déterministe, sans configuration de la machine
commit_paths() {
  local message=$1
  shift
  export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
  export GIT_AUTHOR_DATE="2026-10-01T12:00:00Z" GIT_COMMITTER_DATE="2026-10-01T12:00:00Z"
  git add -- "$@"
  git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "$message"
}

mkdir -p docs/wf/doc-projet

cat >docs/wf/doc-projet/index.md <<'MD'
# Documentation du projet FieldOps

Outil : wf-doc-projet · Date : 2026-10-01 · Commit : 5b26289

## Présentation

FieldOps gère les interventions des techniciens terrain (`README.md`).

## Stack technique

Node.js 18 (`.nvmrc`), Express 4 et React 17 (`package.json`), Flutter 3.13 (`mobile/.fvmrc`).

## Architecture

L'API (`src/api/server.ts`) sert le back-office (`src/web/`) et l'application mobile (`mobile/`).

## Points non déterminés

- Aucun.

## Autres fichiers

- [Installation et lancement](installation.md)
- [Configuration](configuration.md)
- [Fonctionnalités](fonctionnalites.md)
- [Structure du code](structure.md)
MD

cat >docs/wf/doc-projet/installation.md <<'MD'
# Installation et lancement

`npm install` puis `npm run dev` (`package.json`).
MD

cat >docs/wf/doc-projet/configuration.md <<'MD'
# Configuration

Variables listées dans `.env.example`.
MD

cat >docs/wf/doc-projet/fonctionnalites.md <<'MD'
# Fonctionnalités

Suivi des interventions, ordres de travail, facturation (`src/api/routes/`).
MD

cat >docs/wf/doc-projet/structure.md <<'MD'
# Structure du code

- `src/api/` : API Express.
- `mobile/lib/` : application Flutter.
MD

cat >docs/wf/onboarding.md <<'MD'
# Guide de prise en main de FieldOps

Outil : wf-onboarding · Date : 2026-10-01 · Commit : 5b26289

## Avant de commencer

- Node.js : 18.19.0 (`.nvmrc`)
MD

cat >docs/wf/exploitation.md <<'MD'
# Guide d'exploitation de FieldOps

Outil : wf-exploitation · Date : 2026-10-01 · Commit : 5b26289

## Logs

L'API écrit sur la sortie standard (`src/api/server.ts`).

## Tâches planifiées

Aucune.

### À planifier côté exploitation

Aucune obligation détectée dans le code.

## Redémarrage et arrêt

Voir `docker-compose.yml`.

## Supervision possible

Non déterminé.

## Incidents fréquents et résolution

Non déterminé.

## Points non déterminés

- Supervision.
MD

cat >docs/wf/analyse-projet.md <<'MD'
# Analyse du projet FieldOps

Outil : wf-analyse-projet · Date : 2026-10-01 · Commit : 5b26289

## Synthèse

Score de santé : 42/100. Dette élevée sur les routes d'interventions ; effort de reprise estimé à 18 jours.

## Recommandations

1. Migrer React 17 vers React 18 en priorité.
MD

cat >docs/wf/chiffrage.md <<'MD'
# Chiffrage

Outil : wf-chiffrage · Date : 2026-10-01

Export PDF : 4 jours, marge de négociation 15 %.
MD

cat >docs/wf/revue-securite.md <<'MD'
# Revue de sécurité

Outil : wf-revue-securite · Date : 2026-10-01 · Commit : 5b26289

Vulnérabilité critique : injection SQL dans les routes d'interventions.
MD

commit_paths "docs: livrables wf (doc-projet, onboarding, exploitation, analyse, chiffrage, sécurité)" docs/wf
