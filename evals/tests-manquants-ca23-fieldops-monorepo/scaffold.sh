#!/usr/bin/env bash
# Reconstruit la fixture FieldOps complète (monorepo web JS/TS et Flutter,
# historique git, faux secret) dans le répertoire de travail de l'eval, vide au
# lancement. Arbre de travail propre, aucun rapport de couverture, aucun
# livrable docs/wf/ préexistant.
#
# Les points chauds de la spec 012 (CA9, CA11) se calculent sur les 12 derniers
# mois glissants : l'historique figé de la fixture en sortirait peu à peu. Le
# scaffold ajoute donc des commits datés relativement au jour d'exécution
# (il y a 1 à 6 jours) sur les deux fichiers non couverts qui doivent rester en
# priorité haute :
#   - src/api/routes/interventions.ts : 4 commits récents ;
#   - mobile/lib/screens/intervention_list_screen.dart : 2 commits récents.
# Quelle que soit la date, interventions.ts garde ainsi plus de commits sur
# 12 mois que intervention_list_screen.dart (ordre de CA11), et les deux
# fichiers au moins deux (top 10 de CA9). Le hash de HEAD n'est plus figé.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Léa Marchetti" GIT_AUTHOR_EMAIL="lea.marchetti@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
now=$(date +%s)

# recent_commit <jours avant aujourd'hui> <fichier> <message>
recent_commit() {
  local when=$((now - $1 * 86400))
  export GIT_AUTHOR_DATE="$when +0000" GIT_COMMITTER_DATE="$when +0000"
  printf '// relecture du %s jours avant\n' "$1" >>"$2"
  git -c core.hooksPath=/dev/null add -- "$2"
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "$3"
}

recent_commit 6 src/api/routes/interventions.ts "chore(interventions): relecture des routes"
recent_commit 5 src/api/routes/interventions.ts "chore(interventions): relecture des statuts"
recent_commit 4 src/api/routes/interventions.ts "chore(interventions): relecture de la suppression"
recent_commit 3 src/api/routes/interventions.ts "chore(interventions): relecture de la création"
recent_commit 2 mobile/lib/screens/intervention_list_screen.dart "chore(mobile): relecture du planning"
recent_commit 1 mobile/lib/screens/intervention_list_screen.dart "chore(mobile): relecture du mode hors connexion"
