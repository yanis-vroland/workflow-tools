#!/usr/bin/env bash
# Vérifie .github/scripts/verifier-tags-evals.sh : chaque cas d'eval porte exactement
# un des tags « reseau » ou « hors-reseau », sinon la CI (deux lancements filtrés
# par tag) l'ignorerait sans le signaler.
set -u

script="$(cd "$(dirname "$0")/.." && pwd)/.github/scripts/verifier-tags-evals.sh"
fail=0

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

output=""

# check <code attendu> <description> <fragment attendu ou vide> <répertoire des evals>
check() {
  local expected=$1 description=$2 fragment=$3 dir=$4
  output=$(bash "$script" "$dir" 2>&1)
  local code=$?
  if [ "$code" -ne "$expected" ]; then
    echo "ÉCHEC  $description (attendu $expected, obtenu $code : $output)"
    fail=1
  elif [ -n "$fragment" ] && ! grep -qiF -- "$fragment" <<<"$output"; then
    echo "ÉCHEC  $description (fragment « $fragment » absent : $output)"
    fail=1
  else
    echo "OK     $description"
  fi
}

# case_file <répertoire des evals> <chemin du cas> <ligne de tags ou vide>
case_file() {
  mkdir -p "$1/$2"
  {
    echo 'schema_version: "1.1"'
    echo "name: $(basename "$2")"
    [ -n "$3" ] && echo "$3"
    echo 'runs: 1'
  } >"$1/$2/case.yaml"
}

d="$work/ok"
case_file "$d" a "tags: [socle, hors-reseau]"
case_file "$d" groupe/b "tags: [outil, reseau]"
check 0 "Cas tous taggés, y compris imbriqués : succès" "" "$d"

d="$work/sans-tags"
case_file "$d" a "tags: [hors-reseau]"
case_file "$d" groupe/c ""
check 1 "Cas sans ligne tags : échec nommant le cas" "groupe/c" "$d"

d="$work/autre-tag"
case_file "$d" a "tags: [socle]"
check 1 "Cas sans reseau ni hors-reseau : échec" "a/case.yaml" "$d"

d="$work/les-deux"
case_file "$d" a "tags: [reseau, hors-reseau]"
check 1 "Cas portant les deux tags : échec" "a/case.yaml" "$d"

d="$work/prefixe"
case_file "$d" a "tags: [reseau-lent]"
check 1 "Tag qui ne fait que commencer par reseau : échec" "a/case.yaml" "$d"

d="$work/resultats"
case_file "$d" a "tags: [hors-reseau]"
case_file "$d" results/2026/x ""
check 0 "Le dossier results/ est ignoré" "" "$d"

d="$work/vide"
mkdir -p "$d"
check 1 "Aucun cas trouvé : échec" "aucun cas" "$d"

check 2 "Répertoire inexistant : erreur d'usage" "" "$work/absent"

exit "$fail"
