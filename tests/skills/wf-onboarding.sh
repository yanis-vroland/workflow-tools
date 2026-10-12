#!/usr/bin/env bash
# Tests structurels de la skill wf-onboarding (spec 003, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-onboarding/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 003 impose mot pour mot dans le livrable (titres de
# sections, mentions fixes, chemins). Le comportement réel est vérifié par les
# evals evals/onboarding-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-onboarding"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-onboarding : $1"; }
ko() {
  echo "ÉCHEC  wf-onboarding : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-onboarding/SKILL.md introuvable)"
  exit 1
fi
ok "SKILL.md présent"

work=$(mktemp -d)
trap 'rm -r "$work"' EXIT
mkdir -p "$work/skills"
cp -R "$skill_dir" "$work/skills/"
if out=$(bash "$root/.github/scripts/verifier-skills.sh" "$work/skills" 2>&1); then
  ok "frontmatter et consignes communes de l'ADR-001"
else
  ko "frontmatter et consignes communes de l'ADR-001 ($out)"
fi

# Corps de la skill, sans le frontmatter
end=$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$skill")
body=$(sed -n "$((${end:-0} + 1)),\$p" "$skill")

# cite <description> <fragment exact>
cite() {
  if grep -qF -- "$2" <<<"$body"; then
    ok "$1"
  else
    ko "$1 (« $2 » absent du corps)"
  fi
}

# --- CA1 : emplacement du livrable ---------------------------------------------

cite "CA1 livrable docs/wf/onboarding.md" "docs/wf/onboarding.md"

# --- CA2 : sections dans l'ordre ------------------------------------------------

sections=(
  "Avant de commencer"
  "Installer le projet"
  "Lancer le projet"
  "Vérifier l'installation"
  "Se repérer dans le code"
  "Contribuer"
  "Glossaire métier"
  "Pour aller plus loin"
  "Points non déterminés"
)
# Titres « ## » du bloc modèle du livrable (```markdown … ```) seulement : une
# mention d'une section ailleurs dans la skill ne doit pas fausser l'ordre.
model=$(awk '/^```markdown$/ { in_block = 1; next } in_block && /^```$/ { exit } in_block' <<<"$body")
titles=()
while IFS= read -r line; do
  titles+=("${line#\#\# }")
done < <(grep -E '^## ' <<<"$model")
order_ok=1
if [ -z "$model" ]; then
  ko "CA2 bloc modèle du livrable (\`\`\`markdown) présent"
  order_ok=0
elif [ "${titles[*]}" != "${sections[*]}" ]; then
  ko "CA2 titres ## du modèle (attendu : ${sections[*]} ; obtenu : ${titles[*]})"
  order_ok=0
fi
[ "$order_ok" -eq 1 ] && ok "CA2 les neuf sections, dans l'ordre"

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

fieldops_values=(
  "FieldOps"
  "src/api/server.ts"
  "mobile/pubspec.yaml"
  "Application web"
  "Application mobile"
  "Intervention"
  "Technician"
  "WorkOrder"
  "db:seed"
  "API_URL"
  "10.0.2.2"
  "fvm, Docker"
)
leak_ok=1
for value in "${fieldops_values[@]}"; do
  if grep -qF -- "$value" <<<"$body"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

# --- Mentions fixes imposées par la spec ----------------------------------------

cite "CA3 mention « version non déterminée »" "version non déterminée"
cite "CA10 mention « aucune convention de contribution trouvée dans le dépôt »" \
  "aucune convention de contribution trouvée dans le dépôt"
cite "CA11 mention « définition non déterminée »" "définition non déterminée"

# --- CA12 : renvoi vers le livrable de wf-doc-projet ----------------------------

cite "CA12 livrable doc-projet en fichier unique" "docs/wf/doc-projet.md"
cite "CA12 livrable doc-projet en dossier" "docs/wf/doc-projet/index.md"
cite "CA12 fichier fonctionnalites.md du format dossier" "fonctionnalites.md"
cite "CA12 fichier structure.md du format dossier" "structure.md"
cite "CA12 section « Architecture »" "Architecture"
cite "CA12 section « Fonctionnalités »" "Fonctionnalités"
cite "CA12 section « Structure du code »" "Structure du code"
cite "CA12 suggestion de lancer /wf-doc-projet" "/wf-doc-projet"

# --- CA15 et CA18 : en-tête -----------------------------------------------------

cite "CA15 mention « hors git »" "hors git"
cite "CA15 mention « modifications non commitées »" "modifications non commitées"
cite "CA18 mention « non couverte en v1 »" "non couverte en v1"

exit $fail
