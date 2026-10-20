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
cite "CA21 période invalide" "**Période invalide**"
cite "CA21 date mal formée ou absente du calendrier" "une date mal formée ou qui n'existe pas au calendrier"
cite "CA21 date de fin antérieure" "une date de fin antérieure à la date de début"
cite "CA21 date de début dans le futur" "une date de début postérieure à la date du jour"
cite "CA21 aucun livrable" "N'écris rien, ne lis pas l'historique"
cite "CA23 clone superficiel" "git rev-parse --is-shallow-repository"
cite "CA24 diff consulté" "git show"

# --- Entrées : ni réseau ni git fetch --------------------------------------------------------------

cite "Entrées : interdiction de git fetch" "git fetch"
absent "Aucun champ auteur demandé à git (%an)" "%an"
absent "Aucun champ auteur demandé à git (%ae)" "%ae"
absent "Aucun appel à git shortlog" "git shortlog"

# --- Injection shell et injection d'option git -------------------------------------
# Les valeurs <…> (dates, branches, hash, identifiants de tickets) viennent du
# projet ou de l'utilisateur. Elles ne s'écrivent que dans le corps d'un
# heredoc à délimiteur entre apostrophes (jamais interprété par le shell), sont
# validées par bash avant tout appel git, et chaque git log ou git show porte
# --end-of-options devant la révision (un nom commençant par « - » serait
# sinon lu comme une option, ex. --output=<fichier>).

delim="WF_VALEURS_3b9e"
# Lignes de commande des blocs bash, hors corps des heredocs
bash_lines=$(awk -v d="$delim" '
  /^```bash$/ { b = 1; next }
  b && /^```$/ { b = 0; h = 0; next }
  b && h && $0 == d { h = 0; next }
  b && h { next }
  b { print; if (index($0, "<<")) h = 1 }
' <<<"$body")
# shellcheck disable=SC2016 # apostrophes inverses littérales (spans Markdown)
inline_git=$(grep -oE '`git [^`]+`' <<<"$body" | tr -d '`')

if [ -z "$bash_lines" ]; then
  ko "injection : blocs bash présents"
fi
if grep -E '<[[:alpha:]][^<>]*>' <<<"$bash_lines$inline_git" >/dev/null; then
  ko "injection : valeur <…> hors du corps d'un heredoc ($(grep -E '<[[:alpha:]][^<>]*>' <<<"$bash_lines$inline_git" | head -n 1))"
else
  ok "injection : valeurs <…> seulement dans le corps des heredocs"
fi
if grep -E '<<' <<<"$bash_lines" | grep -vF "<<'$delim'" >/dev/null; then
  ko "injection : heredoc sans délimiteur entre apostrophes ($(grep -E '<<' <<<"$bash_lines" | grep -vF "<<'$delim'" | head -n 1))"
else
  ok "injection : heredocs à délimiteur entre apostrophes"
fi
if [ "$(grep -cF "<<'$delim'" <<<"$bash_lines")" -ge 3 ]; then
  ok "injection : un heredoc par bloc de commandes (au moins 3)"
else
  ko "injection : moins de 3 blocs à heredoc"
fi
if grep -E 'git (log|show) ' <<<"$bash_lines$inline_git" | grep -vF -- '--end-of-options' >/dev/null; then
  ko "option git : git log ou git show sans --end-of-options ($(grep -E 'git (log|show) ' <<<"$bash_lines$inline_git" | grep -vF -- '--end-of-options' | head -n 1))"
else
  ok "option git : --end-of-options devant chaque révision"
fi

# Validations bash exactes, et règles citées mot pour mot
cite "injection : format de date vérifié" "date_ok='^[0-9]{4}-[0-9]{2}-[0-9]{2}\$'"
cite "injection : format de branche vérifié" "branche_ok='^[A-Za-z0-9._/+][A-Za-z0-9._/+-]*\$'"
cite "injection : branche commençant par un tiret refusée" "\$branche == -*"
cite "injection : branche non fusionnée commençant par un tiret refusée" "\$autre == -*"
cite "injection : hash vérifié" '^[0-9a-f]{7,40}$'
cite "injection : identifiant de ticket vérifié" '^T[0-9]+$'
cite "option git : règle du tiret" \
  "Une valeur qui commence par \`-\` n'est jamais insérée dans une commande"
cite "injection : règle de l'apostrophe et du heredoc" \
  "Une valeur ne s'écrit que dans le corps du heredoc"
cite "injection : branche refusée signalée" "branche non lue : nom refusé"
cite "Grep non utilisé (fichiers d'environnement)" "n'utilise pas Grep"

# --- CA4 : bornes de la période indépendantes du fuseau de la machine ------------
cite "CA4 borne de début élargie au fuseau le plus en avance" "00:00:00 +1400"
cite "CA4 borne de fin élargie au fuseau le plus en retard" "23:59:59 -1200"
cite "CA4 filtre final sur la date de commit (%cs)" "d <= \$2 && \$2 <= f"

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

# Valeurs extraites automatiquement des cas d'eval (case.yaml, scaffold.sh,
# prompt.md, donnees/) : hash, dates, identifiants de tickets, et mots d'au
# moins 6 lettres des motifs des correcteurs absents du texte de la spec 008
# (les mots de la spec, comme les noms de sections, sont légitimes).
# Mots légitimes : ceux de la spec 008 et de l'ADR-001 (consignes communes), et
# les noms d'options git que la skill doit écrire.
spec="$root/docs/specs/008-wf-rapport-avancement.md"
adr="$root/docs/adr/001-conventions-communes-des-outils.md"
git_words="shallow"
case_files=$(find "$root"/evals/rapport-avancement-* -type f \( -name case.yaml -o -name scaffold.sh -o -name prompt.md -o -path '*/donnees/*' \))
if [ -z "$case_files" ]; then
  ko "anti-fuite : aucun fichier de cas d'eval trouvé"
fi
case_text=$(while IFS= read -r f; do cat "$f"; done <<<"$case_files")
extracted=$(
  grep -oE '\b[0-9a-f]{7,40}\b' <<<"$case_text" | grep -E '[a-f]' | grep -E '[0-9]'
  grep -oE '\b[0-9]{4}-[0-9]{2}-[0-9]{2}\b' <<<"$case_text"
  grep -oE '\bT[0-9]{2,}\b' <<<"$case_text"
  grep -E '^ *pattern:' <<<"$case_text" | grep -oE '[[:alpha:]]{6,}' |
    while IFS= read -r word; do
      grep -qiF -- "$word" "$spec" "$adr" - <<<"$git_words" || echo "$word"
    done
)
if [ -z "$extracted" ]; then
  ko "anti-fuite : aucune valeur extraite des cas (extraction cassée)"
fi
while IFS= read -r value; do
  [ -n "$value" ] && fieldops_values+=("$value")
done < <(sort -u <<<"$extracted")

# Comparaison insensible à la casse et aux guillemets (« », ", ', `)
# shellcheck disable=SC2001 # classe de caractères multioctets, plus lisible avec sed
plain_body=$(sed -e "s/[«»\"'\`]//g" <<<"$body")
leak_ok=1
for value in "${fieldops_values[@]}"; do
  plain_value=$(sed -e "s/[«»\"'\`]//g" -e 's/^ *//' -e 's/ *$//' <<<"$value")
  if grep -qiF -- "$plain_value" <<<"$plain_body"; then
    ko "aucune valeur de FieldOps ni des cas dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps ni des cas dans la skill (${#fieldops_values[@]} valeurs)"

exit $fail
