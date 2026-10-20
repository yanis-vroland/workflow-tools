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
cite "CA3 identifiants uniques" "vérifie que chaque identifiant est unique dans le livrable"

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

cite "CA8 statuts admis, et eux seuls" \
  "les seuls statuts admis sont « à tester », « conforme », « non conforme » et « bloqué »"
cite "CA8 l'outil n'attribue que « à tester »" \
  "Tu n'attribues jamais toi-même un autre statut que « à tester »"

# --- CA9 et CA10 : relance -------------------------------------------------------

cite "CA9 identifiants jamais réutilisés : dernier identifiant attribué" "Dernier identifiant attribué"
in_model "CA10 sous-section « Cas retirés »" "Cas retirés"

# CA9 : les saisies humaines des cas hors campagne survivent à la relance
# suivante. L'étape de lecture du cahier existant relève aussi ces entrées, et
# les règles de rapprochement les réintègrent ou les reconduisent.
step5=$(awk '/^## Étape 5/ { in_step = 1; next } in_step && /^## / { exit } in_step' <<<"$body")
if grep -qF -- "chaque entrée de « Cas hors campagne » : ID, Fonctionnalité, Source, Statut, Commentaire" <<<"$step5"; then
  ok "CA9 la relance relève les entrées de « Cas hors campagne » (statut et commentaire)"
else
  ko "CA9 la relance relève les entrées de « Cas hors campagne » (absent de l'étape 5)"
fi
cite "CA9 un cas hors campagne qui rentre dans le périmètre revient au tableau" \
  "revient au tableau avec son ID, son Statut et son Commentaire"
cite "CA9 un cas hors campagne toujours hors périmètre est reconduit tel quel" \
  "reconduit tel quel sous « Cas hors campagne »"

# --- CA11, CA12 : couverture ------------------------------------------------------

in_model "CA11 sous-section « Critères non recettables manuellement »" \
  "Critères non recettables manuellement"
in_model "CA12 sous-section « Fonctionnalités sans spec »" "Fonctionnalités sans spec"

# Ordre des sous-sections de « Couverture » dans le modèle
cov=$(awk '/^## Couverture/ { in_cov = 1; next } in_cov && /^## / { exit } in_cov' <<<"$model")
cov_titles=$(grep -E '^### ' <<<"$cov" | sed 's/^### //' | tr '\n' '|')
# « Cas hors campagne » est obligatoire : il porte les saisies des cas hors du
# périmètre d'une campagne sur référence (CA9, CA16).
if [ "$cov_titles" = "Critères non recettables manuellement|Fonctionnalités sans spec|Cas hors campagne|Cas retirés|" ]; then
  ok "CA9 à CA12 sous-sections ### de « Couverture », « Cas hors campagne » compris"
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

# La skill donne l'expression des références admises ; on l'applique à des
# exemples : les formes usuelles passent, tout caractère qui permettrait une
# injection ou une option est rejeté.
ref_re=$(grep -oE 'Référence admise si elle vérifie l.expression `[^`]+`' <<<"$body" | sed -E 's/.*`([^`]+)`$/\1/')
if [ -z "$ref_re" ]; then
  ko "CA16, CA17 expression des références admises absente"
else
  ref_ok=1
  for ref in v1.3.0 HEAD~3 'v1.2.0^' main feat/T07-planning 5b26289 release-2.0; do
    [[ $ref =~ $ref_re ]] || {
      ko "CA16 référence usuelle « $ref » rejetée par $ref_re"
      ref_ok=0
    }
  done
  # shellcheck disable=SC2088 # tilde littéral voulu
  for ref in '-x' '--output=f' '$(id)' '`id`' 'a"b' "a'b" 'a b' 'a;b' 'a|b' 'a:b' '~/x' '^x' 'a$b' 'a{1}' 'a*' 'a&b' 'a>b'; do
    [[ $ref =~ $ref_re ]] && {
      ko "CA17 référence dangereuse « $ref » admise par $ref_re"
      ref_ok=0
    }
  done
  [ "$ref_ok" -eq 1 ] && ok "CA16, CA17 expression des références admises ($ref_re)"
fi
cite "CA16, CA17 référence jamais entre guillemets" "sans guillemets"
# Injection d'option git : une référence qui commence par « - » (nom de branche
# valide pour git) ferait lire une option, même entre apostrophes.
cite "CA17 référence commençant par « - » jamais insérée" \
  "Une valeur qui commence par \`-\` n'est jamais insérée dans une commande"
eoo_missing=$(grep -oE '`git [^`]*<ref>[^`]*`' <<<"$body" | grep -vF -- '--end-of-options <ref>' || true)
if [ -z "$eoo_missing" ] && grep -qF -- '--end-of-options <ref>' <<<"$body"; then
  ok "CA16, CA17 chaque commande git qui reçoit la référence porte --end-of-options juste avant elle"
else
  ko "CA16, CA17 --end-of-options absent avant la référence (${eoo_missing:-aucun gabarit avec <ref>})"
fi
# Aucune commande prescrite (entre accents graves) ne place un texte variable
# <…> entre guillemets doubles, où $(…) ou des accents graves seraient évalués.
if grep -qE '`[^`]*"[^"`]*<[^>`]+>[^"`]*"[^`]*`' <<<"$body"; then
  ko "aucune commande avec un texte variable entre guillemets doubles"
else
  ok "aucune commande avec un texte variable entre guillemets doubles"
fi
# Seules les commandes de la liste blanche citent <ref>
unexpected=$(grep -oE '`git [^`]*<ref>[^`]*`' <<<"$body" | sort -u |
  grep -vxF -e '`git log -1 --format=%h --end-of-options <ref> --`' -e '`git diff --name-only --end-of-options <ref> HEAD`' \
    -e '`git show --end-of-options <ref>:docs/wf/specs-tickets.md`' || true)
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

# --- Aucune valeur propre à la fixture FieldOps ni aux cas d'eval --------------------
# Les exemples de la skill restent génériques : sinon les evals mesureraient la
# recopie d'un exemple, pas le comportement (surapprentissage). Les valeurs sont
# dérivées à l'exécution de la fixture et des cas, pour suivre leurs évolutions ;
# une valeur que la spec 014 ou la spec 006 (contrat) impose est admise. Tout le
# fichier est contrôlé, frontmatter compris.

fixture="$root/tests/fixtures/fieldops"
leak_values=(FieldOps WorkOrder Intervention SEED_PASSWORD changeme MAP_API_KEY_EXPIRES_AT
  PRODUCTION_DATABASE_URL Express connecté cache centile simultanés "e-mail reçu" "accès refusé")
while IFS= read -r v; do leak_values+=("$v"); done < <(
  {
    # noms des specs, routes, écrans, modules et workflows de la fixture
    find "$fixture/docs/specs" "$fixture/src" "$fixture/mobile/lib" "$fixture/.github" -type f 2>/dev/null |
      sed -E 's#.*/##; s#\.md$##'
    # arguments des commandes des cas
    sed -nE 's#^/wf-recette[[:space:]]+##p' "$root"/evals/recette-*/prompt.md
    # empreintes et identifiants des correcteurs
    cat "$root"/evals/recette-*/graders/*.md | grep -oE '\b[0-9a-f]{7}\b|REC-[0-9]{3}|T[0-9]{2}-CA[0-9]+'
    # libellés entre « » des scaffolds et des specs de la fixture
    cat "$root"/evals/recette-*/scaffold.sh "$fixture"/docs/specs/*.md | grep -oE '« [^»]+ »' | sed -E 's/^« //; s/ »$//'
  } | sort -u
)
specs_text=$(cat "$root/docs/specs/014-wf-recette.md" "$root/docs/specs/006-wf-specs-tickets.md")
skill_text=$(cat "$skill")
leaks=()
for value in "${leak_values[@]}"; do
  [ -n "$value" ] || continue
  grep -qwF -- "$value" <<<"$specs_text" && continue
  # Titres du modèle du livrable (ex. « Cas hors campagne », cité par un scaffold
  # qui dépose un cahier existant) : imposés par la skill elle-même.
  grep -qxE -- "#{1,3} $value" <<<"$model" && continue
  # Mot entier : « changeme » ne doit pas être trouvé dans « changements ».
  if grep -qwF -- "$value" <<<"$skill_text"; then leaks+=("$value"); fi
done
if [ "${#leaks[@]}" -eq 0 ]; then
  ok "aucune valeur de la fixture ni des cas d'eval dans la skill (${#leak_values[@]} valeurs contrôlées)"
else
  ko "aucune valeur de la fixture ni des cas d'eval dans la skill (présentes : ${leaks[*]})"
fi

# --- Correcteurs des evals : motifs compilés et vérifiés sur des exemples ------------

if ! command -v node >/dev/null; then
  ko "node introuvable : correcteurs des evals non vérifiés (tests/correcteurs/wf-recette.mjs)"
elif node "$root/tests/correcteurs/wf-recette.mjs"; then
  ok "correcteurs des evals recette-* (tests/correcteurs/wf-recette.mjs)"
else
  ko "correcteurs des evals recette-* (tests/correcteurs/wf-recette.mjs)"
fi

exit $fail
