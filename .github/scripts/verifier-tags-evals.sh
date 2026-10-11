#!/usr/bin/env bash
# Vérifie que chaque cas d'eval (case.yaml, hors results/) porte exactement un des
# tags « reseau » ou « hors-reseau » : la CI lance les evals en deux passes filtrées
# par ces tags (evals/README.md, section Réseau), un cas sans l'un d'eux ne tournerait jamais.
# Usage : verifier-tags-evals.sh [répertoire des evals]
# Codes : 0 conforme, 1 cas non conforme ou aucun cas, 2 erreur d'usage.
set -u

dir=${1:-evals}
if [ ! -d "$dir" ]; then
  echo "ERREUR  répertoire introuvable : $dir" >&2
  exit 2
fi

fail=0
count=0
while IFS= read -r file; do
  count=$((count + 1))
  tags=$(grep -m1 -E '^tags:' "$file" | sed -E 's/^tags:[[:space:]]*\[(.*)\].*/\1/')
  n=0
  for tag in ${tags//,/ }; do
    case $tag in
      reseau | hors-reseau) n=$((n + 1)) ;;
    esac
  done
  if [ "$n" -ne 1 ]; then
    echo "ERREUR  ${file#"$dir"/} : exactement un tag reseau ou hors-reseau attendu"
    fail=1
  fi
done < <(find "$dir" -path "$dir/results" -prune -o -name case.yaml -print | sort)

if [ "$count" -eq 0 ]; then
  echo "ERREUR  aucun cas d'eval trouvé dans $dir"
  exit 1
fi
exit "$fail"
