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

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

fixture_values=(
  "FieldOps"
  "interventions"
  "express"
  "body-parser"
  "req.params.id"
  "local_db"
  "auth_service"
  "dev-secret"
  "JWT_SECRET"
  "FAUX_JETON"
  "5b26289"
  "mobile/"
  "API_KEY"
  "tokenKey"
  "httpOnly"
  "localStorage"
  "app.use"
  "router.use"
  "dart-define"
  "defaultValue"
  "CORS ouvert"
  "tentatives de connexion"
  "DELETE /api"
  "requête paramétrée"
)
leak_ok=1
for value in "${fixture_values[@]}"; do
  if grep -qF -- "$value" <<<"$body"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

# --- Injection shell : gabarits des commandes Bash ---------------------------------------
# Un texte venu du projet (nom de paquet, version, identifiant d'avis) n'est inséré
# dans une commande qu'entre apostrophes, après rejet de toute apostrophe : jamais
# entre guillemets doubles, où `$(…)` et les accents graves seraient interprétés.
bash_blocks=$(awk '/^```bash$/ { in_block = 1; next } in_block && /^```$/ { in_block = 0 } in_block' <<<"$body")
if [ -z "$bash_blocks" ]; then
  ko "injection shell : aucun bloc \`\`\`bash dans la skill"
elif grep -qE '"[^"]*<[a-z][^>]*>[^"]*"' <<<"$bash_blocks"; then
  ko "injection shell : gabarit <…> entre guillemets doubles ($(grep -nE '"[^"]*<[a-z][^>]*>[^"]*"' <<<"$bash_blocks" | head -1))"
elif sed -E "s/'<[a-z][^>]*>(@<[a-z][^>]*>)?'//g" <<<"$bash_blocks" | grep -qE '<[a-z][^>]*>'; then
  ko "injection shell : gabarit <…> hors apostrophes"
else
  ok "injection shell : gabarits des commandes entre apostrophes seulement"
fi
cite "injection shell : rejet de l'apostrophe" "ni apostrophe"

exit $fail
