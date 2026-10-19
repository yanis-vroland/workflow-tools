#!/usr/bin/env bash
# Tests structurels de la skill wf-modele-donnees (spec 017, ADR-001 et
# amendements 1 et 2), lancés par tests/skills.sh.
#
# Sans modèle : on vérifie que skills/wf-modele-donnees/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 017 impose dans le livrable (chemin, sections dans
# l'ordre, identifiants, champs à remplir, mentions fixes). Le comportement réel
# est vérifié par les evals evals/modele-donnees-*/.
#
# Livraison en trois PR (spec 017, « Construction et evals ») : cette version
# couvre le niveau A et les CA communs. Les niveaux B et C ne sont pas encore
# livrés : la skill doit les annoncer « non disponible dans cette version », et
# ne rien prétendre en produire.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-modele-donnees"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-modele-donnees : $1"; }
ko() {
  echo "ÉCHEC  wf-modele-donnees : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-modele-donnees/SKILL.md introuvable, spec 017)"
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

# absent <description> <fragment exact>
absent() {
  if grep -qF -- "$2" <<<"$body"; then
    ko "$1 (« $2 » présent dans le corps)"
  else
    ok "$1"
  fi
}

# Bloc modèle du livrable : le premier bloc ````markdown … ```` (quatre accents
# graves, pour contenir le bloc Mermaid). Seuls ses titres « ## » comptent pour
# l'ordre des sections : une mention ailleurs dans la skill ne fausse rien.
model=$(awk '/^````markdown$/ { in_block = 1; next } in_block && /^````$/ { exit } in_block' <<<"$body")

# --- CA1 : emplacement du livrable ---------------------------------------------

cite "CA1 livrable docs/wf/modele-donnees/index.md" "docs/wf/modele-donnees/index.md"

# --- CA2 : en-tête -----------------------------------------------------------------

cite "CA2 en-tête : outil nommé" "Outil : wf-modele-donnees"
cite "CA2 en-tête : niveau atteint" "Niveau atteint :"
cite "CA2 en-tête : sources lues" "Sources lues :"
cite "CA2 sources en chemin relatif à la racine du projet" "chemin relatif à la racine du projet"
cite "CA2 commit hors dépôt git" "non déterminé (le projet n'est pas un dépôt git)"
cite "CA2 mention « modifications non commitées »" "modifications non commitées"

# --- CA3 : sections dans l'ordre (niveau A) -------------------------------------

sections=(
  "Synthèse"
  "Modèle conceptuel"
  "Dictionnaire de données"
  "Règles de gestion"
  "Questions au client"
  "À décider"
  "Revue du modèle"
  "Points non déterminés"
)
titles=()
while IFS= read -r line; do
  titles+=("${line#\#\# }")
done < <(grep -E '^## ' <<<"$model")
if [ -z "$model" ]; then
  ko "CA3 bloc modèle du livrable (\`\`\`\`markdown) présent"
elif [ "${titles[*]}" != "${sections[*]}" ]; then
  ko "CA3 titres ## du modèle (attendu : ${sections[*]} ; obtenu : ${titles[*]})"
else
  ok "CA3 les huit sections du niveau A, dans l'ordre"
fi

# --- CA4 à CA9 : contenu du modèle -------------------------------------------

cite "CA4 élément sans source marqué « supposé »" "supposé"
if grep -qF -- "erDiagram" <<<"$model"; then
  ok "CA5 bloc Mermaid erDiagram dans le modèle"
else
  ko "CA5 bloc Mermaid erDiagram dans le modèle (absent du bloc modèle)"
fi
cite "CA6 tableau du dictionnaire de données" \
  "| Entité | Champ | Type | Obligatoire | Exemple | Source |"
cite "CA6 exemples fictifs" "fictif"
cite "CA7 identifiant de règle de gestion" "RG01"
cite "CA8 identifiant de question" "Q01"
cite "CA8 champ de réponse à remplir" "Réponse :"
cite "CA8 question bloquante ou non pour le schéma physique" "Bloquante : <oui | non>"
cite "CA9 identifiant d'encadré À décider" "D01"
cite "CA9 champ de décision à remplir" "Décision :"
cite "CA9 au moins deux options" "Option 2"
cite "CA9 aucune option recommandée" "Ne recommande aucune option"

# --- CA10 et CA11 : relance -------------------------------------------------------

cite "CA10 source d'une réponse saisie" "réponse saisie à la question"
cite "CA10 source d'une décision saisie" "décision saisie en"
cite "CA10 saisies recopiées mot pour mot" "mot pour mot"
cite "CA11 identifiant d'entité" "E01"
cite "CA11 identifiants retirés tracés dans l'en-tête" "Derniers identifiants attribués :"

# --- CA12 à CA15 : données personnelles, revue, aucune exécution ------------------

cite "CA12 durée de conservation à préciser" "Durée de conservation : à préciser"
cite "CA13 aucun numéro de téléphone dans le livrable" "numéro de téléphone"
cite "CA14 nommage incohérent signalé" "nommage incohérent"
cite "CA15 mention des fichiers non exécutés" "n'ont pas été exécutés"
cite "CA15 client de base de données interdit (psql)" "psql"
cite "CA15 outil d'ORM interdit (prisma migrate)" "prisma migrate"

# --- CA17 et CA18 : entrées du niveau A ------------------------------------------

cite "CA18 lecture du cadrage par défaut" "docs/wf/cadrage-besoin.md"
cite "CA18 section contractuelle « Besoins fonctionnels »" "Besoins fonctionnels"

# --- Cas limites ------------------------------------------------------------------

cite "CA33 syntaxe attendue" "/wf-modele-donnees <fichier>"
cite "CA34 option --niveau" "--niveau a|b|c"
cite "CA35 fichier introuvable" "fichier introuvable"
cite "CA35 format non pris en charge" "format non pris en charge"
cite "CA35 nombre de pages d'un PDF (pdfinfo)" "pdfinfo"
cite "CA35 texte d'une page de PDF (pdftotext)" "pdftotext -f"
cite "CA37 fichier sans objet signalé, jamais supprimé" "plus lieu d'être"
cite "CA38 aucune chaîne de connexion recopiée" "chaîne de connexion"

# --- Niveaux pas encore livrés (PR du niveau A) ---------------------------------

cite "niveaux B et C annoncés non disponibles" "non disponible dans cette version"
absent "niveau A : aucun fichier de données de test annoncé" "donnees-test.sql"
absent "niveau A : aucun fichier de requêtes annoncé" "requetes.sql"
for section in "Schéma physique" "Preuve par les cas d'usage" "Évolution"; do
  if grep -qE "^## +$section" <<<"$model"; then
    ko "niveau A : pas de section « $section » dans le modèle (présente)"
  else
    ok "niveau A : pas de section « $section » dans le modèle"
  fi
done

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement.

fieldops_values=(
  "FieldOps"
  "intervention"
  "technicien"
  "technician"
  "work_order"
  "dispatcher"
  "chaudière"
  "Démo Thermique"
  "hourly_rate"
  "local_db"
)
leak_ok=1
for value in "${fieldops_values[@]}"; do
  if grep -qiF -- "$value" <<<"$body"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

exit $fail
