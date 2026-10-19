#!/usr/bin/env bash
# FieldOps avec, commités (spec 016, CA15 et CA4) :
#   - un livrable wf-doc-projet en fichier unique (docs/wf/doc-projet.md) ;
#   - un dossier de passation précédent (docs/wf/passation.md, daté du
#     2026-09-01), dont des saisies ont été faites à la main :
#       * statuts : service de cartographie « fait », REGISTRY_TOKEN « fait »,
#         dépôt de code « en cours » ;
#       * titulaire du compte de cartographie : « direction technique du client » ;
#       * « Comment l'obtenir » de DEPLOY_TOKEN : « auprès de l'hébergeur, voir
#         contrat d'hébergement » ;
#       * responsable côté client : « direction technique du client ».
#     Il suit un format antérieur (colonnes Action | Statut | Source, secrets
#     sans « Utilisé pour », « Titulaire : », interlocuteur séparé par un
#     tiret) : les correcteurs exigent le format actuel, qu'aucune copie telle
#     quelle de l'ancien fichier ne satisfait.
#     Le service de paiement n'y figure pas : il doit apparaître, « à faire ».
#     La branche feat/ancien-import n'existe plus (source disparue).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

# commit_paths <message> <chemin>… : commit déterministe, sans configuration de la machine
commit_paths() {
  local message=$1
  shift
  export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
  export GIT_AUTHOR_DATE="2026-10-02T12:00:00Z" GIT_COMMITTER_DATE="2026-10-02T12:00:00Z"
  git add -- "$@"
  git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "$message"
}

mkdir -p docs/wf

cat >docs/wf/doc-projet.md <<'MD'
# Documentation du projet FieldOps

Outil : wf-doc-projet · Date : 2026-09-01 · Commit : 5b26289

## Présentation

FieldOps gère les interventions des techniciens terrain (`README.md`).

## Stack technique

Voir `package.json` et `mobile/pubspec.yaml`.

## Architecture

L'API (`src/api/server.ts`) sert le back-office et l'application mobile.

## Installation et lancement

`npm install` (`README.md`).

## Configuration

Variables de `.env.example`.

## Fonctionnalités

Interventions, ordres de travail, facturation.

## Structure du code

`src/`, `mobile/`.

## Points non déterminés

- Aucun.
MD

cat >docs/wf/passation.md <<'MD'
# Dossier de passation de FieldOps

Outil : wf-passation · Date : 2026-09-01 · Commit : 0000000

## Synthèse

- Périmètre transmis : application web (racine), application mobile (`mobile/`).
- Commit de référence : `0000000`.
- Checklist : 7 lignes (3 « à faire », 1 « en cours », 2 « fait », 1 « abandonnée »).
- Interlocuteurs :
  - Responsable côté client — direction technique du client
  - Prestataire sortant : à compléter
  - Repreneur : à compléter

## Documentation de référence

- [README.md](../../README.md)

## Environnements et déploiement

### Application web (racine)

- Recette : push sur `main` (`.github/workflows/deploy.yml`).

### Application mobile (`mobile/`)

- procédure de déploiement non trouvée dans le dépôt.

## Services tiers et accès

### Application web (racine)

- **Cartographie** : `src/services/mapClient.ts` · Titulaire : direction technique du client
- **E-mail transactionnel** : `src/services/mailer.ts` · Titulaire : à compléter

### Application mobile (`mobile/`)

- Aucun service tiers identifié.

## Secrets à transmettre

Valeurs à transmettre par un canal sécurisé, hors de ce document.

| Secret | Comment l'obtenir | Référencé dans |
|---|---|---|
| `REGISTRY_TOKEN` | à compléter | `.github/workflows/deploy.yml` |
| `DEPLOY_TOKEN` | auprès de l'hébergeur, voir contrat d'hébergement | `.github/workflows/deploy.yml` |

## Travaux en cours

| Branche | Dernier commit | Commits d'avance |
|---|---|---|
| `feat/export-pdf` | 2026-09-30 | 3 |
| `feat/ancien-import` | 2026-06-01 | 2 |

## Points d'attention

- 15 marqueurs.

## Checklist de passation

| Action | Statut | Source |
| --- | --- | --- |
| Transférer l'accès au service de cartographie | fait | `src/services/mapClient.ts` |
| Transférer l'accès au service d'e-mail transactionnel | à faire | `src/services/mailer.ts` |
| Transmettre le secret `REGISTRY_TOKEN` | fait | `.github/workflows/deploy.yml` |
| Transmettre le secret `DEPLOY_TOKEN` | à faire | `.github/workflows/deploy.yml` |
| Transférer les droits sur le dépôt de code | en cours | dépôt git |
| Fusionner, abandonner ou transmettre la branche `feat/export-pdf` | à faire | git |
| Fusionner, abandonner ou transmettre la branche `feat/ancien-import` | abandonnée | git |

## Points non déterminés

- Aucun.
MD

commit_paths "docs: documentation et dossier de passation (wf-doc-projet, wf-passation)" docs/wf
