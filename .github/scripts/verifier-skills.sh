#!/usr/bin/env bash
# Vérification structurelle des skills du plugin (ADR-001, tests structurels).
# Pour chaque dossier de skills/ : nom wf-*, SKILL.md présent, frontmatter fermé
# avec name égal au dossier et description non vide, consignes communes de
# l'ADR-001 présentes dans le corps.
# Usage : verifier-skills.sh [répertoire des skills, par défaut skills/]
set -euo pipefail

dir=${1:-skills}

if [ ! -d "$dir" ]; then
  echo "verifier-skills : répertoire introuvable : $dir" >&2
  exit 1
fi

# Consignes communes de l'ADR-001, à citer textuellement dans le corps de chaque skill
required=(
  'docs/wf/'
  '.env.example'
  'non déterminé'
  'modifications non commitées'
  'e-mail'
)

errors=0
checked=0

error() {
  echo "ERREUR  $1 : $2"
  errors=$((errors + 1))
}

# Valeur d'une clé du frontmatter, sans espaces ni guillemets englobants
front_value() {
  local front=$1 key=$2 value
  value=$(sed -n "s/^$key:[[:space:]]*//p" <<<"$front" | head -n 1)
  value=$(sed -e 's/[[:space:]]*$//' -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/" <<<"$value")
  printf '%s' "$value"
}

for path in "$dir"/*/; do
  [ -d "$path" ] || continue
  name=$(basename "$path")
  checked=$((checked + 1))

  if ! [[ $name =~ ^wf-[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    error "$name" "nom de dossier invalide, attendu wf-<nom-en-minuscules>"
  fi

  file="$path/SKILL.md"
  if [ ! -f "$file" ]; then
    error "$name" "SKILL.md absent"
    continue
  fi

  # Frontmatter : première ligne « --- », fermé par une seconde ligne « --- »
  if [ "$(head -n 1 "$file")" != "---" ]; then
    error "$name" "frontmatter absent (la première ligne doit être ---)"
    continue
  fi
  end=$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$file")
  if [ -z "$end" ]; then
    error "$name" "frontmatter non fermé (--- manquant)"
    continue
  fi
  front=$(sed -n "2,$((end - 1))p" "$file")
  body=$(sed -n "$((end + 1)),\$p" "$file")

  front_name=$(front_value "$front" name)
  if [ -z "$front_name" ]; then
    error "$name" "name absent du frontmatter"
  elif [ "$front_name" != "$name" ]; then
    error "$name" "name ($front_name) différent du nom du dossier"
  fi

  if [ -z "$(front_value "$front" description)" ]; then
    error "$name" "description absente ou vide dans le frontmatter"
  fi

  for consigne in "${required[@]}"; do
    if ! grep -qF -- "$consigne" <<<"$body"; then
      error "$name" "consigne commune de l'ADR-001 absente du corps : « $consigne »"
    fi
  done
done

if [ "$errors" -gt 0 ]; then
  echo "verifier-skills : $errors erreur(s) sur $checked skill(s)."
  exit 1
fi

echo "verifier-skills : $checked skill(s) conforme(s)."
