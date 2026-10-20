#!/usr/bin/env bash
# Tests structurels de la skill wf-analyse-projet (spec 001, ADR-001 : tests à
# deux niveaux). Sans modèle : ils vérifient que la skill existe, respecte les
# conventions communes (verifier-skills.sh) et porte les éléments de la spec qui
# doivent figurer textuellement dans le livrable (chemin, sections, mentions).
# Le comportement réel est vérifié par les evals (evals/analyse-projet/).
#
# Le script se vérifie d'abord lui-même sur des skills factices (une vérification
# qui passerait sans implémentation ne prouve rien), puis contrôle la vraie skill.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
verifier="$root/.github/scripts/verifier-skills.sh"
skill_name="wf-analyse-projet"
fail=0

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Sections du livrable, dans l'ordre imposé (spec 001, CA2)
sections=(
  "Synthèse"
  "Stack et dépendances"
  "Architecture"
  "Activité du dépôt"
  "Qualité et tests"
  "Sécurité"
  "Dette et risques"
  "Effort de reprise"
  "Points non déterminés"
)

# Mentions que la skill doit porter textuellement : <CA>|<fragment>
mentions=(
  "CA1|docs/wf/analyse-projet.md"
  "CA15|hors git"
  "CA15|non applicable"
  "CA8|**élevé**"
  "CA8|**moyen**"
  "CA8|**faible**"
  "CA5|approximati"
  "CA20|sous-dossier"
  "CA20|--is-inside-work-tree"
)

# Valeurs propres à la fixture FieldOps (tests/fixtures/), interdites dans la
# skill : un exemple qui reprend les paquets, versions ou chemins de la fixture
# souffle la réponse attendue aux evals (surapprentissage).
fixture_values=(
  "react"
  "express"
  "17.0.2"
  "0.13.6"
  "interventions"
  "invoice"
  "scheduling"
  "mobile/"
  "2fc99c0"
  "FieldOps"
)

# sections_in_order <fichier> : vrai si les neuf sections y figurent dans l'ordre
sections_in_order() {
  local file=$1 section line previous=0
  for section in "${sections[@]}"; do
    line=$(grep -nF -- "$section" "$file" | cut -d: -f1 | awk -v p="$previous" '$1 > p { print; exit }')
    [ -n "$line" ] || return 1
    previous=$line
  done
  return 0
}

# check_skill <dossier de la skill> : affiche les erreurs, code 1 si au moins une
check_skill() {
  local dir=$1 errors=0 entry ca fragment file found
  local skill_md="$dir/SKILL.md"

  if [ ! -f "$skill_md" ]; then
    echo "ERREUR  $skill_md absent (skill non implémentée)"
    return 1
  fi

  # Conventions communes de l'ADR-001, sur la skill seule
  local isolated="$work/isolated-$RANDOM"
  mkdir -p "$isolated"
  cp -R "$dir" "$isolated/$skill_name"
  if ! out=$(bash "$verifier" "$isolated" 2>&1); then
    echo "ERREUR  verifier-skills.sh : $out"
    errors=$((errors + 1))
  fi

  # Textes de la skill : SKILL.md et ses fichiers annexes Markdown
  local all="$work/all-$RANDOM.md"
  find "$dir" -type f -name '*.md' -print0 | LC_ALL=C sort -z | xargs -0 cat >"$all"

  for entry in "${mentions[@]}"; do
    ca=${entry%%|*}
    fragment=${entry#*|}
    if ! grep -qF -- "$fragment" "$all"; then
      echo "ERREUR  $ca : « $fragment » absent de la skill"
      errors=$((errors + 1))
    fi
  done

  for fragment in "${fixture_values[@]}"; do
    if grep -qiwF -- "$fragment" "$all"; then
      echo "ERREUR  surapprentissage : « $fragment » (valeur de la fixture FieldOps) dans la skill"
      errors=$((errors + 1))
    fi
  done

  # CA2 : un même fichier de la skill (SKILL.md ou modèle annexe) donne les neuf
  # sections dans l'ordre
  found=0
  while IFS= read -r -d '' file; do
    if sections_in_order "$file"; then
      found=1
      break
    fi
  done < <(find "$dir" -type f -name '*.md' -print0)
  if [ "$found" -eq 0 ]; then
    echo "ERREUR  CA2 : aucun fichier de la skill ne donne les neuf sections dans l'ordre"
    errors=$((errors + 1))
  fi

  [ "$errors" -eq 0 ]
}

# expect <code attendu> <description> <fragment attendu ou vide> <dossier>
expect() {
  local expected=$1 description=$2 fragment=$3 dir=$4 output code
  output=$(check_skill "$dir" 2>&1)
  code=$?
  [ "$code" -eq 0 ] || code=1
  if [ "$code" -ne "$expected" ]; then
    echo "ÉCHEC  $description (attendu $expected, obtenu $code : $output)"
    fail=1
  elif [ -n "$fragment" ] && ! grep -qF -- "$fragment" <<<"$output"; then
    echo "ÉCHEC  $description (fragment « $fragment » absent : $output)"
    fail=1
  else
    echo "OK     $description"
  fi
}

# --- Auto-vérification sur des skills factices -----------------------------------

fake_body() {
  cat <<'EOF'
Écris le livrable dans `docs/wf/analyse-projet.md` du projet cible, et nulle part ailleurs.
Ne lis aucun fichier d'environnement, sauf `.env.example`.
Ce qui n'a pas pu être établi est marqué « non déterminé ».
Si le répertoire de travail n'est pas propre, ajoute « modifications non commitées » dans l'en-tête.
Ne recopie aucune adresse e-mail de contributeur.
Hors dépôt git, l'en-tête indique « hors git » et l'activité « non applicable ».
Niveaux de risque, sous la forme du modèle :
- **élevé** : description (`chemin`).
- **moyen** : description (`chemin`).
- **faible** : description (`chemin`).
L'heuristique de couverture est approximative.
Lancé dans un sous-dossier d'un dépôt (git rev-parse --is-inside-work-tree), l'en-tête mentionne le sous-dossier.

## Synthèse
## Stack et dépendances
## Architecture
## Activité du dépôt
## Qualité et tests
## Sécurité
## Dette et risques
## Effort de reprise
## Points non déterminés
EOF
}

# fake <nom du cas> <corps> : crée une skill factice et affiche son dossier
fake() {
  local d="$work/fake-$1/$skill_name"
  mkdir -p "$d"
  printf -- '---\nname: %s\ndescription: Diagnostic factice.\n---\n%s\n' "$skill_name" "$2" >"$d/SKILL.md"
  echo "$d"
}

expect 0 "Auto-test : skill factice conforme acceptée" "" "$(fake conforme "$(fake_body)")"
expect 1 "Auto-test : SKILL.md absent refusé" "absent" "$work/inexistant/$skill_name"
expect 1 "Auto-test : consigne commune absente refusée" "verifier-skills" \
  "$(fake sans-env "$(fake_body | grep -vF '.env.example')")"

for entry in "${mentions[@]}"; do
  ca=${entry%%|*}
  fragment=${entry#*|}
  case_name="sans-$(tr -c '[:alnum:]' '-' <<<"$fragment")"
  expect 1 "Auto-test : $ca, « $fragment » absent refusé" "$fragment" \
    "$(fake "$case_name" "$(fake_body | grep -vF -- "$fragment")")"
done

expect 1 "Auto-test : surapprentissage, valeur de la fixture refusée" "react" \
  "$(fake fixture "$(fake_body)
- \`react\` : installée 17.0.2 (\`package-lock.json\`).")"

expect 1 "Auto-test : CA2, section manquante refusée" "CA2" \
  "$(fake sans-section "$(fake_body | grep -vF 'Effort de reprise')")"
expect 1 "Auto-test : CA2, sections dans le désordre refusées" "CA2" \
  "$(fake desordre "$(fake_body | sed -e 's/^## Sécurité$/## TMP/' -e 's/^## Architecture$/## Sécurité/' -e 's/^## TMP$/## Architecture/')")"

d=$(fake modele-annexe "$(fake_body | grep -v '^## ')")
mkdir -p "$d/references"
fake_body | grep '^## ' >"$d/references/modele-livrable.md"
expect 0 "Auto-test : CA2, sections dans un modèle annexe acceptées" "" "$d"

# --- Vraie skill -------------------------------------------------------------------

real="$root/skills/$skill_name"
if output=$(check_skill "$real" 2>&1); then
  echo "OK     $skill_name : skill conforme à la spec 001 (CA1, CA2, CA5, CA8, CA15, CA20), sans valeur de la fixture, et à l'ADR-001"
else
  echo "ÉCHEC  $skill_name : skill non conforme"
  # shellcheck disable=SC2001
  sed 's/^/         /' <<<"$output"
  fail=1
fi

# --- Correcteurs des evals : exemples positifs et négatifs (sans modèle) -------------

if ! command -v node >/dev/null 2>&1; then
  echo "ÉCHEC  node introuvable : correcteurs des evals non vérifiés (tests/correcteurs/wf-analyse-projet.mjs)"
  fail=1
elif ! node "$root/tests/correcteurs/wf-analyse-projet.mjs"; then
  fail=1
fi

exit $fail
