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

# --- Consignes des questions posées pendant l'exécution ---------------------------
# Simple présence de la consigne dans la skill : ce n'est pas une preuve du
# comportement, vérifié par les evals compte-rendu-ca15-*, -ca17-* (dont
# compte-rendu-ca17-nouvelle-reunion pour le suffixe).

cite "consigne du suffixe -2 d'une nouvelle réunion (CA17)" "-2.md"
cite "consigne : jamais la date du jour sans la demander (CA15)" "date du jour"

# --- Injection shell ---------------------------------------------------------------
# Un texte venu de l'utilisateur ou des notes (chemin, objet) ne doit jamais être
# inséré dans une commande entre guillemets doubles : il passe par l'entrée
# standard, dans un heredoc à délimiteur entre apostrophes.

if grep -qE '"<[^">]+>"' <<<"$body"; then
  ko "aucun texte de l'utilisateur entre guillemets doubles dans une commande ($(grep -oE '"<[^">]+>"' <<<"$body" | head -n 1))"
else
  ok "aucun texte de l'utilisateur entre guillemets doubles dans une commande"
fi
if grep -qF "sys.argv" <<<"$body"; then
  ko "objet passé par l'entrée standard (sys.argv présent)"
else
  ok "objet passé par l'entrée standard (pas de sys.argv)"
fi
cite "objet lu sur l'entrée standard" "sys.stdin.read()"
cite "heredoc de l'objet à délimiteur entre apostrophes" "<<'WF_OBJET'"
cite "heredoc du chemin à délimiteur entre apostrophes" "<<'WF_CHEMIN'"

# --- CA18 : formats acceptés -----------------------------------------------------

for ext in .txt .md .vtt .srt; do
  cite "CA18 format accepté $ext" "\`$ext\`"
done

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals mesureraient la
# recopie d'un exemple, pas le comportement.

# Noms, dates, formulations et valeurs de la fixture fieldops-brief et des
# données des cas evals/compte-rendu-*, cherchés dans tout SKILL.md (frontmatter
# compris).
fieldops_values=(
  "FieldOps" "Sophie" "Renaud" "Marc Olivier" "Julien" "Ferrand" "Inès" "Garnier"
  "Hugo" "Lemaire" "Nadia" "Benali" "Paul Girard" "Claire Morel"
  "Camille" "Durand" "Tom Becker" "Priya" "Natarajan"
  "Recette2026" "recette-sdt" "export PDF" "tableur" "point-hebdo" "point hebdomadaire"
  "Weekly sync" "release 1.3" "iOS 16" "atelier" "Revue de sprint" "chantier"
  "14/10" "9/10" "10/10" "12/10" "16/10" "17/10" "vendredi" "7 octobre"
  "07/10/2026" "14/10/2026" "Oct 7" "October 28"
  "on garde" "on valide" "we agree" "00:00:04" "00:00:05" "00:00:11"
  "5b26289" "2fc99c0" "notes-reunion" "equipe-sud" "equipe-nord"
)
leak_ok=1
for value in "${fieldops_values[@]}"; do
  if grep -qiF -- "$value" "$skill"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

# --- Correcteurs des evals : compilation, exemples, commande du nom de fichier ------

if ! command -v node >/dev/null 2>&1; then
  ko "node introuvable : correcteurs des evals non vérifiés (tests/correcteurs/wf-compte-rendu.mjs)"
elif ! node "$root/tests/correcteurs/wf-compte-rendu.mjs"; then
  ko "correcteurs des evals (tests/correcteurs/wf-compte-rendu.mjs)"
fi

exit $fail
