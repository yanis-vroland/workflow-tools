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
leak_ok=1
for value in "${fieldops_values[@]}"; do
  if grep -qiF -- "$value" <<<"$body"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
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
