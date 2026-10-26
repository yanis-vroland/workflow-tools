#!/usr/bin/env bash
# FieldOps complet avec une modification non commitée (--dirty, dans
# src/domain/scheduling.ts) et un livrable docs/wf/publication-store.md déjà
# présent et commité, issu d'une exécution précédente (spec 015, CA26). Ce
# livrable contient des informations périmées : version 1.1.0, build 9, date
# 2026-09-01, commit 0000000. La relance doit le mettre à jour, sans doublon.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty "$PWD"

mkdir -p docs/wf
cat >docs/wf/publication-store.md <<'MD'
# Préparation de la publication sur les stores de FieldOps

Outil : wf-publication-store · Date : 2026-09-01 · Commit : 0000000

## Synthèse

- non prêt — iOS : 2 bloquants à faire, 1 à vérifier ; Android : 2 bloquants à faire, 1 à vérifier.

## Identité de l'application

| Information | iOS | Android |
|---|---|---|
| Nom affiché | FieldOps (`mobile/ios/Runner/Info.plist`) | FieldOps (`mobile/android/app/src/main/AndroidManifest.xml`) |
| Identifiant | com.example.fieldops.companion (`mobile/ios/Runner/Info.plist`) | com.example.fieldops.companion (`mobile/android/app/build.gradle`) |
| Numéro de version | 1.1.0 (`mobile/pubspec.yaml`) | 1.1.0 (`mobile/pubspec.yaml`) |
| Numéro de build | 9 (`mobile/pubspec.yaml`) | 9 (`mobile/pubspec.yaml`) |

## Checklist iOS

| Élément | Statut | Bloquant | Fichier | Détail |
|---|---|---|---|---|
| Icône 1024×1024 | à faire | oui | `mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json` | Fichier absent. |

## Checklist Android

| Élément | Statut | Bloquant | Fichier | Détail |
|---|---|---|---|---|
| Icônes de lanceur | à faire | oui | `mobile/android/app/src/main/res/mipmap-*` | Aucun dossier mipmap. |

## Fiches store

Aucune métadonnée de store.

## Étapes hors projet

| Élément | Statut | Détail |
|---|---|---|
| Captures d'écran | à vérifier | À fournir dans les consoles. |

## Points non déterminés

- Aucun.
MD

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-09-01T12:00:00Z" GIT_COMMITTER_DATE="2026-09-01T12:00:00Z"
git add -- docs/wf/publication-store.md
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false \
  commit -q -m "docs: préparation de la publication sur les stores (wf-publication-store)"
