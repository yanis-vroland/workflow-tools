#!/usr/bin/env bash
# Tests structurels de la skill wf-revue-securite (spec 010, ADR-001 et ses
# amendements), lancés par tests/skills.sh.
#
# Sans modèle : on vérifie que les motifs des correcteurs des evals compilent et
# se comportent comme prévu (tests/correcteurs/wf-revue-securite.mjs), que
# skills/wf-revue-securite/SKILL.md existe, passe la vérification commune
# (.github/scripts/verifier-skills.sh), et cite les libellés que la spec 010
# impose mot pour mot (chemin du livrable, sections dans l'ordre, avertissement,
# référentiels, statuts, niveaux, catégories, mentions fixes) ainsi que le
# contrat lu par wf-montee-version (CA21). Le comportement réel est vérifié par
# les evals evals/revue-securite-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-revue-securite"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-revue-securite : $1"; }
ko() {
  echo "ÉCHEC  wf-revue-securite : $1"
  fail=1
}

# --- Correcteurs des evals (sans modèle) -------------------------------------------

if ! command -v node >/dev/null 2>&1; then
  ko "node introuvable : correcteurs des evals non vérifiés (tests/correcteurs/wf-revue-securite.mjs)"
elif node "$root/tests/correcteurs/wf-revue-securite.mjs"; then
  ok "correcteurs des evals : motifs compilés, exemples positifs et négatifs"
else
  ko "correcteurs des evals (tests/correcteurs/wf-revue-securite.mjs)"
fi

# --- Présence et conformité commune -------------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-revue-securite/SKILL.md introuvable)"
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

# --- CA1 : emplacement du livrable ---------------------------------------------------

cite "CA1 livrable docs/wf/revue-securite.md" "docs/wf/revue-securite.md"

# --- CA2 : sections dans l'ordre, dans le bloc modèle du livrable -------------------

sections=(
  "Synthèse"
  "Périmètre et méthode"
  "Dépendances vulnérables"
  "Constats dans le code"
  "Secrets et configuration"
  "Points non déterminés"
)
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
  ok "CA2 les six sections, dans l'ordre"
fi

# --- CA3 : avertissement d'usage interne, dans l'en-tête du modèle ------------------

header=$(awk '/^## / { exit } { print }' <<<"$model")
for fragment in "usage interne" "failles potentiellement non corrigées" "ne doit pas être diffusé hors de l'équipe"; do
  if grep -qF -- "$fragment" <<<"$header"; then
    ok "CA3 en-tête du modèle : « $fragment »"
  else
    ko "CA3 en-tête du modèle : « $fragment » absent avant la première section"
  fi
done
cite "CA3 en-tête : outil" "Outil : wf-revue-securite"
cite "CA3 en-tête : hors git" "hors git"

# --- CA4 : référentiels et limites --------------------------------------------------

cite "CA4 référentiel web" "OWASP Top 10"
cite "CA4 référentiel mobile" "OWASP Mobile Top 10"
cite "CA4 analyse statique" "analyse statique"
cite "CA4 sans test d'intrusion" "test d'intrusion"
cite "CA4 sans exécution du projet" "sans exécution du projet"
cite "CA4 sans analyseur externe" "analyseur externe"
cite "CA4 sans recherche dans l'historique git" "historique git"

# --- CA5 à CA8 : dépendances --------------------------------------------------------

cite "CA5 base d'avis OSV.dev" "api.osv.dev"
cite "CA5 aucune correction publiée" "aucune correction publiée"
cite "CA5 identifiants d'avis (CVE)" "CVE"
cite "CA5 identifiants d'avis (GHSA)" "GHSA"
cite "CA5 sévérité publiée" "sévérité publiée"
cite "CA5 première version corrigée" "première version corrigée"
for lockfile in package-lock.json pnpm-lock.yaml yarn.lock pubspec.lock; do
  cite "CA6 lockfile $lockfile" "$lockfile"
done
cite "CA6 dépendance directe" "directe"
cite "CA6 dépendance transitive" "transitive"
cite "CA7 manifeste package.json" "package.json"
cite "CA7 manifeste pubspec.yaml" "pubspec.yaml"
cite "CA8 base d'avis injoignable" "non déterminé (base d'avis injoignable)"

# --- CA9 à CA11 : forme des constats -------------------------------------------------

for level in "élevé" "moyen" "faible"; do
  cite "CA10 niveau « $level »" "$level"
done
cite "CA9 statut « confirmé »" "confirmé"
cite "CA9 statut « à vérifier »" "à vérifier"

# --- CA12 à CA17 : catégories et règles de détection ----------------------------------

cite "CA12 catégorie « injection »" "injection"
cite "CA13 catégorie « contrôle d'accès »" "contrôle d'accès"
cite "CA15 catégorie « stockage non sécurisé »" "stockage non sécurisé"
cite "CA15 stockage shared_preferences" "shared_preferences"
for name in password secret token apikey api_key; do
  cite "CA14 nom de variable « $name »" "\`$name\`"
done
cite "CA14 valeur masquée" "[masqué]"
cite "CA14 et CA16 fichiers suivis par git" "git ls-files"
cite "CA16 et CA17 exception .env.example" ".env.example"

# --- CA19 à CA25 ----------------------------------------------------------------------

cite "CA19 mention « aucun constat »" "aucun constat"
cite "CA20 identifiants jamais réattribués" "Dernier identifiant attribué"
cite "CA21 contrat lu par wf-montee-version" "wf-montee-version"
cite "CA22 stack non couverte" "non couverte"
cite "CA23 aucun livrable sans code source" "aucun livrable n'a été écrit"
cite "CA25 dossiers non lus" "dossiers non lus"

# --- Aucune valeur propre à la fixture ni aux données des cas ----------------------------
# Les exemples de la skill restent génériques : sinon les evals mesureraient la recopie
# d'un exemple, pas le comportement (surapprentissage). La liste est construite depuis
# les scaffolds, les données (donnees/) et les chemins visés par les correcteurs des
# cas evals/revue-securite-*, complétée à la main par des mots simples et des formules
# de la fixture FieldOps.

# Jetons génériques que la skill doit pouvoir citer (spec 010, ADR-001)
generic_tokens=(
  "docs/wf" "docs/wf/revue-securite.md" "wf-revue-securite" "iOS" "JS/TS" "TypeScript"
  "JavaScript/TypeScript" "OSV.dev" "package.json" "package-lock.json" "lock.json"
  "lock.yaml" "yarn.lock" "pnpm-lock.yaml" "pubspec.yaml" "pubspec.lock" "requirements.txt"
  "rawQuery" "shared_preferences" "pub.dev" "api.osv.dev"
)
is_generic() {
  local t
  for t in "${generic_tokens[@]}"; do
    [ "$t" = "$1" ] && return 0
  done
  return 1
}

case_tokens=$(
  {
    cat "$root"/evals/revue-securite-*/scaffold.sh "$root"/evals/revue-securite-*/donnees/* 2>/dev/null |
      grep -oE '[A-Za-z_][A-Za-z0-9_]*([./-][A-Za-z0-9_]+)+|[a-z]+[A-Z][A-Za-z0-9]*|[A-Z][a-z]+[A-Z][A-Za-z0-9]*|[A-Z][A-Z0-9]*_[A-Z0-9_]+|\b[0-9]+\.[0-9]+\.[0-9]+\b|\bS[0-9]{2,}\b'
    cat "$root"/evals/revue-securite-*/graders/*.md |
      grep -oE '[A-Za-z0-9_]+\\?\.(ts|tsx|js|dart|py|json|yaml|lock|txt)\b' | tr -d '\134'
  } | sort -u
)
if [ "$(wc -l <<<"$case_tokens")" -lt 50 ]; then
  ko "aucune valeur des cas : extraction des jetons trop pauvre ($(wc -l <<<"$case_tokens") jetons)"
fi

fixture_values=(
  "FieldOps" "interventions" "technicians" "legacy" "express" "body-parser" "req.params.id"
  "requireAuth" "local_db" "auth_service" "map_service" "mapApiKey" "dev-secret" "JWT_SECRET"
  "FAUX_" "5b26289" "2fc99c0" "PRODUCTION_DATABASE_URL" "purge" "mobile/" "outils/import"
  "reports.ts" "S11" "S12" ".env.staging" "API_KEY" "tokenKey" "httpOnly" "localStorage"
  "app.use" "router.use" "dart-define" "defaultValue" "CORS ouvert" "tentatives de connexion"
  "DELETE /api" "requête paramétrée"
)
leak_ok=1
while IFS= read -r value; do
  [ -n "$value" ] || continue
  is_generic "$value" && continue
  if grep -qF -- "$value" <<<"$body"; then
    ko "aucune valeur des cas ni de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done < <(printf '%s\n' "${fixture_values[@]}" "$case_tokens")
[ "$leak_ok" -eq 1 ] && ok "aucune valeur des cas ni de FieldOps dans la skill"

# --- Injection shell : forme des commandes Bash ------------------------------------------
# Un texte venu du projet (nom de paquet, version, identifiant d'avis) n'est jamais
# recopié dans le texte d'une commande : bash l'analyserait avant toute validation
# (`x'$(touch pwned)'`). Il passe par l'entrée standard, dans un heredoc à délimiteur
# entre apostrophes, puis est validé en bash avant tout usage.
bash_blocks=$(awk '/^```bash$/ { in_block = 1; next } in_block && /^```$/ { in_block = 0 } in_block' <<<"$body")
# Corps des heredocs retirés : un gabarit <…> ne peut figurer que là
outside=$(awk '
  heredoc != "" { if ($0 == heredoc) heredoc = ""; next }
  match($0, /<<'"'"'[A-Za-z0-9_]+'"'"'/) { heredoc = substr($0, RSTART + 3, RLENGTH - 4) }
  { print }
' <<<"$bash_blocks")
if [ -z "$bash_blocks" ]; then
  ko "injection shell : aucun bloc \`\`\`bash dans la skill"
elif grep -qE '<[a-z][^>]*>' <<<"$outside"; then
  ko "injection shell : gabarit <…> dans le texte d'une commande ($(grep -nE '<[a-z][^>]*>' <<<"$outside" | head -1))"
else
  ok "injection shell : gabarits seulement dans des heredocs"
fi
for block_kind in "api.osv.dev/v1/querybatch" "api.osv.dev/v1/vulns/" "pub.dev/api/packages/"; do
  block=$(awk -v k="$block_kind" '
    /^```bash$/ { in_block = 1; buf = ""; next }
    in_block && /^```$/ { in_block = 0; if (index(buf, k)) print buf; next }
    in_block { buf = buf $0 "\n" }
  ' <<<"$body")
  if grep -qE "<<'[A-Za-z0-9_]+'" <<<"$block"; then
    ok "injection shell : heredoc à délimiteur entre apostrophes ($block_kind)"
  else
    ko "injection shell : heredoc à délimiteur entre apostrophes absent ($block_kind)"
  fi
done
cite "injection shell : ligne contenant le délimiteur écartée" "délimiteur"

# --- Exécution des commandes de la skill, curl simulé ---------------------------------------
# Chaque commande d'interrogation est exécutée dans un répertoire temporaire, curl
# remplacé par une fonction qui renvoie une réponse enregistrée. Les gabarits <…>
# sont remplacés par des entrées hostiles et légitimes, comme le ferait le modèle
# en recopiant un lockfile : nom porteur de `$(touch pwned)`, nom en majuscules
# (JSONStream), réponse paginée, dépendances pub imbriquées.

# run_block <motif du bloc> <fichier de réponse> <lignes de données> : affiche la sortie
run_block() {
  local kind=$1 response=$2 data=$3 block filled dir
  block=$(awk -v k="$kind" '
    /^```bash$/ { in_block = 1; buf = ""; next }
    in_block && /^```$/ { in_block = 0; if (index(buf, k)) print buf; next }
    in_block { buf = buf $0 "\n" }
  ' <<<"$body")
  if grep -qE "<<'[A-Za-z0-9_]+'" <<<"$block"; then
    # Heredoc : les lignes de gabarit sont remplacées par les lignes de données
    filled=$(awk -v data="$data" '
      /<[a-z][^>]*>/ { if (!done) { print data; done = 1 }; next }
      { print }
    ' <<<"$block")
  else
    # Forme historique : gabarits entre apostrophes dans le texte de la commande,
    # remplis avec la première donnée (le modèle recopie le nom tel quel)
    local first name version
    first=$(head -n 1 <<<"$data")
    name=$(awk '{ print (NF == 3 ? $2 : $1) }' <<<"$first")
    version=$(awk '{ print (NF == 3 ? $3 : $2) }' <<<"$first")
    filled=${block//<nom>@<version>/$name@$version}
    filled=${filled//<nom>/$name}
    filled=${filled//<version>/$version}
    filled=${filled//<identifiant>/$name}
  fi
  dir=$(mktemp -d "$work/exec.XXXXXX")
  (
    cd "$dir" || exit 1
    printf 'curl() { cat %q; printf '"'"'\\n200'"'"'; }\n%s\n' "$response" "$filled" >script.sh
    bash script.sh 2>&1
  )
  if [ -e "$dir/pwned" ]; then
    echo "PWNED"
  fi
}

# Nom hostile littéral, sans espace (une ligne de données = champs séparés par des espaces)
# shellcheck disable=SC2016
hostile='x'"'"'$(touch${IFS}pwned)'"'"

printf '%s' '{"results":[{"vulns":[{"id":"GHSA-aaaa-bbbb-cccc","modified":"x"}],"next_page_token":"t1"},{"vulns":[{"id":"GHSA-dddd-eeee-ffff","modified":"y"}]}]}' >"$work/batch.json"
out=$(run_block "api.osv.dev/v1/querybatch" "$work/batch.json" "npm $hostile 1.0.0
npm JSONStream 1.3.5
npm sample-pkg 4.18.2")
if grep -q PWNED <<<"$out"; then
  ko "injection shell : la requête OSV par lot exécute un nom de paquet hostile (fichier pwned créé)"
else
  ok "injection shell : la requête OSV par lot n'exécute pas un nom de paquet hostile"
fi
if grep -qF "npm JSONStream 1.3.5 : GHSA-aaaa-bbbb-cccc" <<<"$out" && grep -qF "npm sample-pkg 4.18.2 : GHSA-dddd-eeee-ffff" <<<"$out"; then
  ok "requête OSV par lot : nom en majuscules accepté, réponse paginée attribuée au bon paquet"
else
  ko "requête OSV par lot : attribution des avis (sortie : $(tr '\n' '|' <<<"$out"))"
fi
if grep -qiE "pagin|next_page_token|incompl" <<<"$out"; then
  ok "requête OSV par lot : réponse paginée signalée"
else
  ko "requête OSV par lot : réponse paginée non signalée"
fi

printf '%s' '{"id":"GHSA-aaaa-bbbb-cccc","details":"long \"texte\" de l avis","aliases":["CVE-2099-0001"],"affected":[{"package":{"name":"sample-pkg","ecosystem":"npm"},"ranges":[{"type":"SEMVER","events":[{"introduced":"0"},{"fixed":"4.19.0"}]}],"versions":["4.17.0","4.18.2"]}],"database_specific":{"severity":"HIGH"}}' >"$work/vuln.json"
out=$(run_block "api.osv.dev/v1/vulns/" "$work/vuln.json" "$hostile
GHSA-aaaa-bbbb-cccc")
if grep -q PWNED <<<"$out"; then
  ko "injection shell : la lecture d'un avis exécute un identifiant hostile (fichier pwned créé)"
else
  ok "injection shell : la lecture d'un avis n'exécute pas un identifiant hostile"
fi
if grep -qF '"fixed":"4.19.0"' <<<"$out" && grep -qF '"severity":"HIGH"' <<<"$out" && ! grep -qF '"details"' <<<"$out" && ! grep -qF '"versions"' <<<"$out"; then
  ok "lecture d'un avis : version corrigée et sévérité gardées, détails et liste des versions retirés"
else
  ko "lecture d'un avis : sortie inattendue ($(head -c 300 <<<"$out"))"
fi

printf '%s' '{"version":"1.1.0","pubspec":{"name":"sample_fonts","dependencies":{"flutter":{"sdk":"flutter"},"http":"^0.12.0+2","path_provider":"^1.4.0"},"dev_dependencies":{"flutter_test":{"sdk":"flutter"}}}}' >"$work/pub.json"
out=$(run_block "pub.dev/api/packages/" "$work/pub.json" "$hostile 1.0.0
sample_fonts 1.1.0")
if grep -q PWNED <<<"$out"; then
  ko "injection shell : la lecture des dépendances pub exécute un nom hostile (fichier pwned créé)"
else
  ok "injection shell : la lecture des dépendances pub n'exécute pas un nom hostile"
fi
if grep -qF '"http"' <<<"$out" && grep -qF '"path_provider"' <<<"$out" && ! grep -qF 'flutter_test' <<<"$out"; then
  ok "dépendances pub : toutes les dépendances déclarées, malgré une dépendance imbriquée (sdk)"
else
  ko "dépendances pub : liste tronquée ou débordante ($(tr '\n' '|' <<<"$out"))"
fi

exit $fail
