#!/usr/bin/env bash
# Spec 013, cas principal : FieldOps complet (web JS/TS à la racine, Flutter dans
# mobile/), historique git, faux secret dans le fichier d'environnement local, et
# livrable docs/wf/revue-securite.md de wf-revue-securite déjà commité (CA11).
#
# Le livrable de sécurité respecte le contrat de la spec 010 (CA2, CA5, CA21) :
# section « Dépendances vulnérables », entrées Sn avec nom, écosystème, version
# installée, avis, sévérité publiée et première version corrigée. S1 est un
# constat dans le code (pas une dépendance) et S3 vise express 4.18.2, corrigé
# en 4.19.2 (avis public CVE-2024-29041, GHSA-rv95-896h-c2vc). S2 a été retiré
# lors d'une relance de wf-revue-securite : l'identifiant n'est pas réattribué.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

# commit_paths <message> <chemin>… : commit déterministe, sans configuration de la machine
commit_paths() {
  local message=$1
  shift
  export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
  export GIT_AUTHOR_DATE="2026-10-05T10:00:00Z" GIT_COMMITTER_DATE="2026-10-05T10:00:00Z"
  git add -- "$@"
  git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "$message"
}

mkdir -p docs/wf
cat >docs/wf/revue-securite.md <<'MD'
# Revue de sécurité de FieldOps

Outil : wf-revue-securite · Date : 2026-10-05 · Commit : 2fc99c0

> Usage interne : ce document décrit des failles potentiellement non corrigées. Ne pas le diffuser hors de l'équipe.

## Synthèse

- Constats dans le code : 1 élevé.
- Dépendances vulnérables : 1 de sévérité moyenne (S3).

## Périmètre et méthode

Analyse statique de l'état courant du code, sans test d'intrusion ni exécution du projet.

## Dépendances vulnérables

- **S3** : application web (racine), `express`, npm, version installée 4.18.2 (`package-lock.json`), directe. Avis CVE-2024-29041 (GHSA-rv95-896h-c2vc), sévérité publiée : moyenne. Première version corrigée : 4.19.2.

## Constats dans le code

- **S1** : élevé, injection. Requête SQL construite par concaténation (`src/api/routes/interventions.ts` l. 37). Statut : confirmé.

## Secrets et configuration

Aucun constat.

## Points non déterminés

- Aucun.
MD

commit_paths "docs: revue de sécurité (wf-revue-securite)" docs/wf/revue-securite.md
