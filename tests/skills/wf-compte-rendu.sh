#!/usr/bin/env bash
# Tests structurels de la skill wf-compte-rendu (spec 007, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-compte-rendu/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 007 impose mot pour mot (dossier du livrable, sections
# contractuelles lues par wf-rapport-avancement, colonnes du tableau des
# actions, mentions fixes de l'en-tête, suffixe de doublon, formats acceptés).
# Le comportement réel est vérifié par les evals evals/compte-rendu-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-compte-rendu"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-compte-rendu : $1"; }
ko() {
  echo "ÉCHEC  wf-compte-rendu : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-compte-rendu/SKILL.md introuvable, spec 007)"
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

# Premier bloc modèle du livrable (```markdown … ```) : le compte rendu
model=$(awk '/^```markdown$/ { in_block = 1; next } in_block && /^```$/ { exit } in_block' <<<"$body")

# --- CA1, CA3, CA4 : emplacement et nommage -------------------------------------

cite "CA1 dossier du livrable docs/wf/compte-rendu/" "docs/wf/compte-rendu/"
cite "CA3 nom de fichier AAAA-MM-JJ-<objet>.md" "AAAA-MM-JJ-"
cite "CA3 objet limité à 5 mots" "5 mots"
cite "CA4 index docs/wf/compte-rendu/index.md" "docs/wf/compte-rendu/index.md"
cite "CA4 index du plus récent au plus ancien" "du plus récent au plus ancien"

# --- CA5 : sections contractuelles, dans l'ordre, dans le modèle -----------------

sections=(
  "Objet"
  "Participants"
  "Points abordés"
  "Décisions"
  "Actions"
  "Questions en suspens"
  "Points non déterminés"
)
titles=()
while IFS= read -r line; do
  titles+=("${line#\#\# }")
done < <(grep -E '^## ' <<<"$model")
if [ -z "$model" ]; then
  ko "CA5 bloc modèle du compte rendu (\`\`\`markdown) présent"
elif [ "${titles[*]}" != "${sections[*]}" ]; then
  ko "CA5 titres ## du modèle (attendu : ${sections[*]} ; obtenu : ${titles[*]})"
else
  ok "CA5 les sept sections, dans l'ordre, avec leurs noms exacts"
fi

# --- CA6, CA19 : en-tête ----------------------------------------------------------

model_cite() {
  if grep -qF -- "$2" <<<"$model"; then
    ok "$1"
  else
    ko "$1 (« $2 » absent du modèle du compte rendu)"
  fi
}
model_cite "CA6 en-tête : outil" "wf-compte-rendu"
model_cite "CA6 en-tête : date de la réunion" "Date de la réunion"
model_cite "CA6 en-tête : source des notes" "Source des notes"
cite "CA2, CA6 source « notes fournies dans la conversation »" "notes fournies dans la conversation"
cite "CA19 mention « hors git »" "hors git"
cite "CA6 mention « modifications non commitées »" "modifications non commitées"

# --- CA7 : tableau des actions ---------------------------------------------------

if grep -qE '^\|[[:space:]]*Action[[:space:]]*\|[[:space:]]*Responsable[[:space:]]*\|[[:space:]]*Échéance[[:space:]]*\|[[:space:]]*$' <<<"$model"; then
  ok "CA7 tableau Action | Responsable | Échéance dans le modèle"
else
  ko "CA7 tableau Action | Responsable | Échéance dans le modèle (en-tête de tableau absent)"
fi
cite "CA7 cellule « non déterminé »" "non déterminé"

# --- CA2, CA15, CA17 : questions posées pendant l'exécution ----------------------

cite "CA17 suffixe -2 pour une nouvelle réunion" "-2.md"
cite "CA15 jamais la date du jour sans la demander" "date du jour"

# --- CA18 : formats acceptés -----------------------------------------------------

for ext in .txt .md .vtt .srt; do
  cite "CA18 format accepté $ext" "\`$ext\`"
done

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals mesureraient la
# recopie d'un exemple, pas le comportement.

fieldops_values=(
  "FieldOps"
  "Sophie"
  "Renaud"
  "Marc Olivier"
  "Julien"
  "Inès"
  "Recette2026"
  "export PDF"
  "tableur"
  "point-hebdo"
  "point hebdomadaire"
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
