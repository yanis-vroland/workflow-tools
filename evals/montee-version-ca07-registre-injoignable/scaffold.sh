#!/usr/bin/env bash
# Spec 013, CA7 : registres de paquets injoignables, sur FieldOps complet.
#
# Le réseau est coupé par le bac à sable de Claude Code : ce cas se lance SANS
# autorisation WebFetch(domain:…) (passe hors-reseau, voir evals/README.md). Le
# témoin ca07-temoin-echec-reseau vérifie dans la trace que l'interrogation du
# registre a bien échoué. Comme pour evals/analyse-projet/ca4-registre-injoignable,
# un .npmrc projet redirige vers un registre injoignable un modèle qui passerait
# par `npm view` ou `npm outdated` ; il est exclu par .git/info/exclude pour
# garder l'arbre de travail propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

printf 'registry=http://127.0.0.1:9/\n' >.npmrc
printf '.npmrc\n' >>.git/info/exclude
