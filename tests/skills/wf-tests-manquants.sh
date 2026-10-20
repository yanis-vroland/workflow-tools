#!/usr/bin/env bash
# Tests structurels de la skill wf-tests-manquants (spec 012, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-tests-manquants/SKILL.md existe, passe
# la vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 012 impose dans le livrable (titres de sections, mentions
# fixes, chemins, identifiants). Le comportement réel est vérifié par les evals
# evals/tests-manquants-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-tests-manquants"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-tests-manquants : $1"; }
ko() {
  echo "ÉCHEC  wf-tests-manquants : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-tests-manquants/SKILL.md introuvable)"
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

cite "CA1 livrable docs/wf/tests-manquants.md" "docs/wf/tests-manquants.md"

# --- CA2 : sections dans l'ordre ------------------------------------------------

sections=(
  "Synthèse"
  "Outillage de test"
  "Couverture actuelle"
  "Tests manquants"
  "Cas manquants dans le code testé"
  "Squelettes de tests"
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
  ok "CA2 les sept sections, dans l'ordre"
fi

# Le titre du livrable ne doit pas reprendre un nom de section : sinon les
# correcteurs qui délimitent « Tests manquants » se tromperaient de titre.
if grep -qE '^# .*Tests manquants' <<<"$model"; then
  ko "CA2 titre du livrable distinct de la section « Tests manquants »"
else
  ok "CA2 titre du livrable distinct de la section « Tests manquants »"
fi

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

fieldops_values=(
  "FieldOps"
  "interventions.ts"
  "invoice"
  "scheduling"
  "intervention_list_screen"
  "duration_format"
  "computeInvoice"
  "lineAmount"
  "formatDuration"
  "suggestTechnician"
  "loyalCustomer"
)
# Complétés automatiquement par les noms propres aux données des cas : noms
# déclarés ou importés dans les scaffold.sh, dossiers qu'ils créent, identifiants
# composés (camelCase, snake_case) et noms de fichiers cités par les case.yaml.
# Seuls les termes imposés par la spec ou propres au format des cas sont admis.
allowed_terms=" flutter_test integration_test testWidgets toBeCloseTo toStrictEqual toEqual typescript
  allowed_tools file_exists file_path input_match last_message max_turns not_contains
  scaffold_script schema_version timeout_seconds tool_used config format types serve
  python vitest _test coverage describe "
allowed_terms=" $(tr '[:upper:]\n' '[:lower:] ' <<<"$allowed_terms" | tr -s ' ') "
case_terms() {
  {
    cat "$root"/evals/tests-manquants-*/scaffold.sh |
      grep -oE '\b(export (async )?(function|const|class|interface|type)|def|class) [A-Za-z_][A-Za-z0-9_]*' |
      awk '{ print $NF }'
    grep -ohE 'import \{[^}]*\}' "$root"/evals/tests-manquants-*/scaffold.sh | sed 's/^import //' | tr -c 'A-Za-z0-9_\n' '\n'
    grep -ohE 'mkdir -p [A-Za-z0-9_/ -]+' "$root"/evals/tests-manquants-*/scaffold.sh | sed 's/^mkdir -p //' | tr -s ' /' '\n'
    sed -E 's/\\[bBdDsSwWn]//g; s/\\\././g' "$root"/evals/tests-manquants-*/case.yaml |
      grep -oE '\b[a-z]+[A-Z][A-Za-z0-9]*\b|\b[A-Z][a-z]+[A-Z][A-Za-z0-9]*\b|\b[a-z]+_[a-z_]+\b|[A-Za-z0-9_-]+\.(ts|tsx|dart|py)\b' |
      sed -E 's/\.(ts|tsx|dart|py)$//'
    printf '%s\n' not_found missing_fields invalid_transition
  } | awk 'length($0) >= 5' | sort -u | while IFS= read -r term; do
    case "$allowed_terms" in
      *" $(tr '[:upper:]' '[:lower:]' <<<"$term") "*) ;;
      *) printf '%s\n' "$term" ;;
    esac
  done
}
while IFS= read -r term; do fieldops_values+=("$term"); done < <(case_terms)

# leaks <texte> : affiche les valeurs des cas présentes dans le texte
leaks() {
  local value
  for value in "${fieldops_values[@]}"; do
    grep -qiF -- "$value" <<<"$1" && printf '%s\n' "$value"
  done
}

# Contrôle par mutation : la détection doit voir un nom des données des cas
for probe in estimateQuote pick_channel relay overlaps interventionsRouter missing_fields; do
  if [ -z "$(leaks "$body $probe")" ]; then
    ko "contrôle anti-fuite : « $probe » ajouté à la skill n'est pas détecté"
  fi
done

leak_ok=1
while IFS= read -r value; do
  [ -n "$value" ] || continue
  ko "aucune valeur des données des cas dans la skill (« $value » présent)"
  leak_ok=0
done < <(leaks "$body")
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

# --- CA3 et CA4 : outillage de test ----------------------------------------------

cite "CA3 framework Vitest" "Vitest"
cite "CA3 framework Jest" "Jest"
cite "CA3 framework Playwright" "Playwright"
cite "CA3 commande tirée des scripts de package.json" "scripts"
cite "CA4 flutter_test" "flutter_test"
cite "CA4 integration_test" "integration_test"
cite "CA4 commande flutter test" "flutter test"
cite "CA4 fichiers *_test.dart" "_test.dart"

# --- CA5 et CA6 : couverture actuelle --------------------------------------------

cite "CA5 rapport coverage/lcov.info" "coverage/lcov.info"
cite "CA5 rapport coverage/coverage-summary.json" "coverage/coverage-summary.json"
cite "CA5 rapport antérieur au dernier commit" "antérieur au dernier commit"
cite "CA6 heuristique approximative" "approximative"

# --- CA7 : ni exécution, ni mesure, ni installation ------------------------------

cite "CA7 interdiction de lancer les tests" "ne lance aucun test"
cite "CA7 interdiction de mesurer la couverture" "--coverage"

# --- CA8 à CA11 : entrées de « Tests manquants » ---------------------------------

cite "CA8 identifiant M1" "M1"
cite "CA8 type unitaire" "unitaire"
cite "CA8 type composant ou widget" "composant ou widget"
cite "CA8 type intégration" "intégration"
cite "CA8 type bout en bout" "bout en bout"
cite "CA8 priorité haute" "haute"
cite "CA8 priorité moyenne" "moyenne"
cite "CA8 priorité faible" "faible"
cite "CA8 champ Justification" "Justification"
cite "CA9 même calcul que wf-analyse-projet (12 derniers mois)" '--since="12 months ago"'
cite "CA9 top 10" "10"

# --- CA12 : fichiers sans logique exécutable --------------------------------------

cite "CA12 fichiers générés *.g.dart" "*.g.dart"
cite "CA12 fichiers générés *.freezed.dart" "*.freezed.dart"
cite "CA12 commentaire de génération" "GENERATED CODE"

# --- CA13 à CA16 ------------------------------------------------------------------

cite "CA13 statut « à vérifier »" "à vérifier"
cite "CA14 describe/it" "describe"
cite "CA14 group/test" "group"
cite "CA14 testWidgets" "testWidgets"
cite "CA15 marqueur « à compléter »" "à compléter"
cite "CA16 suggestion à valider" "suggestion à valider"

# --- CA18 à CA24 ------------------------------------------------------------------

cite "CA18 mention « hors git »" "hors git"
cite "CA19 mention « non couverte »" "non couverte"
cite "CA20 identifiant jamais réattribué" "Dernier identifiant attribué"
cite "CA22 message répertoire vide" "Le répertoire est vide : aucun livrable n'a été écrit."
cite "CA22 message sans code source" "Le répertoire ne contient aucun code source : aucun livrable n'a été écrit."
cite "CA23 application de chaque entrée" "Application :"
cite "CA24 dossiers non lus" "dossiers non lus"

# --- CA6 : heuristique de couverture, nom de fichier pris littéralement ----------
# Le bloc de la skill est exécuté sur une liste de fichiers fictive. Un nom
# contenant des caractères de regex (`[id].tsx`, route dynamique) ne doit pas
# être réputé couvert par un test d'un autre fichier (`d.test.tsx`).

heuristic=$(awk '/^```bash$/ { b = 1; buf = ""; next } b && /^```$/ { b = 0; if (buf ~ /stem=/) { print buf; exit } next } b { buf = buf $0 "\n" }' <<<"$body")
if [ -z "$heuristic" ]; then
  ko "CA6 bloc bash de l'heuristique de couverture introuvable"
else
  sandbox="$work/heuristique"
  mkdir -p "$sandbox/src/pages"
  : >"$sandbox/src/pages/[id].tsx"
  printf 'import { Page } from "./d";\n' >"$sandbox/src/pages/d.test.tsx"
  : >"$sandbox/src/pages/d.tsx"
  : >"$sandbox/src/cart.ts"
  printf 'import { total } from "./cart";\n' >"$sandbox/src/cart.test.ts"
  : >"$sandbox/src/orphan.ts"
  listing="printf '%s\\n' 'src/pages/[id].tsx' src/pages/d.test.tsx src/pages/d.tsx src/cart.ts src/cart.test.ts src/orphan.ts"
  script="${heuristic//<commande de l\'étape 2>/$listing}"
  uncovered=$(cd "$sandbox" && bash -c "$script" 2>&1)
  if grep -qxF 'src/pages/[id].tsx' <<<"$uncovered" && grep -qxF 'src/orphan.ts' <<<"$uncovered" &&
    ! grep -qxF 'src/cart.ts' <<<"$uncovered" && ! grep -qxF 'src/pages/d.tsx' <<<"$uncovered"; then
    ok "CA6 heuristique : nom de fichier échappé dans la regex ([id].tsx non couvert)"
  else
    ko "CA6 heuristique : résultat inattendu ($(tr '\n' ' ' <<<"$uncovered"))"
  fi
fi

# --- ADR-001 : fichiers d'environnement jamais affichés par Grep -------------------
# En mode contenu, Grep afficherait les lignes d'un fichier d'environnement
# avant qu'on puisse l'écarter : la skill impose leur exclusion par glob.
cite "ADR-001 exclusion des fichiers d'environnement par glob dans Grep" 'glob: "!**/.env*"'

# --- Correcteurs des evals et commandes Bash prescrites (sans modèle) ---------------
# Commandes de la skill confrontées aux correcteurs Bash « max: 0 », correcteur
# des lanceurs sur exemples, aucun texte du projet substitué dans une commande.

if ! command -v node >/dev/null 2>&1; then
  ko "node introuvable : correcteurs des evals non vérifiés (tests/correcteurs/wf-tests-manquants.mjs)"
elif ! node "$root/tests/correcteurs/wf-tests-manquants.mjs"; then
  fail=1
fi

exit $fail
