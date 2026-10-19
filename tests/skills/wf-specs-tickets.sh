#!/usr/bin/env bash
# Tests structurels de la skill wf-specs-tickets (spec 006, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-specs-tickets/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 006 impose mot pour mot : chemin du livrable, sections
# et rubriques de ticket (contrat lu par wf-rapport-avancement et wf-recette),
# identifiants, mentions fixes, et les noms des livrables et sections lus
# (contrats des specs 004 et 005). Le comportement réel est vérifié par les
# evals evals/specs-tickets-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-specs-tickets"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-specs-tickets : $1"; }
ko() {
  echo "ÉCHEC  wf-specs-tickets : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-specs-tickets/SKILL.md introuvable, spec 006)"
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

# Bloc modèle du livrable (premier ```markdown … ```) : les vérifications d'ordre
# ne portent que sur lui, une mention ailleurs dans la skill ne doit pas les fausser.
model=$(awk '/^```markdown$/ { in_block = 1; next } in_block && /^```$/ { exit } in_block' <<<"$body")
if [ -z "$model" ]; then
  ko "bloc modèle du livrable (\`\`\`markdown) présent"
else
  ok "bloc modèle du livrable (\`\`\`markdown) présent"
fi

# titles <niveau> : titres de ce niveau exact du modèle, sans les dièses
titles_of() {
  grep -E "^$1 " <<<"$model" | sed -E "s/^$1 //"
}

# --- CA1 : emplacement du livrable, entrées ----------------------------------------

cite "CA1 livrable docs/wf/specs-tickets.md" "docs/wf/specs-tickets.md"
cite "CA1 entrée par défaut docs/wf/cadrage-besoin.md (spec 004)" "docs/wf/cadrage-besoin.md"
cite "CA9 entrée complémentaire docs/wf/chiffrage.md (spec 005)" "docs/wf/chiffrage.md"

# --- CA2 : sections du livrable dans l'ordre ---------------------------------------

sections=(
  "Synthèse"
  "Ordre de réalisation"
  "Tickets"
  "Besoins non couverts"
  "Points non déterminés"
)
got=()
while IFS= read -r line; do got+=("$line"); done < <(titles_of '##')
if [ "${got[*]-}" == "${sections[*]}" ]; then
  ok "CA2 les cinq sections ##, dans l'ordre"
else
  ko "CA2 titres ## du modèle (attendu : ${sections[*]} ; obtenu : ${got[*]-})"
fi

# --- CA4 : ticket titré « Tnn : <titre> », rubriques dans l'ordre -----------------

if grep -qE '^### T01 : ' <<<"$model"; then
  ok "CA4 ticket titré « ### T01 : <titre> » dans le modèle"
else
  ko "CA4 ticket titré « ### T01 : <titre> » dans le modèle"
fi

rubrics=(
  "Récit utilisateur"
  "Contexte"
  "Critères d'acceptation"
  "Hors périmètre"
  "Dépendances"
  "Besoins couverts"
  "Estimation"
  "Fichiers concernés"
  "Points à clarifier"
)
# Rubriques du premier ticket du modèle seulement
first_ticket=$(awk '/^### T01 : / { in_t = 1; next } in_t && /^##?#? / { exit } in_t' <<<"$model")
got=()
while IFS= read -r line; do got+=("$line"); done < <(grep -E '^#### ' <<<"$first_ticket" | sed -E 's/^#### //')
if [ "${got[*]-}" == "${rubrics[*]}" ]; then
  ok "CA4 les neuf rubriques ####, dans l'ordre"
else
  ko "CA4 rubriques #### du ticket T01 (attendu : ${rubrics[*]} ; obtenu : ${got[*]-})"
fi

cite "CA4 récit utilisateur « En tant que…, je veux…, afin de… »" "En tant que"
cite "CA4 récit utilisateur, « je veux »" "je veux"
cite "CA4 récit utilisateur, « afin de »" "afin de"

# --- CA5 : critères numérotés au format Étant donné / quand / alors ---------------

if grep -qE '^- CA1 : Étant donné .*, quand .*, alors ' <<<"$model"; then
  ok "CA5 critère « - CA1 : Étant donné…, quand…, alors… » dans le modèle"
else
  ko "CA5 critère « - CA1 : Étant donné…, quand…, alors… » dans le modèle"
fi

# --- CA6 : termes interdits sans valeur mesurable ------------------------------------

for term in rapide simple intuitif facile convivial performant; do
  cite "CA6 terme interdit sans valeur mesurable « $term »" "$term"
done

# --- CA7, CA8 : identifiants de besoins du cadrage -----------------------------------

cite "CA7 section lue « Besoins fonctionnels » (contrat spec 004)" "Besoins fonctionnels"
cite "CA11 section lue « Questions au client » (contrat spec 004)" "Questions au client"
cite "CA11 champ « Réponse : » du cadrage" "Réponse :"
cite "CA7, CA8 identifiants Bnn repris tels quels" "dont tu reprends l'identifiant \`Bnn\` tel quel"

# --- CA9, CA10 : chiffrage ------------------------------------------------------------

cite "CA9 section lue « Détail par lot » (contrat spec 005)" "Détail par lot"
cite "CA9 section lue « Activités transverses » (contrat spec 005)" "Activités transverses"
# shellcheck disable=SC2016 # accents graves littéraux, sans substitution
cite "CA9 identifiants Cnn" 'identifiant `Cnn` (`C01`, `C02`…)'
cite "CA9 sans réestimation" "Tu ne réestimes jamais"
cite "CA9 mention « non estimé »" "indique exactement « non estimé »"
cite "CA10 seuil de 5 jours d'estimation haute cumulée" "la somme de leurs estimations hautes est d'au plus 5 jours"

# --- CA11 : points à clarifier ---------------------------------------------------------

cite "CA11 mention « aucun »" "écris exactement « aucun »"
cite "CA11 question répondue jamais citée" "Une question dont la réponse est remplie n'y figure jamais"

# --- CA12, CA13 : ordre de réalisation ---------------------------------------------------

if grep -qF '```mermaid' <<<"$body"; then
  ok "CA12 schéma Mermaid des dépendances"
else
  ko "CA12 schéma Mermaid des dépendances (« \`\`\`mermaid » absent du corps)"
fi
cite "CA13 ordre non proposé en cas de cycle" "Aucun ordre proposé : cycle de dépendances"
cite "CA13 cycle décrit dans « Points non déterminés »" "« Points non déterminés » décrit le cycle"

# --- CA14, CA15 : fichiers concernés -----------------------------------------------------

cite "CA14 mention « (à créer) »" "(à créer)"
cite "CA14 chemin vérifié par Glob" "Ne cite qu'un chemin que Glob a effectivement trouvé"
cite "CA15 mention « non applicable (projet sans code) »" "non applicable (projet sans code)"

# --- CA16 : identifiants stables ------------------------------------------------------------

# shellcheck disable=SC2016 # accents graves littéraux, sans substitution
cite "CA16 identifiant conservé" 'conserve son identifiant `Tnn`'
cite "CA16 identifiant jamais réattribué" "n'est jamais réattribué"
cite "CA16 dernier identifiant attribué conservé" "Derniers identifiants attribués"
cite "CA16 référence Tnn-CAn (contrat)" "T03-CA2"

# --- CA18, CA19 : erreurs d'entrée ----------------------------------------------------------

cite "CA18 renvoi vers /wf-cadrage-besoin" "/wf-cadrage-besoin"
cite "CA18 syntaxe avec un fichier de besoin" "/wf-specs-tickets <"

# --- CA20 : convention de nommage recommandée -----------------------------------------------

cite "CA20 exemple de branche feat/T03-export-pdf" "feat/T03-export-pdf"
cite "CA20 suivi par wf-rapport-avancement" "wf-rapport-avancement"

# --- Aucune valeur de la fixture FieldOps ni des données des cas ----------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

forbidden=(
  "FieldOps"
  "Démo Thermique"
  "Renaud"
  "Olivier"
  "dispatcher"
  "technicien"
  "chaudière"
  "Intervention"
  "InterventionList"
  "src/api/routes"
  "planification"
  "pdfExport"
  "volume mensuel"
  "logistique"
  "organisation-atelier"
  "cahier-des-charges"
  "CA2 supprimé alors que CA3"
  "T03 retiré"
  "Q04"
  "B05"
  "T04"
  "publication, déploiement"
  "gestion de projet, recette"
  "intuitive"
)

# Valeurs tirées des données des cas (evals/specs-tickets-*/donnees/*.md) :
# libellés des besoins (trois premiers mots), titres des tickets, estimations
# des tâches (« <basse> à <haute> j »).
while IFS= read -r value; do
  [ -n "$value" ] && forbidden+=("$value")
done < <(
  cat "$root"/evals/specs-tickets-*/donnees/*.md | awk -F'|' '
    /^- B[0-9]+ : / { line = $0; sub(/^- B[0-9]+ : /, "", line); split(line, w, " "); print w[1] " " w[2] " " w[3] }
    /^### T[0-9]+ : / { line = $0; sub(/^### T[0-9]+ : /, "", line); print line }
    /^\| C[0-9]+ \|/ { low = $5; high = $6; gsub(/^ +| +$/, "", low); gsub(/^ +| +$/, "", high); print low " à " high " j" }
  '
)

leak_ok=1
for value in "${forbidden[@]}"; do
  if grep -qiF -- "$value" <<<"$body"; then
    ko "aucune valeur de la fixture ni des données des cas dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de la fixture ni des données des cas dans la skill (${#forbidden[@]} valeurs)"

# --- Injection shell ---------------------------------------------------------------------------
# Aucune commande prescrite n'insère un texte venu de l'utilisateur ou du projet :
# ni « test -f », ni chemin ou texte entre guillemets doubles dans une commande.

if grep -qF -- "test -f" <<<"$body"; then
  ko "aucune commande test -f (injection shell par le chemin)"
else
  ok "aucune commande test -f (injection shell par le chemin)"
fi
# shellcheck disable=SC2016 # motif d'accents graves littéraux, sans substitution
if grep -qE -- '`[^`]*"(<|\$)[^`]*`' <<<"$body"; then
  ko "aucun texte variable entre guillemets doubles dans une commande"
else
  ok "aucun texte variable entre guillemets doubles dans une commande"
fi

# --- CA21 : Grep sans afficher de ligne d'un fichier d'environnement -----------------------

cite "CA21 Grep en mode files_with_matches seulement" "Grep s'utilise uniquement en mode \`files_with_matches\`"

exit $fail
