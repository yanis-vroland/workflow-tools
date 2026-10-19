#!/usr/bin/env bash
# Tests structurels de la skill wf-rapport-avancement (spec 008, ADR-001 et
# amendement 1).
#
# Sans modèle : on vérifie que skills/wf-rapport-avancement/SKILL.md existe,
# passe la vérification commune (.github/scripts/verifier-skills.sh), et cite
# les libellés, chemins et règles que la spec 008 impose mot pour mot (titres de
# sections, mentions fixes, contrats des livrables lus). Le comportement réel
# est vérifié par les evals evals/rapport-avancement-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-rapport-avancement"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-rapport-avancement : $1"; }
ko() {
  echo "ÉCHEC  wf-rapport-avancement : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-rapport-avancement/SKILL.md introuvable)"
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

# absent <description> <fragment exact>
absent() {
  if grep -qF -- "$2" <<<"$body"; then
    ko "$1 (« $2 » présent dans le corps)"
  else
    ok "$1"
  fi
}

# --- CA1 : emplacement du livrable ---------------------------------------------

cite "CA1 livrable docs/wf/rapport-avancement.md" "docs/wf/rapport-avancement.md"

# --- CA2 : sections dans l'ordre ------------------------------------------------

sections=(
  "Synthèse"
  "Réalisé"
  "En cours"
  "Prochaines étapes"
  "Points de vigilance"
  "Décisions attendues"
  "Points non déterminés"
  "Sources"
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

header=$(awk '/^## / { exit } { print }' <<<"$model")
for fragment in "wf-rapport-avancement" "Date" "Commit" "Période" "modifications non commitées"; do
  if grep -qF -- "$fragment" <<<"$header"; then
    ok "CA3 en-tête du modèle : « $fragment »"
  else
    ko "CA3 en-tête du modèle : « $fragment » absent avant la première section"
  fi
done
if grep -qE 'wf-' <<<"$(grep -vF 'Outil' <<<"$header")"; then
  ok "CA3 en-tête du modèle : livrables wf- lus"
else
  ko "CA3 en-tête du modèle : aucune ligne pour les livrables wf- lus"
fi
cite "CA3 en-tête : commit court" "git rev-parse --short HEAD"

# --- CA4 et CA5 : période -----------------------------------------------------------

cite "CA4 période en argument au format AAAA-MM-JJ" "AAAA-MM-JJ"
cite "CA4 bornes incluses" "incluses"
cite "CA4 date de commit (et non d'auteur)" "date de commit"
cite "CA5 lendemain de la date de fin du rapport précédent" "lendemain"

# --- CA6 : branche principale ---------------------------------------------------------

cite "CA6 origin/HEAD consulté" "git symbolic-ref --short refs/remotes/origin/HEAD"
cite "CA6 repli sur main" "\`main\`"
cite "CA6 repli sur master" "\`master\`"

# --- CA8 : travaux techniques internes ----------------------------------------------

cite "CA8 entrée « Travaux techniques internes »" "Travaux techniques internes"
for type in chore ci test refactor build style docs; do
  cite "CA8 type $type listé" "\`$type\`"
done

# --- CA9 : sources --------------------------------------------------------------------

cite "CA9 commits de fusion exclus" "--no-merges"
cite "CA9 chaque commit une seule fois" "une seule fois"

# --- CA10 : branches non fusionnées -----------------------------------------------------

cite "CA10 branches non fusionnées" "--no-merged"

# --- CA11 et CA12 : prochaines étapes -----------------------------------------------------

cite "CA11 livrable de wf-specs-tickets" "docs/wf/specs-tickets.md"
cite "CA11 section « Tickets » du contrat 006" "Tickets"
cite "CA11 rapprochement approximatif" "approximatif"
cite "CA11 convention recommandée par wf-specs-tickets" "wf-specs-tickets"
cite "CA12 « non déterminé » sans livrable de tickets" "non déterminé"
cite "CA12 aucune étape déduite des TODO" "TODO"

# --- CA13 : décisions attendues -----------------------------------------------------------

cite "CA13 dossier des comptes rendus" "docs/wf/compte-rendu/"
cite "CA13 section « Questions en suspens » du contrat 007" "Questions en suspens"
cite "CA13 mention « aucune identifiée »" "aucune identifiée"

# --- CA14 : vigilance ------------------------------------------------------------------------

cite "CA14 revert systématique" "revert"
cite "CA14 source « réponse de l'utilisateur »" "réponse de l'utilisateur"

# --- CA15 à CA17 -------------------------------------------------------------------------------

cite "CA15 synthèse en 5 phrases au plus" "5 phrases"
cite "CA16 aucun nom de contributeur" "contributeur"
cite "CA17 aucun pourcentage d'avancement" "pourcentage"

# --- CA18 : fichiers d'environnement versionnés ------------------------------------------------

cite "CA18 diff sans les fichiers d'environnement" ":(exclude,glob)**/.env*"

# --- CA19 à CA24 : cas limites -------------------------------------------------------------------

cite "CA19 mention « Aucune modification intégrée sur la période »" \
  "Aucune modification intégrée sur la période"
cite "CA21 période invalide" "invalide"
cite "CA23 clone superficiel" "git rev-parse --is-shallow-repository"
cite "CA24 diff consulté" "git show"

# --- Entrées : ni réseau ni git fetch --------------------------------------------------------------

cite "Entrées : interdiction de git fetch" "git fetch"
absent "Aucun champ auteur demandé à git (%an)" "%an"
absent "Aucun champ auteur demandé à git (%ae)" "%ae"
absent "Aucun appel à git shortlog" "git shortlog"

# --- Injection shell : aucune valeur insérée entre guillemets doubles --------------
# Les valeurs <…> viennent du projet ou de l'utilisateur : entre guillemets
# doubles, $(…) ou une apostrophe inverse seraient interprétés. Les commandes
# git de la skill (blocs bash et spans `git …`) ne mettent donc jamais un
# <placeholder> entre guillemets doubles, et citent toujours <branche> entre
# apostrophes.

commands=$(
  awk '/^```bash$/ { b = 1; next } b && /^```$/ { b = 0; next } b' <<<"$body"
  # shellcheck disable=SC2016 # apostrophes inverses littérales (spans Markdown)
  grep -oE '`git [^`]+`' <<<"$body" | tr -d '`'
)
if grep -E '"[^"]*<[^>"]+>[^"]*"' <<<"$commands" >/dev/null; then
  ko "injection : valeur <…> entre guillemets doubles dans une commande ($(grep -E '"[^"]*<[^>"]+>[^"]*"' <<<"$commands" | head -n 1))"
else
  ok "injection : aucune valeur <…> entre guillemets doubles dans une commande"
fi
if grep -E "(^|[^'.])<branche>" <<<"$commands" >/dev/null; then
  ko "injection : <branche> sans apostrophes dans une commande ($(grep -E "(^|[^'.])<branche>" <<<"$commands" | head -n 1))"
else
  ok "injection : <branche> toujours entre apostrophes"
fi
cite "injection : nom contenant une apostrophe jamais inséré" "apostrophe"
cite "Grep non utilisé (fichiers d'environnement)" "n'utilise pas Grep"

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

fieldops_values=(
  "FieldOps"
  "export-pdf"
  "import-tableur"
  "origin/principale"
  "T07"
  "T10"
  "Marchetti"
  "Brassac"
  "Belkacem"
  "Vasseur"
  "point-hebdomadaire"
  "Export PDF"
  "SMS"
  "technicien"
  "intervention"
  "« maj »"
  "« wip »"
  "corrections"
  "BREAKING CHANGE"
  "T03"
  "package.json"
  "pubspec.yaml"
  "purge"
  "MAP_API_KEY"
  "2027-03-31"
  "PRODUCTION_DATABASE_URL"
  "recette"
  "Camille"
  "tableur"
  "facture"
  "TVA"
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
