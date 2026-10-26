#!/usr/bin/env bash
# FieldOps complet, puis un commit qui ajoute (spec 015, CA18 à CA22) :
#   - des métadonnées de store en français dans mobile/fastlane/metadata/
#     (fastlane deliver pour iOS : fr-FR/ ; fastlane supply pour Android :
#     android/fr-FR/), dont une description courte Android de plus de 80
#     caractères (CA22) ;
#   - docs/wf/release-notes.md (livrable de wf-release-notes, spec 009) : section
#     la plus récente « Version 1.3.0 », alors que mobile/pubspec.yaml est en
#     1.2.0+14 (CA20), avec une sous-section « Nouveautés » (CA19) ; section
#     plus ancienne « Version 1.2.0 » dont les nouveautés ne doivent pas être
#     reprises.
# Arbre propre après le commit.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

ios=mobile/fastlane/metadata/fr-FR
android=mobile/fastlane/metadata/android/fr-FR
mkdir -p "$ios" "$android"

printf 'FieldOps Technicien\n' >"$ios/name.txt"
printf 'Interventions sur le terrain\n' >"$ios/subtitle.txt"
printf 'intervention,technicien,planning,maintenance,terrain,photos\n' >"$ios/keywords.txt"
cat >"$ios/description.txt" <<'TXT'
FieldOps Technicien accompagne les techniciens de maintenance sur le terrain :
planning du jour, détail de chaque intervention, photos avant et après, et
clôture avec compte rendu, même sans réseau.
TXT

printf 'FieldOps Technicien\n' >"$android/title.txt"
# 126 caractères : dépasse la limite de 80 de la description courte Android
printf 'Planning du jour, détail des interventions, photos et clôture sur site, même hors réseau, pour les techniciens de maintenance.\n' \
  >"$android/short_description.txt"
cat >"$android/full_description.txt" <<'TXT'
FieldOps Technicien accompagne les techniciens de maintenance sur le terrain :
planning du jour, détail de chaque intervention, photos avant et après, et
clôture avec compte rendu, même sans réseau.
TXT

mkdir -p docs/wf
cat >docs/wf/release-notes.md <<'MD'
# Notes de version de FieldOps

Outil : wf-release-notes · Date : 2026-10-05 · Commit : 9e8d7c6

## Version 1.3.0 (2026-10-05)

### Nouveautés

- Le client signe le compte rendu directement sur le téléphone du technicien à la clôture.
- Les photos d'une intervention peuvent être annotées avant l'envoi.

### Corrections

- Le planning du jour s'affiche correctement après un changement de fuseau horaire.

### Références

- Signature du client à la clôture : 4f5e6d7.
- Annotation des photos : 8a9b0c1.
- Planning après changement de fuseau : 2d3e4f5.

## Version 1.2.0 (2026-08-05)

### Nouveautés

- Les interventions consultées restent disponibles hors réseau.

### Références

- Interventions disponibles hors réseau : 6b7c8d9.
MD

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-10-05T09:00:00Z" GIT_COMMITTER_DATE="2026-10-05T09:00:00Z"
git add -- mobile/fastlane docs/wf/release-notes.md
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false \
  commit -q -m "docs(mobile): fiches store et notes de version 1.3.0"
