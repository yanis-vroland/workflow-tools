#!/usr/bin/env bash
# Tests structurels de la skill wf-chiffrage (spec 005, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-chiffrage/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), et cite les
# éléments que la spec 005 impose : chemin du livrable et sections (contrat lu
# par wf-specs-tickets), colonnes des tableaux de tâches, identifiants Cnn,
# entrée par défaut (contrat de la spec 004), mentions fixes. Le comportement
# réel est vérifié par les evals evals/chiffrage-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-chiffrage"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-chiffrage : $1"; }
ko() {
  echo "ÉCHEC  wf-chiffrage : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-chiffrage/SKILL.md introuvable, spec 005)"
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

# --- CA1 : livrable et entrée par défaut ------------------------------------------

cite "CA1 livrable docs/wf/chiffrage.md" "docs/wf/chiffrage.md"
cite "CA1 entrée par défaut docs/wf/cadrage-besoin.md" "docs/wf/cadrage-besoin.md"

# --- CA2 : sections dans l'ordre, titres ## du modèle du livrable ---------------

sections=(
  "Synthèse"
  "Périmètre chiffré"
  "Détail par lot"
  "Activités transverses"
  "Hypothèses"
  "Exclusions"
  "Risques"
  "Points non déterminés"
)
# Titres « ## » du bloc modèle du livrable (```markdown … ```) seulement : une
# mention d'une section ailleurs dans la skill ne doit pas fausser l'ordre.
model=$(awk '/^```markdown$/ { in_block = 1; next } in_block && /^```$/ { exit } in_block' <<<"$body")
titles=()
while IFS= read -r line; do
  titles+=("${line#\#\# }")
done < <(grep -E '^## ' <<<"$model")
if [ -z "$model" ]; then
  ko "CA2 bloc modèle du livrable (\`\`\`markdown) présent"
elif [ "${titles[*]}" != "${sections[*]}" ]; then
  ko "CA2 titres ## du modèle (attendu : ${sections[*]} ; obtenu : ${titles[*]})"
else
  ok "CA2 les huit sections, dans l'ordre"
fi

# --- CA3 : en-tête ----------------------------------------------------------------

cite "CA3 en-tête : outil nommé" "Outil : wf-chiffrage"
cite "CA3 en-tête : fichier d'entrée" "Fichier d'entrée :"
cite "CA3 mention « modifications non commitées »" "modifications non commitées"

# --- CA4 : colonnes des tableaux de tâches (dans le modèle) -----------------------

table_header='| Identifiant | Tâche | Besoins couverts | Estimation basse (j) | Estimation haute (j) | Commentaire |'
if grep -qF -- "$table_header" <<<"$model"; then
  ok "CA4 en-tête de tableau des tâches dans le modèle"
else
  ko "CA4 en-tête de tableau des tâches dans le modèle (« $table_header » absent)"
fi
# Le tableau figure dans « Détail par lot » ET dans « Activités transverses »
count=$(grep -cF -- "$table_header" <<<"$model")
if [ "$count" -ge 2 ]; then
  ok "CA4 tableau dans « Détail par lot » et « Activités transverses »"
else
  ko "CA4 tableau dans « Détail par lot » et « Activités transverses » ($count occurrence(s) dans le modèle)"
fi
cite "CA4 identifiant de tâche C01" "C01"

# --- CA5, CA6, CA7 : règles d'estimation ------------------------------------------

cite "CA5 pas de 0,5 jour" "0,5"
cite "CA6 plafond de 5 jours" "5 jours"

# --- CA8 : totaux -----------------------------------------------------------------

cite "CA8 total bas" "Total bas"
cite "CA8 total haut" "Total haut"

# --- CA12, CA22 : mentions fixes --------------------------------------------------

cite "CA12 mention « non chiffrable en l'état »" "non chiffrable en l'état"
cite "CA22 mention « développement à partir de zéro »" "développement à partir de zéro"

# --- CA16 : livrable de wf-analyse-projet -----------------------------------------

cite "CA16 entrée complémentaire docs/wf/analyse-projet.md" "docs/wf/analyse-projet.md"
cite "CA16 section « Dette et risques »" "Dette et risques"
cite "CA16 mention « aucune tâche affectée »" "aucune tâche affectée"

# --- CA18 : identifiants jamais réattribués ---------------------------------------

cite "CA18 dernier identifiant attribué dans l'en-tête" "Dernier identifiant attribué"

# --- CA19, CA21 : renvoi vers wf-cadrage-besoin ----------------------------------

cite "CA19, CA21 renvoi vers /wf-cadrage-besoin" "/wf-cadrage-besoin"

# --- CA14 : aucun montant dans le modèle ------------------------------------------

if grep -qE -- '€|\$|\bEUR\b|\bTJM\b' <<<"$model"; then
  ko "CA14 aucun symbole ni code monétaire dans le modèle du livrable"
else
  ok "CA14 aucun symbole ni code monétaire dans le modèle du livrable"
fi

# --- Aucune valeur propre aux fixtures FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals mesureraient la
# recopie d'un exemple, pas le comportement (surapprentissage).

fieldops_values=(
  "FieldOps"
  "Démo Thermique"
  "src/api"
  "src/web"
  "interventions.ts"
  "InterventionList"
  "build.gradle"
  "chaudière"
  "dispatcher"
  "technicien"
  "purge"
  "MAP_API_KEY"
  "mailer"
  "cahier-des-charges"
  "ordre-du-jour"
  "tableau de bord"
  "hors connexion"
  "stores"
)
leak_ok=1
for value in "${fieldops_values[@]}"; do
  if grep -qiF -- "$value" <<<"$body"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

exit $fail
