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

# --- Commandes des étapes 2 et 6, exécutées sur des noms de fichiers piégés ---------
# Spec 001, CA5 et CA10 (amendement) : on extrait les blocs bash des étapes 2
# (inventaire) et 6 (couverture) du SKILL.md et on les exécute, hors git, sur un
# projet factice. Témoins : un fichier couvert par son nom et un fichier non
# couvert, pour qu'un résultat vide ou plein ne passe pas pour une réussite.

# step_block <numéro d'étape> : premier bloc ```bash de la section « ### <n>. »
step_block() {
  awk -v h="### $1. " '
    index($0, h) == 1 { in_step = 1; next }
    in_step && /^### / { exit }
    in_step && /^```bash$/ { in_code = 1; next }
    in_code && /^```$/ { exit }
    in_code { print }
  ' "$real/SKILL.md"
}

proj="$work/noms-pieges"
mkdir -p "$proj/src"
printf 'export const a = 1;\n' >"$proj/src/a(b.ts"
printf "import { a } from './a(b';\n" >"$proj/src/parenthese.test.ts"
printf 'export const d = 1;\n' >"$proj/src/tiret.ts"
printf "import { d } from './src/tiret';\n" >"$proj/-e.test.ts"
printf 'export const v = 1;\n' >"$proj/-v.ts"
printf "import { v } from './-v';\n" >"$proj/option.test.ts"
printf 'export const p = 1;\n' >"$proj/src/plain.ts"
printf "import { p } from './plain';\n" >"$proj/src/plain.test.ts"
printf 'export const o = 1;\n' >"$proj/src/orphelin.ts"
# Fichier d'environnement nommé comme un module de test JS
env_file=".env.test.js"
printf 'API_KEY=valeur-secrete-factice\n' >"$proj/$env_file"

step2=$(step_block 2)
step6=$(step_block 6)
placeholder="<commande de l'étape 2>"
if [ -z "$step2" ] || [ -z "$step6" ] || ! grep -qF -- "$placeholder" <<<"$step6"; then
  echo "ÉCHEC  CA5/CA10 : blocs bash des étapes 2 et 6 introuvables dans le SKILL.md"
  fail=1
else
  script="inventory() {
$step2
}
${step6//"$placeholder"/inventory}"
  inv_out=$(cd "$proj" && bash -c "$step2" 2>&1)
  cov_out=$(cd "$proj" && bash -c "$script" 2>&1)

  if grep -qE '(^|/)\.env' <<<"$inv_out"; then
    echo "ÉCHEC  CA10 : l'inventaire de l'étape 2 contient un fichier d'environnement ($env_file), lu ensuite par l'étape 6"
    fail=1
  else
    echo "OK     CA10 : l'inventaire de l'étape 2 exclut un fichier d'environnement nommé comme un module JS"
  fi

  # <chemin>|<attendu dans la liste des non couverts : oui/non>|<description>
  for entry in \
    "src/a(b.ts|non|fichier a(b.ts importé par un test déclaré couvert" \
    "src/tiret.ts|non|fichier importé par le test racine -e.test.ts déclaré couvert" \
    "-v.ts|non|fichier racine -v.ts (nom pris pour une option) importé par un test déclaré couvert" \
    "src/plain.ts|non|témoin : fichier couvert par son nom absent des non couverts" \
    "src/orphelin.ts|oui|témoin : fichier non couvert listé"; do
    path=${entry%%|*}
    rest=${entry#*|}
    expected=${rest%%|*}
    description=${rest#*|}
    if grep -qxF -- "$path" <<<"$cov_out"; then listed=oui; else listed=non; fi
    if [ "$listed" = "$expected" ]; then
      echo "OK     CA5 : $description"
    else
      echo "ÉCHEC  CA5 : $description (sortie de l'étape 6 : $(tr '\n' ' ' <<<"$cov_out"))"
      fail=1
    fi
  done
fi

# --- Injection shell par un nom de paquet (amendement de CA3) -----------------------
# Un nom de paquet vient d'un manifeste ou d'un lockfile du projet : il n'est jamais
# recopié dans le texte d'une commande (une apostrophe dans le nom refermerait les
# apostrophes, et `$(…)` s'exécuterait). Il passe par un heredoc à délimiteur entre
# apostrophes, est validé par le shell, puis n'est employé qu'en variable.

skill_md="$real/SKILL.md"
inj="$work/injection"
mkdir -p "$inj/run" "$inj/bin"
injection_ok=1

# shellcheck disable=SC2016 # motifs littéraux
if grep -qE "\"<[^>]+>\"|'<[^>]+>'" "$skill_md"; then
  echo "ÉCHEC  injection : un nom est recopié entre guillemets ou apostrophes dans une commande ($(grep -oE "\"<[^>]+>\"|'<[^>]+>'" "$skill_md" | sort -u | tr '\n' ' '))"
  injection_ok=0
fi
# Une boucle `for` recopie les noms dans le texte de la commande (revue, S4)
if grep -qE '^[[:space:]]*for p in ' "$skill_md"; then
  echo "ÉCHEC  injection : boucle « for p in » sur des noms écrits dans la commande"
  injection_ok=0
fi
# Délimiteur public : un nom égal à une ligne de délimiteur fermerait le heredoc avant
# la vérification du shell ; la skill le fait refuser avant l'écriture du heredoc (S1)
if ! grep -qE "égal à une ligne de délimiteur \(\`WF_NPM_5e1a\`, \`WF_PUB_5e1a\`\).*refuse" "$skill_md"; then
  echo "ÉCHEC  injection : refus préalable d'un nom égal à un délimiteur (WF_NPM_5e1a, WF_PUB_5e1a) absent de la skill"
  injection_ok=0
fi
if ! grep -qF 'nom de paquet invalide, non vérifié' "$skill_md"; then
  echo "ÉCHEC  injection : mention « nom de paquet invalide, non vérifié » absente de la skill"
  injection_ok=0
fi

# Bloc ```bash des registres : celui qui contient les deux heredocs
registry_block=$(awk '
  /^```bash$/ { on = 1; buf = ""; next }
  on && /^```$/ { if (index(buf, "<<'"'"'WF_NPM_5e1a'"'"'") && index(buf, "<<'"'"'WF_PUB_5e1a'"'"'")) { printf "%s", buf; exit } on = 0; next }
  on { buf = buf $0 "\n" }
' "$skill_md")
if [ -z "$registry_block" ]; then
  echo "ÉCHEC  injection : bloc bash des registres avec heredocs <<'WF_NPM_5e1a' et <<'WF_PUB_5e1a' absent"
  injection_ok=0
fi

# Faux curl : note son dernier argument (l'URL) et répond comme un registre
cat >"$inj/bin/curl" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "${@: -1}" >>"$FAKE_LOG"
printf '{"version":"9.9.9","latest":{"version":"9.9.9"}}\n200'
SH
chmod +x "$inj/bin/curl"

# shellcheck disable=SC2016 # noms piégés : substitutions littérales
npm_names=('vite' '@scope/outil' "x'\$(touch pwned1)'" '$(touch pwned2)' '`touch pwned3`' 'y";touch pwned4;"' '.cache' '_priv' '@.x/outil' '@scope/_outil')
# shellcheck disable=SC2016
pub_names=('path_utils' "z'\$(touch pwned5)'")
shells=(bash)
[ -x /bin/zsh ] && shells+=(/bin/zsh)
for sh in "${shells[@]}"; do
  [ -n "$registry_block" ] || break
  : >"$inj/log"
  script=$(NPM_BODY="$(printf '%s\n' "${npm_names[@]}")" PUB_BODY="$(printf '%s\n' "${pub_names[@]}")" awk '
    $0 == "<nom npm>" { print ENVIRON["NPM_BODY"]; next }
    $0 == "<nom pub>" { print ENVIRON["PUB_BODY"]; next }
    { print }' <<<"$registry_block")
  out=$(cd "$inj/run" && PATH="$inj/bin:$PATH" FAKE_LOG="$inj/log" "$sh" -c "$script" 2>&1)
  if compgen -G "$inj/run/pwned*" >/dev/null; then
    echo "ÉCHEC  injection ($sh) : un nom piégé a exécuté une commande"
    for f in "$inj"/run/pwned*; do rm -f "$f"; done
    injection_ok=0
  fi
  expected_urls=$'https://registry.npmjs.org/vite/latest\nhttps://registry.npmjs.org/@scope%2Foutil/latest\nhttps://pub.dev/api/packages/path_utils'
  if [ "$(cat "$inj/log")" != "$expected_urls" ]; then
    echo "ÉCHEC  injection ($sh) : registres interrogés inattendus ($(tr '\n' ' ' <"$inj/log"))"
    injection_ok=0
  fi
  # 9 : 4 noms piégés npm, 4 noms npm commençant par `.` ou `_` (nom ou portée), 1 nom piégé pub
  if [ "$(grep -c 'nom de paquet invalide, non vérifié' <<<"$out")" -ne 9 ]; then
    echo "ÉCHEC  injection ($sh) : 9 noms invalides signalés attendus ($out)"
    injection_ok=0
  fi
done
[ "$injection_ok" -eq 1 ] && echo "OK     injection : noms de paquets transmis par heredoc, validés par le shell, noms piégés refusés (bash, zsh)"
[ "$injection_ok" -eq 1 ] || fail=1



# --- Risque transverse (amendement de CA8) -------------------------------------------
# Un risque transverse (couverture, dépendances…) cite lui aussi un fichier : un renvoi
# à une autre section du livrable ne le remplace pas (série r17).
if grep -qE "risque transverse.*cite.*fichier.*renvoi à une autre section" "$real/SKILL.md"; then
  echo "OK     CA8 : un risque transverse cite un fichier, pas un renvoi à une autre section"
else
  echo "ÉCHEC  CA8 : règle du risque transverse (fichier cité, pas de renvoi à une autre section) absente de la skill"
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
