#!/usr/bin/env bash
# Tests structurels de la skill wf-passation (spec 016, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-passation/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 016 impose mot pour mot dans le livrable (titres de
# sections, mentions fixes, chemins, en-têtes de tableaux). Le comportement réel
# est vérifié par les evals evals/passation-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-passation"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-passation : $1"; }
ko() {
  echo "ÉCHEC  wf-passation : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-passation/SKILL.md introuvable)"
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

# absent <description> <motif ERE>
absent() {
  if grep -qE -- "$2" <<<"$body"; then
    ko "$1 (motif « $2 » présent dans le corps)"
  else
    ok "$1"
  fi
}

# --- CA1 : emplacement du livrable ---------------------------------------------

cite "CA1 livrable docs/wf/passation.md" "docs/wf/passation.md"

# --- CA2 : sections dans l'ordre ------------------------------------------------

sections=(
  "Synthèse"
  "Documentation de référence"
  "Environnements et déploiement"
  "Services tiers et accès"
  "Secrets à transmettre"
  "Travaux en cours"
  "Points d'attention"
  "Checklist de passation"
  "Points non déterminés"
)
# Titres « ## » du bloc modèle du livrable (```markdown … ```) seulement.
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
  ok "CA2 les neuf sections, dans l'ordre"
fi

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

fieldops_values=(
  "FieldOps"
  "REGISTRY_TOKEN"
  "DEPLOY_TOKEN"
  "MAP_API_KEY"
  "JWT_SECRET"
  "PAYMENT_WEBHOOK_SECRET"
  "example.invalid"
  "feat/export-pdf"
  "notifications-push"
  "mapClient.ts"
  "mailer.ts"
  "payment.ts"
  "src/api/routes/interventions.ts"
  "5b26289"
  "STRIPE_SECRET_KEY"
  "FLY_API_TOKEN"
  "203.0.113"
)
leak_ok=1
for value in "${fieldops_values[@]}"; do
  if grep -qF -- "$value" <<<"$body"; then
    ko "aucune valeur des fixtures dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur des fixtures dans la skill"

# --- CA3 : documentation de référence, livrables internes exclus -----------------

cite "CA3 livrable interne analyse-projet exclu" "analyse-projet"
cite "CA3 livrable interne chiffrage exclu" "chiffrage"
cite "CA3 livrable interne revue-securite exclu" "revue-securite"
cite "CA3 livrable wf-exploitation (spec 018) cité" "docs/wf/exploitation.md"
cite "CA3 livrable wf-onboarding cité" "docs/wf/onboarding.md"

# --- CA4 : renvoi vers le livrable de wf-doc-projet ----------------------------

cite "CA4 livrable doc-projet en fichier unique" "docs/wf/doc-projet.md"
cite "CA4 livrable doc-projet en dossier" "docs/wf/doc-projet/index.md"
cite "CA4 fichier installation.md du format dossier" "installation.md"
cite "CA4 fichier configuration.md du format dossier" "configuration.md"
cite "CA4 section « Stack technique »" "Stack technique"
cite "CA4 section « Architecture »" "Architecture"
cite "CA4 section « Installation et lancement »" "Installation et lancement"
cite "CA4 section « Configuration »" "Configuration"
cite "CA4 suggestion de lancer /wf-doc-projet" "/wf-doc-projet"

# --- CA5 et CA6 : déploiement -----------------------------------------------------

for file in Dockerfile "docker-compose" vercel.json netlify.toml fly.toml firebase.json; do
  cite "CA5 configuration de déploiement repérée ($file)" "$file"
done
cite "CA6 mention « procédure de déploiement non trouvée dans le dépôt »" \
  "procédure de déploiement non trouvée dans le dépôt"

# --- CA7 et CA8 : services tiers et secrets -------------------------------------

cite "CA7 champ « titulaire du compte : à compléter »" "titulaire du compte : à compléter"
cite "CA8 en-tête du tableau des secrets" "| Secret | Utilisé pour | Référencé dans | Comment l'obtenir |"
cite "CA8 mention du canal sécurisé" "à transmettre par un canal sécurisé, hors de ce document"

# --- CA9 : fichiers d'environnement -----------------------------------------------

cite "CA9 fichiers d'environnement non lus (.env.example seul)" ".env.example"

# --- CA10 et CA11 : travaux en cours ----------------------------------------------

cite "CA10 branches non fusionnées (git branch -a --no-merged)" "git branch -a --no-merged"
cite "CA10 commits d'avance (git rev-list --count)" "git rev-list --count"
cite "CA10 date du dernier commit sans nom d'auteur (git log -1 --format=%cs)" "git log -1 --format=%cs"
cite "CA10 mention de la dernière récupération" "dernière récupération"
cite "CA11 branche principale par origin/HEAD" "refs/remotes/origin/HEAD"
cite "CA11 branche principale main" "refs/heads/main"
cite "CA11 branche principale master" "refs/heads/master"
absent "Hors périmètre : aucune récupération distante prescrite" '`git (fetch|pull|ls-remote|remote update)'

# --- CA12 à CA14 : points d'attention et checklist -------------------------------

cite "CA12 marqueurs TODO" "TODO"
cite "CA12 marqueurs FIXME" "FIXME"
cite "CA12 marqueurs HACK" "HACK"
cite "CA12 plafond de 20 fichiers" "20 fichiers"
cite "CA14 en-tête du tableau de la checklist" "| Action | Source | Statut |"
cite "CA14 statut « à faire »" "à faire"
cite "CA14 ligne « dépôt de code »" "dépôt de code"

# --- CA17, CA18, CA19, CA21, CA22, CA23 -----------------------------------------

cite "CA17 champ « à compléter »" "à compléter"
cite "CA18 mention « hors git »" "hors git"
cite "CA18 mention « non applicable »" "non applicable"
cite "CA19 mention « non couverte en v1 »" "non couverte en v1"
cite "CA21 mention « modifications non commitées »" "modifications non commitées"
cite "CA22 message sans code source" "Aucun code source trouvé dans ce répertoire"
cite "CA23 mention « à paramétrer au redéploiement »" "à paramétrer au redéploiement"
cite "CA23 paramètre <serveur>" "<serveur>"
cite "CA23 paramètre <registre>" "<registre>"

exit $fail
