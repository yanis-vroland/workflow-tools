#!/usr/bin/env bash
# Tests structurels de la skill wf-montee-version (spec 013, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-montee-version/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), cite les libellés
# que la spec 013 impose mot pour mot dans le livrable (titres de sections,
# mentions fixes, chemins, commandes), que ses blocs bash sont syntaxiquement
# valides, et que les motifs des correcteurs de ses evals se comportent comme
# prévu (tests/correcteurs/wf-montee-version.mjs). Le comportement réel est
# vérifié par les evals evals/montee-version-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-montee-version"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-montee-version : $1"; }
ko() {
  echo "ÉCHEC  wf-montee-version : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-montee-version/SKILL.md introuvable)"
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

# --- CA1 : emplacement du livrable, aucun autre fichier --------------------------

cite "CA1 livrable docs/wf/montee-version.md" "docs/wf/montee-version.md"

# --- CA2 : sections dans l'ordre ------------------------------------------------

sections=(
  "Synthèse"
  "Inventaire des versions"
  "Cibles retenues"
  "Ruptures et impacts"
  "Plan de montée"
  "Vérifications"
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

# --- CA3 : inventaire des dépendances directes -----------------------------------

cite "CA3 manifeste npm" "package.json"
cite "CA3 manifeste pub" "pubspec.yaml"
cite "CA3 lockfile npm" "package-lock.json"
cite "CA3 lockfile pnpm" "pnpm-lock.yaml"
cite "CA3 lockfile yarn" "yarn.lock"
cite "CA3 lockfile pub" "pubspec.lock"
cite "CA3 registre npm" "registry.npmjs.org"
cite "CA3 registre pub.dev" "pub.dev"
cite "CA3 écart majeur" "majeur"
cite "CA3 écart mineur" "mineur"
cite "CA3 écart correctif" "correctif"
cite "CA3 écart à jour" "à jour"
cite "CA3 usage devDependencies" "devDependencies"
cite "CA3 usage dev_dependencies" "dev_dependencies"
cite "CA3 colonne contrainte déclarée" "Contrainte déclarée"
cite "CA3 colonne dernière publiée" "Dernière publiée"

# --- CA4 à CA6 : environnement d'exécution et SDK --------------------------------

cite "CA4 .nvmrc" ".nvmrc"
cite "CA4 .node-version" ".node-version"
cite "CA4 engines" "engines"
cite "CA4 Dockerfile" "Dockerfile"
cite "CA4 dernière version LTS" "LTS"
cite "CA5 environment.sdk" "environment.sdk"
cite "CA5 environment.flutter" "environment.flutter"
cite "CA5 .fvmrc" ".fvmrc"
cite "CA5 .fvm/fvm_config.json" ".fvm/fvm_config.json"
cite "CA5 dernière version stable de Flutter" "stable"
cite "CA6 calendrier endoflife.date" "endoflife.date"
cite "CA6 fin de support" "fin de support"

# --- CA7 : registre injoignable -------------------------------------------------

cite "CA7 registre injoignable" "injoignable"
cite "CA7 repli signalé dans Points non déterminés" "Points non déterminés"

# --- CA8 à CA10 : argument et cibles ---------------------------------------------

cite "CA8 exemple d'argument paquet" "/wf-montee-version vue 3"
cite "CA8 exemple d'argument SDK" "/wf-montee-version flutter 3.27"
cite "CA9 et CA26 aucun livrable écrit" "aucun livrable n'a été écrit"
cite "CA10 lot unique mineur et correctif" "lot unique"
cite "CA10 une cible par dépendance en écart majeur, jamais regroupée" "jamais regroupée avec une autre dépendance"
cite "CA10 ordre des cibles retenues" "Ordre de « Cibles retenues »"
cite "CA3 nom invalide cité tel quel" "cité tel qu'il figure dans le manifeste"
cite "CA19 écart sans lockfile fondé sur la contrainte" "Sans lockfile, l'écart se calcule"
cite "CA13 rupture = changement précis" "Une rupture est un changement précis"
cite "CA12 changement précis connu sans source : listé « non vérifiée »" "même sans source consultée"
cite "CA12 consultation obligatoire du changelog pub.dev" "consultation est obligatoire"
cite "CA12 exigence du registre : pas une rupture" "n'est pas une rupture : elle relève des exigences"

# --- CA11 : livrable de wf-revue-securite -----------------------------------------

cite "CA11 livrable de sécurité lu" "docs/wf/revue-securite.md"
cite "CA11 section lue" "Dépendances vulnérables"
cite "CA11 première version corrigée" "première version corrigée"
cite "CA11 contrat spec 010 : application de l'entrée (CA24)" "l'application concernée"
cite "CA11 contrat spec 010 : base d'avis injoignable (CA8)" "non déterminé (base d'avis injoignable)"

# --- CA8, CA9 : gabarits de vérification d'une cible pub et cible sans version --------

# shellcheck disable=SC2016 # motif littéral : on cherche le texte « $p/versions/$v »
if grep -qE 'pub\.dev/api/packages/\$p/versions/\$v' <<<"$(awk '/^```bash$/ { b = 1; next } b && /^```$/ { b = 0 } b' <<<"$body")"; then
  ok "CA9 gabarit de vérification d'une version pub (/versions/<x.y.z>)"
else
  ko "CA9 gabarit de vérification d'une version pub (/versions/<x.y.z>) absent des blocs bash"
fi
cite "CA8 cible passée sans version" "sans version"
cite "CA8 dépendance entraînée seulement si le registre l'exige" "n'est entraînée que si les métadonnées du registre"

# --- CA12 à CA14 : ruptures --------------------------------------------------------

cite "CA12 identifiant R1" "R1"
cite "CA12 rupture non vérifiée" "non vérifiée"
cite "CA13 sans impact identifié" "sans impact identifié"
cite "CA14 dépendance pair" "peerDependencies"
cite "CA14 contrainte environment.sdk" "environment.sdk"

# --- CA15 : commandes du gestionnaire --------------------------------------------

cite "CA15 npm install" "npm install"
cite "CA15 pnpm add" "pnpm add"
cite "CA15 yarn add" "yarn add"
cite "CA15 flutter pub add" "flutter pub add"
cite "CA15 flutter pub upgrade" "flutter pub upgrade"

# --- CA16 et CA17 : vérifications ------------------------------------------------

cite "CA16 flutter analyze" "flutter analyze"
cite "CA16 flutter test" "flutter test"
cite "CA17 aucun script de test ni de build" "aucun script de test ni de build"

# --- CA18 et CA21 : synthèse ---------------------------------------------------------

cite "CA18 plan sans étape" "aucune étape"
cite "CA21 effort faible" "faible"
cite "CA21 effort moyen" "moyen"
cite "CA21 effort élevé" "élevé"

# --- CA19, CA22, CA23 ---------------------------------------------------------------

cite "CA19 lockfile absent" "aucun lockfile"
cite "CA22 stack non couverte" "non couverte"
cite "CA22 exemple composer.json" "composer.json"
cite "CA22 exemple pyproject.toml" "pyproject.toml"
cite "CA23 aucune valeur périmée de l'ancien livrable" "ne cite plus aucune valeur périmée de l'ancien"

# --- CA24 : argument dans l'en-tête -------------------------------------------------

header=$(grep -m1 -E '^Outil : wf-montee-version' <<<"$model")
if [ -z "$header" ]; then
  ko "CA24 ligne d'en-tête « Outil : wf-montee-version » dans le modèle"
else
  for fragment in "Date :" "Commit :" "modifications non commitées" "Argument :"; do
    if grep -qF -- "$fragment" <<<"$header"; then
      ok "CA24 en-tête : « $fragment »"
    else
      ko "CA24 en-tête : « $fragment » absent de la ligne d'en-tête du modèle"
    fi
  done
fi
cite "ADR-001 hors git" "hors git"

# --- CA20 : aucune installation ni exécution ----------------------------------------

cite "CA20 aucune installation" "Aucune installation"
cite "CA20 ni branche ni commit" "ni branche ni commit"

# --- CA26 à CA28 ---------------------------------------------------------------------

cite "CA26 répertoire vide" "Le répertoire est vide : aucun livrable n'a été écrit."
cite "CA26 sans manifeste" "Aucun manifeste de dépendances trouvé : aucun livrable n'a été écrit."
cite "CA27 versions différentes entre applications" "versions différentes"
cite "CA28 dossiers non lus" "dossiers non lus"
cite "CA28 impacts partiels" "impacts partiels"

# --- Aucune valeur propre à la fixture FieldOps -------------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

fieldops_values=(
  "FieldOps"
  "react-dom"
  "ReactDOM"
  "main.tsx"
  "geolocator"
  "express"
  "fieldops_companion"
  "3.13.9"
  "18.19.0"
  "17.0.2"
  "0.13.6"
  "mobile/"
  "lodash"
  "pluck"
  "react"
  "19.2.0"
  "purge"
  "MAP_API_KEY_EXPIRES_AT"
  "2027-03-31"
  "PRODUCTION_DATABASE_URL"
  "apps/web"
)

# Valeurs dérivées automatiquement de la fixture FieldOps, des scaffolds et des
# correcteurs des cas : noms des dépendances déclarées, versions x.y.z, chemins
# de fichiers (avec un dossier). Une nouvelle valeur ajoutée à un cas est donc
# couverte sans mettre à jour la liste ci-dessus.
fixture="$root/tests/fixtures/fieldops"
cases_dir="$root/evals"
derived=$(
  {
    # Dépendances npm (« "nom": "^x" ») et pub (« nom: ^x ») de la fixture et des scaffolds
    cat "$fixture/package.json" "$fixture/mobile/pubspec.yaml" "$cases_dir"/montee-version-*/scaffold.sh |
      grep -oE '^[[:space:]]*"[^"]+": "[~^]?[0-9]|^[[:space:]]+[a-z0-9_]+: [~^]?[0-9]' |
      sed -E 's/^[[:space:]]*"?([^":]+)"?: .*/\1/'
    # Versions x.y.z des manifestes, lockfiles, scaffolds et correcteurs
    cat "$fixture/package.json" "$fixture/package-lock.json" "$fixture/mobile/pubspec.yaml" \
      "$fixture/mobile/pubspec.lock" "$fixture/mobile/.fvmrc" "$fixture/.nvmrc" \
      "$cases_dir"/montee-version-*/scaffold.sh "$cases_dir"/montee-version-*/graders/*.md |
      grep -oE '\b[0-9]+\.[0-9]+\.[0-9]+\b'
    # Chemins avec un dossier : fichiers de la fixture, fichiers créés par les scaffolds
    (cd "$fixture" && find . -type f -path './*/*' | sed 's|^\./||')
    grep -hoE '(cat >|mkdir -p )[A-Za-z0-9_./ -]+' "$cases_dir"/montee-version-*/scaffold.sh |
      sed -E 's/^(cat >|mkdir -p )//' | tr ' ' '\n' | grep '/'
  } | grep -vE '^(docs/wf(/|$)|\.fvm/fvm_config\.json$)' |
    grep -vxE 'path|http|flutter|flutter_test|version|tsx' | sort -u
)
# leak_scan <texte> : affiche les valeurs dérivées présentes dans le texte (casse ignorée)
leak_scan() {
  local text=$1 value escaped
  while IFS= read -r value; do
    [ -n "$value" ] || continue
    # shellcheck disable=SC2001,SC2016 # échappement des métacaractères de la valeur
    escaped=$(sed 's/[.[\*^$()+?{}|\\]/\\&/g' <<<"$value")
    if grep -qiE -- "(^|[^A-Za-z0-9_@./-])${escaped}([^A-Za-z0-9_-]|$)" <<<"$text"; then
      printf '%s\n' "$value"
    fi
  done <<<"$derived"
}
for value in "${fieldops_values[@]}"; do
  if grep -qiF -- "$value" <<<"$body"; then
    leak_hits+=$'\n'"$value"
  fi
done
leak_hits+=$'\n'"$(leak_scan "$body")"
leak_hits=$(grep -v '^$' <<<"${leak_hits:-}" | sort -u)
if [ "$(wc -l <<<"$derived")" -lt 30 ]; then
  ko "aucune valeur des fixtures dans la skill : moins de 30 valeurs dérivées, extraction cassée"
elif [ -n "$leak_hits" ]; then
  ko "aucune valeur des fixtures dans la skill ($(tr '\n' ' ' <<<"$leak_hits"))"
else
  ok "aucune valeur des fixtures dans la skill ($(wc -l <<<"$derived" | tr -d ' ') valeurs dérivées et ${#fieldops_values[@]} fixes, casse ignorée)"
fi
# Contrôle par mutation de la détection
if [ -n "$(leak_scan "Exemple : Geolocator, SRC/Web/Main.tsx, 0.13.6.")" ] && [ -n "$(leak_scan "dépendance dayjs")" ]; then
  ok "aucune valeur des fixtures : mutation détectée (casse ignorée)"
else
  ko "aucune valeur des fixtures : mutation non détectée"
fi

# --- Blocs bash de la skill : syntaxe valide -----------------------------------------

blocks=$(awk '/^```bash$/ { n++; in_block = 1; next } in_block && /^```$/ { in_block = 0; print "#--- fin du bloc " n; next } in_block' <<<"$body")
if [ -z "$blocks" ]; then
  ko "blocs bash présents (commandes des registres)"
elif out=$(bash -n <<<"$blocks" 2>&1); then
  ok "blocs bash syntaxiquement valides"
else
  ko "blocs bash syntaxiquement valides ($out)"
fi

# --- Injection shell : valeurs à substituer dans un heredoc seulement -----------------
# Toute valeur venue du projet ou de l'utilisateur (paramètre <…> à remplacer) passe
# par le corps d'un heredoc à délimiteur entre apostrophes, jamais par la ligne de
# commande : même entre apostrophes, un nom qui contient une apostrophe
# (x'$(touch pwned)') ferme la chaîne et exécute la suite. Le corps d'un tel
# heredoc n'est jamais interprété. Les arguments de la commande (`$ARGUMENTS`,
# `$1`…) ne sont jamais interpolés.
# heredoc_check <blocs> : affiche chaque ligne fautive (paramètre hors heredoc,
# heredoc à délimiteur non protégé) et « heredoc » s'il y a au moins un heredoc protégé
heredoc_check() {
  awk '
    in_doc { if ($0 == delim) in_doc = 0; next }
    {
      line = $0
      gsub(/<<</, "", line)
      if (match(line, /<<-?[ \t]*\047[A-Za-z0-9_]+\047/)) {
        d = substr(line, RSTART, RLENGTH); sub(/^<<-?[ \t]*\047/, "", d); sub(/\047$/, "", d)
        sub(/<<-?[ \t]*\047[A-Za-z0-9_]+\047/, "", line)
        delim = d; in_doc = 1; print "heredoc"
      } else if (line ~ /<<-?[ \t]*["A-Za-z0-9_]/) {
        print "heredoc non protégé : " $0
      }
      if (line ~ /<[A-Za-z@][^<>]*>/) print "paramètre hors heredoc : " $0
    }
  ' <<<"$1"
}
inj=$(heredoc_check "$blocks")
# shellcheck disable=SC2016 # motif littéral : on cherche le texte « $ARGUMENTS »
if grep -qv '^heredoc$' <<<"$inj"; then
  ko "injection shell : $(grep -v '^heredoc$' <<<"$inj" | head -3 | tr '\n' ' ')"
elif ! grep -qx 'heredoc' <<<"$inj"; then
  ko "injection shell : aucun heredoc à délimiteur entre apostrophes dans les blocs bash"
elif grep -qE '\$ARGUMENTS|\$\{?[0-9@*]' <<<"$blocks"; then
  ko "injection shell : argument de la commande interpolé dans un bloc bash"
else
  ok "injection shell : paramètres des blocs bash dans des heredocs protégés seulement"
fi
# Auto-test du contrôle (sans dépendre de la skill)
if heredoc_check "for p in '<paquet>'; do echo \"\$p\"; done" | grep -qv '^heredoc$' &&
  heredoc_check "$(printf 'cat <<FIN\n<paquet>\nFIN')" | grep -qv '^heredoc$' &&
  ! heredoc_check "$(printf "while read -r p; do echo \"\$p\"; done <<'WF_X'\n<paquet>\nWF_X\ngrep x <<<\"\$out\"")" | grep -qv '^heredoc$'; then
  ok "injection shell : auto-test du contrôle (apostrophes et heredoc non protégé refusés, heredoc protégé accepté)"
else
  ko "injection shell : auto-test du contrôle"
fi
cite "injection shell : valeur non conforme jamais dans une commande" "n'entre jamais dans une commande"
cite "Grep en mode contenu : glob ou fichier unique imposé" "jamais un dossier sans \`glob\`"

# --- Correcteurs des evals : exemples positifs et négatifs (sans modèle) -------------

if ! command -v node >/dev/null 2>&1; then
  ko "node introuvable : correcteurs des evals non vérifiés (tests/correcteurs/wf-montee-version.mjs)"
elif ! node "$root/tests/correcteurs/wf-montee-version.mjs"; then
  fail=1
fi

exit $fail
