#!/usr/bin/env bash
# Vérifie .github/scripts/verifier-skills.sh (ADR-001, tests structurels) sur des
# skills factices, puis l'exécute sur les vraies skills du plugin.
set -u

root="$(cd "$(dirname "$0")/.." && pwd)"
script="$root/.github/scripts/verifier-skills.sh"
fail=0

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

output=""

# check <code attendu> <description> <fragment attendu ou vide> <répertoire des skills>
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

# Corps conforme : contient toutes les consignes communes de l'ADR-001
valid_body() {
  cat <<'EOF'
Écris le livrable dans `docs/wf/` du projet cible, et nulle part ailleurs.
Ne lis aucun fichier d'environnement, sauf `.env.example`.
Ce qui n'a pas pu être établi est marqué « non déterminé ».
Si le répertoire de travail n'est pas propre, ajoute « modifications non commitées » dans l'en-tête.
Ne recopie aucune adresse e-mail de contributeur.
EOF
}

# new_case <nom du cas> : crée un répertoire de skills vide et l'affiche
new_case() {
  mkdir -p "$work/$1"
  echo "$work/$1"
}

# skill <répertoire des skills> <nom du dossier> <frontmatter> [corps]
skill() {
  local dir=$1 name=$2 front=$3 body=${4-}
  mkdir -p "$dir/$name"
  if [ -z "${4+x}" ]; then
    body=$(valid_body)
  fi
  printf '%s\n%s\n' "$front" "$body" >"$dir/$name/SKILL.md"
}

front_ok() {
  printf -- '---\nname: %s\ndescription: Outil de test.\n---\n' "$1"
}

# --- Cas conformes ---------------------------------------------------------------

d=$(new_case vide)
check 0 "Aucune skill : succès" "" "$d"

d=$(new_case gitkeep)
: >"$d/.gitkeep"
check 0 "Seulement .gitkeep : succès" "" "$d"

d=$(new_case conforme)
skill "$d" wf-exemple "$(front_ok wf-exemple)"
skill "$d" wf-autre-outil "$(front_ok wf-autre-outil)"
check 0 "Deux skills conformes : succès" "" "$d"

d=$(new_case fichiers-annexes)
skill "$d" wf-exemple "$(front_ok wf-exemple)"
mkdir -p "$d/wf-exemple/references"
printf 'Annexe sans frontmatter.\n' >"$d/wf-exemple/references/modele.md"
check 0 "Fichiers annexes dans la skill : ignorés" "" "$d"

# --- Nommage et présence --------------------------------------------------------

d=$(new_case sans-skill-md)
mkdir -p "$d/wf-exemple"
check 1 "Dossier sans SKILL.md : échec" "wf-exemple" "$d"

d=$(new_case nom-dossier)
skill "$d" analyse "$(front_ok analyse)"
check 1 "Dossier sans préfixe wf- : échec" "analyse" "$d"

d=$(new_case majuscules)
skill "$d" wf-Analyse "$(front_ok wf-Analyse)"
check 1 "Dossier avec majuscule : échec" "wf-Analyse" "$d"

# --- Frontmatter ------------------------------------------------------------------

d=$(new_case sans-frontmatter)
skill "$d" wf-exemple "Pas de frontmatter."
check 1 "Frontmatter absent : échec" "frontmatter" "$d"

d=$(new_case frontmatter-ouvert)
skill "$d" wf-exemple "$(printf -- '---\nname: wf-exemple\ndescription: Outil de test.\n')"
check 1 "Frontmatter non fermé : échec" "frontmatter" "$d"

d=$(new_case nom-different)
skill "$d" wf-exemple "$(front_ok wf-autre)"
check 1 "name différent du dossier : échec" "name" "$d"

d=$(new_case nom-absent)
skill "$d" wf-exemple "$(printf -- '---\ndescription: Outil de test.\n---\n')"
check 1 "name absent : échec" "name" "$d"

d=$(new_case nom-hors-frontmatter)
skill "$d" wf-exemple "$(printf -- '---\ndescription: Outil de test.\n---\nname: wf-exemple\n')"
check 1 "name seulement dans le corps : échec" "name" "$d"

d=$(new_case description-absente)
skill "$d" wf-exemple "$(printf -- '---\nname: wf-exemple\n---\n')"
check 1 "description absente : échec" "description" "$d"

d=$(new_case description-vide)
skill "$d" wf-exemple "$(printf -- '---\nname: wf-exemple\ndescription:   \n---\n')"
check 1 "description vide : échec" "description" "$d"

d=$(new_case description-guillemets-vides)
skill "$d" wf-exemple "$(printf -- '---\nname: wf-exemple\ndescription: ""\n---\n')"
check 1 "description réduite à des guillemets : échec" "description" "$d"

d=$(new_case nom-guillemets)
skill "$d" wf-exemple "$(printf -- '---\nname: "wf-exemple"\ndescription: Outil de test.\n---\n')"
check 0 "name entre guillemets : accepté" "" "$d"

# --- Consignes communes de l'ADR-001 ------------------------------------------

# missing <consigne> <fragment du message attendu>
missing() {
  local consigne=$1 fragment=$2 name
  name="sans-$(tr -c '[:alnum:]' '-' <<<"$consigne")"
  d=$(new_case "$name")
  skill "$d" wf-exemple "$(front_ok wf-exemple)" "$(valid_body | grep -vF -- "$consigne")"
  check 1 "Consigne absente ($consigne) : échec" "$fragment" "$d"
}

missing 'docs/wf/' 'docs/wf/'
missing '.env.example' '.env.example'
missing 'non déterminé' 'non déterminé'
missing 'modifications non commitées' 'modifications non commitées'
missing 'e-mail' 'e-mail'

d=$(new_case consigne-dans-frontmatter)
skill "$d" wf-exemple "$(printf -- '---\nname: wf-exemple\ndescription: Écrit dans docs/wf/.\n---\n')" \
  "$(valid_body | grep -vF -- 'docs/wf/')"
check 1 "Consigne seulement dans le frontmatter : échec" "docs/wf/" "$d"

# --- Agrégation -------------------------------------------------------------------

d=$(new_case plusieurs-erreurs)
skill "$d" wf-un "$(front_ok wf-autre)"
skill "$d" wf-deux "$(front_ok wf-deux)" "Corps sans consigne."
check 1 "Erreurs dans deux skills : les deux sont signalées" "wf-un" "$d"
if ! grep -qF -- "wf-deux" <<<"$output"; then
  echo "ÉCHEC  Erreurs dans deux skills : wf-deux absent du rapport ($output)"
  fail=1
fi

check 1 "Répertoire inexistant : échec" "" "$work/inexistant"

# --- Vraies skills du plugin --------------------------------------------------

check 0 "Skills du plugin conformes" "" "$root/skills"

# --- Tests structurels propres à chaque skill (tests/skills/wf-<outil>.sh) ----

for test_file in "$root"/tests/skills/*.sh; do
  [ -e "$test_file" ] || continue
  if ! bash "$test_file"; then
    echo "ÉCHEC  ${test_file#"$root"/}"
    fail=1
  fi
done

exit $fail
