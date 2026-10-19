#!/usr/bin/env bash
# shellcheck disable=SC2016 # accents graves littéraux (commandes Markdown) dans les motifs
# Tests structurels de la skill wf-recette (spec 014, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-recette/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 014 impose mot pour mot dans le livrable (sections,
# colonnes du tableau, statuts, sous-sections de « Couverture », mentions
# fixes, chemins du contrat avec wf-specs-tickets). Le comportement réel est
# vérifié par les evals evals/recette-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-recette"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-recette : $1"; }
ko() {
  echo "ÉCHEC  wf-recette : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-recette/SKILL.md introuvable, spec 014)"
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

# Bloc modèle du livrable (```markdown … ```) : les vérifications d'ordre et de
# forme portent sur lui seul, une mention ailleurs dans la skill ne compte pas.
model=$(awk '/^```markdown$/ { in_block = 1; next } in_block && /^```$/ { exit } in_block' <<<"$body")
if [ -z "$model" ]; then
  ko "bloc modèle du livrable (\`\`\`markdown) présent"
fi

# in_model <description> <fragment exact>
in_model() {
  if grep -qF -- "$2" <<<"$model"; then
    ok "$1"
  else
    ko "$1 (« $2 » absent du modèle du livrable)"
  fi
}

# --- CA1 : emplacement du livrable ---------------------------------------------

cite "CA1 livrable docs/wf/recette.md" "docs/wf/recette.md"

# --- CA2 : sections dans l'ordre ------------------------------------------------

sections=(
  "Périmètre et sources"
  "Prérequis"
  "Cas de recette"
  "Couverture"
  "Synthèse de la campagne"
  "Points non déterminés"
)
titles=()
while IFS= read -r line; do
  titles+=("${line#\#\# }")
done < <(grep -E '^## ' <<<"$model")
if [ "${titles[*]}" = "${sections[*]}" ]; then
  ok "CA2 les six sections du modèle, dans l'ordre"
else
  ko "CA2 titres ## du modèle (attendu : ${sections[*]} ; obtenu : ${titles[*]})"
fi

# --- CA3 : colonnes du tableau et identifiants -----------------------------------

header_line="| ID | Fonctionnalité | Préconditions | Étapes | Résultat attendu | Source | Statut | Commentaire |"
in_model "CA3 en-tête du tableau des cas, colonnes dans l'ordre" "$header_line"
in_model "CA3 identifiant REC-001" "REC-001"
cite "CA3 identifiants uniques" "unique"

# --- CA4, CA5, CA13 : forme de la colonne Source -----------------------------------

cite "CA4 source d'un critère de spec (chemin#CAn)" "docs/specs/"
cite "CA4 ancre du critère" "#CA"
cite "CA5 livrable de wf-specs-tickets (contrat de la spec 006)" "docs/wf/specs-tickets.md"
cite "CA5 source d'un critère de ticket (#Tnn-CAn)" "docs/wf/specs-tickets.md#T"
cite "CA5 sous-sections de ticket « Tnn : <titre> »" "Tnn : "
cite "CA5 rubrique « Critères d'acceptation » d'un ticket" "Critères d'acceptation"
cite "CA13 mention « spec brouillon »" "spec brouillon"
cite "CA13 statut « brouillon » d'une spec" "brouillon"

# --- CA6 : cas déduits du code -----------------------------------------------------

cite "CA6 avertissement : comportement actuel du code" "comportement actuel du code"
cite "CA6 avertissement : validation par le client" "validés par le client"

# --- CA8 : statuts admis --------------------------------------------------------

for status in "à tester" "conforme" "non conforme" "bloqué"; do
  cite "CA8 statut « $status »" "$status"
done

# --- CA9 et CA10 : relance -------------------------------------------------------

cite "CA9 identifiants jamais réutilisés : dernier identifiant attribué" "Dernier identifiant attribué"
in_model "CA10 sous-section « Cas retirés »" "Cas retirés"

# --- CA11, CA12 : couverture ------------------------------------------------------

in_model "CA11 sous-section « Critères non recettables manuellement »" \
  "Critères non recettables manuellement"
in_model "CA12 sous-section « Fonctionnalités sans spec »" "Fonctionnalités sans spec"

# Ordre des sous-sections de « Couverture » dans le modèle
cov=$(awk '/^## Couverture/ { in_cov = 1; next } in_cov && /^## / { exit } in_cov' <<<"$model")
cov_titles=$(grep -E '^### ' <<<"$cov" | sed 's/^### //' | tr '\n' '|')
if [ "$cov_titles" = "Critères non recettables manuellement|Fonctionnalités sans spec|Cas retirés|" ] ||
  [ "$cov_titles" = "Critères non recettables manuellement|Fonctionnalités sans spec|Cas hors campagne|Cas retirés|" ]; then
  ok "CA10 à CA12 sous-sections ### de « Couverture »"
else
  ko "CA10 à CA12 sous-sections ### de « Couverture » (obtenu : $cov_titles)"
fi

# --- CA14 : synthèse ---------------------------------------------------------------

cite "CA14 nombre total de cas" "Total"

# --- CA15 : prérequis sans identifiant -------------------------------------------

cite "CA15 rôles nécessaires à la recette" "rôles"
cite "CA15 aucun mot de passe" "mot de passe"

# --- CA16, CA17 : référence git ----------------------------------------------------

cite "CA16 commit de la référence (et échec si elle est inconnue)" "git log -1 --format=%h"
cite "CA16 fichiers modifiés depuis la référence" "git diff --name-only"
cite "CA16 ticket modifié : contenu à la référence" "git show"
cite "CA17 référence inconnue signalée" "introuvable"

# --- CA18, CA19, CA20 : stack, répertoire vide, en-tête ------------------------------

cite "CA18 mention « non couverte en v1 »" "non couverte en v1"
cite "CA19 aucun livrable dans un répertoire vide" "aucun cahier de recette n'a été écrit"
cite "CA20 mention « hors git »" "hors git"
cite "CA20 mention « modifications non commitées »" "modifications non commitées"
in_model "CA20 en-tête : outil" "Outil : wf-recette"

# --- Injection shell : la référence n'entre dans une commande qu'après filtrage ------

cite "CA16, CA17 caractères admis dans une référence avant toute commande" \
  "Si l'argument contient autre chose que des lettres, chiffres, \`.\`, \`_\`, \`/\` et \`-\`, ou commence par \`-\`, ne lance aucune commande avec lui"
cite "CA16, CA17 référence jamais entre guillemets" "sans guillemets"
# Aucune commande prescrite (entre accents graves) ne place un texte variable
# <…> entre guillemets doubles, où $(…) ou des accents graves seraient évalués.
if grep -qE '`[^`]*"[^"`]*<[^>`]+>[^"`]*"[^`]*`' <<<"$body"; then
  ko "aucune commande avec un texte variable entre guillemets doubles"
else
  ok "aucune commande avec un texte variable entre guillemets doubles"
fi
# Seules les commandes de la liste blanche citent <ref>
unexpected=$(grep -oE '`git [^`]*<ref>[^`]*`' <<<"$body" | sort -u |
  grep -vxF -e '`git log -1 --format=%h <ref> --`' -e '`git diff --name-only <ref> HEAD`' \
    -e '`git show <ref>:docs/wf/specs-tickets.md`' || true)
if [ -z "$unexpected" ]; then
  ok "CA16 seules les trois commandes prescrites reçoivent la référence"
else
  ko "CA16 commande inattendue avec la référence ($unexpected)"
fi

# --- CA21 : Grep jamais en mode contenu sur un fichier d'environnement -------------

cite "CA21 Grep toujours limité par glob à des extensions de code" \
  "Avec Grep, passe toujours le paramètre \`glob\` limité à des extensions de code"
glob_example=$(grep -oE 'Avec Grep[^`]*`glob`[^`]*`[^`]*`' <<<"$body" | head -n 1)
if grep -qE 'md|env|txt|json|yml|yaml' <<<"${glob_example##*\`glob\`}"; then
  ko "CA21 le glob d'exemple de Grep n'inclut ni Markdown ni fichier de configuration ($glob_example)"
else
  ok "CA21 le glob d'exemple de Grep n'inclut ni Markdown ni fichier de configuration"
fi

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

fieldops_values=(
  "FieldOps"
  "001-interventions"
  "002-ordres-de-travail"
  "003-export-pdf"
  "technicians.ts"
  "seed.ts"
  "dispatcher"
  "Intervention"
  "WorkOrder"
  "SEED_PASSWORD"
  "changeme"
  "MAP_API_KEY_EXPIRES_AT"
  "purge"
  "Express"
  "connecté"
  "cache"
  "centile"
  "simultanés"
  "e-mail reçu"
  "accès refusé"
  "Planifiée"
  "En cours"
  "congé"
  "créneau"
  "pagination"
  "PDF"
)
leak_ok=1
for value in "${fieldops_values[@]}"; do
  # Mot entier : « changeme » ne doit pas être trouvé dans « changements ».
  if grep -qwF -- "$value" <<<"$body"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

exit $fail
