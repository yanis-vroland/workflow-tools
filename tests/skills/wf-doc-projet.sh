#!/usr/bin/env bash
# Tests structurels de la skill wf-doc-projet (spec 002, ADR-001 tests à deux
# niveaux). Sans modèle : vérifie que SKILL.md existe, respecte les conventions
# communes (verifier-skills.sh) et cite le contrat de la spec 002 : chemins du
# livrable, fichiers du format dossier, sections dans l'ordre, tableau des
# variables d'environnement, seuil de 500 lignes et schéma Mermaid. Le comportement réel est vérifié par les evals
# evals/doc-projet-*.
# Usage : tests/skills/wf-doc-projet.sh [répertoire des skills, par défaut skills/]
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skills=${1:-$root/skills}
skill="$skills/wf-doc-projet"
file="$skill/SKILL.md"
fail=0

ok() { echo "OK     $1"; }
ko() {
  echo "ÉCHEC  $1"
  fail=1
}

# --- Présence et conventions communes -----------------------------------------

if [ -f "$file" ]; then
  ok "SKILL.md présent ($file)"
else
  ko "SKILL.md absent : $file"
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/skills"
if [ -d "$skill" ]; then
  cp -R "$skill" "$work/skills/"
fi
if [ -f "$file" ] && output=$(bash "$root/.github/scripts/verifier-skills.sh" "$work/skills" 2>&1); then
  ok "Conventions communes de l'ADR-001 (verifier-skills.sh)"
else
  ko "Conventions communes de l'ADR-001 (verifier-skills.sh) : ${output:-skill absente}"
fi

# Corps de la skill, sans le frontmatter
body=""
if [ -f "$file" ]; then
  end=$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$file")
  body=$(sed -n "$((${end:-0} + 1)),\$p" "$file")
fi

# cite <CA> <texte attendu, littéral>
cite() {
  local ca=$1 text=$2
  if [ -n "$body" ] && grep -qF -- "$text" <<<"$body"; then
    ok "$ca : cite « $text »"
  else
    ko "$ca : « $text » absent du corps de SKILL.md"
  fi
}

# --- CA9, CA10 : emplacement et format du livrable -------------------------

cite CA9 'docs/wf/doc-projet.md'
cite CA10 'docs/wf/doc-projet/'
cite CA10 'index.md'
cite CA10 'installation.md'
cite CA10 'configuration.md'
cite CA10 'fonctionnalites.md'
cite CA10 'structure.md'

# --- CA2 : sections, dans l'ordre ----------------------------------------------

sections=(
  'Présentation'
  'Stack technique'
  'Architecture'
  'Installation et lancement'
  'Configuration'
  'Fonctionnalités'
  'Structure du code'
  'Points non déterminés'
)
for section in "${sections[@]}"; do
  cite CA2 "$section"
done

# Les huit sections apparaissent au moins une fois dans l'ordre de CA2
ordered=$(printf '%s.*' "${sections[@]}")
ordered=${ordered%.*}
if [ -n "$body" ] && tr '\n' ' ' <<<"$body" | LC_ALL=C grep -q -- "$ordered"; then
  ok "CA2 : sections citées dans l'ordre de la spec"
else
  ko "CA2 : les huit sections ne sont jamais citées dans l'ordre de la spec"
fi

# --- CA4 : tableau des variables d'environnement ---------------------------------
# En-tête exact du tableau, une règle par colonne, et service nommé seulement
# s'il est établi par le code (SDK ou API).

cite CA4 "| Variable | Utilisé pour | Où la renseigner | Comment l'obtenir |"
cite CA4 'SDK'
cite CA4 '**Utilisé pour**'
cite CA4 '**Où la renseigner**'
cite CA4 '**Comment l'"'"'obtenir**'

# --- CA5, CA9, CA11 : schéma et seuil ------------------------------------------

if [ -n "$body" ] && grep -qi -- 'mermaid' <<<"$body"; then
  ok "CA5 : cite Mermaid"
else
  ko "CA5 : « Mermaid » absent du corps de SKILL.md"
fi
cite CA11 '500'

exit $fail
