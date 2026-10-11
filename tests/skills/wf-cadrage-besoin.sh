#!/usr/bin/env bash
# Tests structurels de wf-cadrage-besoin (spec 004), lancés par tests/skills.sh.
#
# Le chemin du livrable, les noms de sections et les identifiants sont un contrat
# lu par wf-chiffrage et wf-specs-tickets (spec 004, amendement 1 de l'ADR-001) ;
# l'échelle de priorité, le champ de réponse et la mention de source des réponses
# saisies sont fixés mot pour mot par la spec. La skill doit les citer
# textuellement. La qualité du livrable lui-même est vérifiée par les evals
# (evals/cadrage-besoin-*).
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
verifier="$root/.github/scripts/verifier-skills.sh"
skill_dir="$root/skills/wf-cadrage-besoin"
skill="$skill_dir/SKILL.md"
fail=0

sections=('Synthèse' 'Contexte et objectifs' 'Utilisateurs et rôles'
  'Besoins fonctionnels' 'Contraintes' 'Hors périmètre' 'Hypothèses'
  'Questions au client' 'Points non déterminés')

# contract <identifiant et description> <fragment attendu dans SKILL.md>
contract() {
  local description=$1 fragment=$2
  if [ ! -f "$skill" ]; then
    echo "ÉCHEC  wf-cadrage-besoin, $description (skills/wf-cadrage-besoin/SKILL.md absent)"
    fail=1
  elif ! grep -qF -- "$fragment" "$skill"; then
    echo "ÉCHEC  wf-cadrage-besoin, $description (« $fragment » absent de SKILL.md)"
    fail=1
  else
    echo "OK     wf-cadrage-besoin, $description"
  fi
}

# --- Présence et conformité à l'ADR-001 ----------------------------------------

if [ -f "$skill" ]; then
  echo "OK     wf-cadrage-besoin : skill présente"
  work=$(mktemp -d)
  trap 'rm -rf "$work"' EXIT
  cp -R "$skill_dir" "$work/"
  if output=$(bash "$verifier" "$work" 2>&1); then
    echo "OK     wf-cadrage-besoin : conforme à l'ADR-001 (frontmatter, consignes communes)"
  else
    echo "ÉCHEC  wf-cadrage-besoin : non conforme à l'ADR-001 ($output)"
    fail=1
  fi
else
  echo "ÉCHEC  wf-cadrage-besoin : skills/wf-cadrage-besoin/SKILL.md absent (spec 004)"
  fail=1
fi

# --- Contrat de la spec 004 ---------------------------------------------------

contract "CA1 : chemin du livrable" 'docs/wf/cadrage-besoin.md'

for section in "${sections[@]}"; do
  contract "CA2 : section « $section »" "$section"
done

# CA2 : les neuf sections apparaissent dans l'ordre de la spec, parmi les lignes
# de titre Markdown de SKILL.md (modèle du livrable), première occurrence de
# chaque nom
if [ -f "$skill" ]; then
  headings=$(grep -nE '^[[:space:]]*#{1,6}[[:space:]]' "$skill" || true)
  order_ok=1
  previous=0
  for section in "${sections[@]}"; do
    line=$(grep -F -- "$section" <<<"$headings" | head -n 1 | cut -d: -f1)
    if [ -z "$line" ] || [ "$line" -le "$previous" ]; then
      order_ok=0
      break
    fi
    previous=$line
  done
  if [ "$order_ok" -eq 1 ]; then
    echo "OK     wf-cadrage-besoin, CA2 : sections dans l'ordre de la spec"
  else
    echo "ÉCHEC  wf-cadrage-besoin, CA2 : sections hors de l'ordre de la spec (premier écart : « $section »)"
    fail=1
  fi
else
  echo "ÉCHEC  wf-cadrage-besoin, CA2 : ordre des sections (skills/wf-cadrage-besoin/SKILL.md absent)"
  fail=1
fi

contract "CA4 : identifiant de besoin" 'B01'
for priority in 'indispensable' 'important' 'souhaitable' 'non précisée'; do
  contract "CA5 : priorité « $priority »" "$priority"
done
contract "CA11 : identifiant de question" 'Q01'
contract "CA11 : champ de réponse à remplir" 'Réponse :'
contract "CA12 : source d'une réponse saisie" 'réponse saisie à la question'

exit $fail
