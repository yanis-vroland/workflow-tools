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
# couvre les CA communs et les trois niveaux A, B et C.
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

# --- CA3 : sections dans l'ordre (niveaux A, B et C) ------------------------------
# Le modèle montre toutes les sections ; celles des niveaux B et C y sont
# annoncées comme propres à leur niveau.

sections=(
  "Synthèse"
  "Modèle conceptuel"
  "Dictionnaire de données"
  "Règles de gestion"
  "Questions au client"
  "À décider"
  "Revue du modèle"
  "Schéma physique"
  "Preuve par les cas d'usage"
  "Évolution"
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
  ok "CA3 les onze sections des niveaux A, B et C, dans l'ordre"
fi

# --- CA4 à CA9 : contenu du modèle -------------------------------------------

cite "CA4 élément sans source marqué « supposé »" "supposé"
cite "CA4 chaque relation a sa propre source, même quand sa règle est sourcée" "même quand sa règle"
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
# shellcheck disable=SC2016 # accents graves littéraux
cite "CA9 élément dépendant d'un encadré ouvert renvoyé à cet encadré" 'provisoire, voir `Dnn`'

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

# --- Injection shell ------------------------------------------------------------
# Un chemin ou un texte venu de l'utilisateur ou du projet n'est jamais inséré
# entre guillemets doubles dans une commande Bash ($(…), backticks, « " » y
# seraient interprétés) : guillemets simples après rejet de toute apostrophe, ou
# entrée standard par un heredoc à délimiteur entre apostrophes.
if grep -qE '"<[^>"]+>"' <<<"$body"; then
  ko "aucun texte variable entre guillemets doubles dans une commande ($(grep -oE '"<[^>"]+>"' <<<"$body" | head -n 1))"
else
  ok "aucun texte variable entre guillemets doubles dans une commande"
fi
cite "PDF : chemin entre guillemets simples (pdfinfo)" "pdfinfo '<fichier>'"
cite "PDF : chemin entre guillemets simples (pdftotext)" "pdftotext -f N -l N '<fichier>' -"
cite "PDF : chemin contenant une apostrophe écarté sans commande" "contient une apostrophe"
cite "chemin relatif calculé par l'entrée standard" "<<'CHEMIN'"
absent "aucun test -f sur un chemin venu des arguments" "test -f"

# shellcheck disable=SC2016 # accents graves littéraux
cite "PDF : chemin relatif préfixé par ./ (option)" 'préfixe `./`'
cite "chemin relatif : argument multiligne refusé avant le heredoc" "sur plusieurs lignes"
cite "relance : source hors du projet signalée sans relecture" "hors du projet n'est pas relue"
# Exemples d'encadrés « À décider » sans lien avec les données des cas (états,
# adresses ou sites, désactivation, niveau intermédiaire)
for value in "historiser" "changements d'état" "adresses par client" "désactivation" "un seul champ d'état" "niveau intermédiaire"; do
  absent "exemple d'encadré sans lien avec les cas (« $value »)" "$value"
done

# --- Grep et fichiers d'environnement --------------------------------------------
cite "Grep en mode files_with_matches" "files_with_matches"
cite "CA37 fichier sans objet signalé, jamais supprimé" "plus lieu d'être"
cite "CA38 aucune chaîne de connexion recopiée" "chaîne de connexion"

# --- Niveau B : schéma physique ------------------------------------------------

cite "CA3 en-tête : niveau B" "B (schéma physique)"
cite "CA16 commentaire d'en-tête des fichiers non Markdown" "Généré par wf-modele-donnees : voir index.md"
cite "CA16 fichiers listés avec leur rôle" "| Fichier | Rôle |"
cite "CA19 schéma PostgreSQL" "schema.sql"
cite "CA19 données de test" "donnees-test.sql"
cite "CA19 requêtes de vérification" "requetes.sql"
cite "CA20 questions et décisions manquantes listées" "manquent pour passer au niveau B"
# shellcheck disable=SC2016 # accents graves littéraux
cite "CA21 niveau B forcé" '`--niveau b` force le niveau B'
cite "CA21 élément dépendant d'une saisie vide marqué dans le schéma" "-- supposé"
cite "CA22 noms en snake_case" "snake_case"
cite "CA22 clé étrangère au singulier" "<table au singulier>_id"
cite "CA22 colonne created_at" "created_at"
cite "CA22 colonne updated_at" "updated_at"
cite "CA22 contrainte CHECK" "CHECK"
cite "CA22 index justifié" "-- Justification :"
cite "CA14 relation n-n sans table de jointure" "table de jointure"
cite "CA23 identifiant de requête" "R01"
cite "CA23 besoin sans requête signalé comme défaut" "défaut du schéma"
cite "CA24 contraintes respectées par les données de test" "NOT NULL"
cite "CA24 chaque requête renvoie au moins une ligne" "renverrait au moins une ligne"
# shellcheck disable=SC2016 # accents graves littéraux
cite "CA25 Prisma" '`schema.prisma` (avec `datasource`'
cite "CA25 migration Prisma" "_init/migration.sql"
cite "CA25 TypeORM" "MigrationInterface"
cite "CA25 Drift" "schemaVersion"
cite "CA25 sqflite" "onCreate"
cite "CA36 ORM non couvert" "non couvert"
cite "CA36 exemple d'ORM non couvert" "Sequelize"

# --- Niveau C : évolution d'un schéma existant ----------------------------------

cite "CA26 en-tête : niveau C" "C (évolution)"
cite "CA26 schémas détectés avec leur ORM et leur outil de migration" "| Schéma | Base ou ORM | Outil de migration |"
cite "CA26 outil de migration absent" "aucun"
cite "CA26 migration par défaut" "migration.sql"
cite "CA27 colonne ajoutée" "ajoutée"
cite "CA27 colonne renommée" "renommée"
cite "CA27 colonne supprimée" "supprimée"
cite "CA28 valeur par défaut avant la contrainte" "valeur par défaut"
cite "CA28 reprise des lignes existantes" "reprise"
cite "CA28 contrainte imposée après remplissage" "SET NOT NULL"
cite "CA29 renommage plutôt que suppression et recréation" "RENAME COLUMN"
cite "CA30 suppression soumise à une décision saisie" "confirmée par une décision saisie"
cite "CA31 impacts sur le code" "Impacts sur le code"
cite "CA32 montée de version sqflite" "onUpgrade"
cite "CA32 fichier de migration sqflite" "migration-sqflite.dart"
cite "CA32 fichier de migration Drift" "migration-drift.dart"
cite "CA34 --niveau c sans schéma détecté" "aucun schéma détecté"
cite "CA36 au niveau C, différences et impacts sans migration" "aucun fichier de migration"

# --- Plus aucun niveau annoncé non disponible ----------------------------------

absent "les trois niveaux sont livrés" "non disponible dans cette version"

# --- Aucune valeur propre à la fixture ni aux données des cas -----------------
# Les exemples de la skill restent génériques : sinon les evals mesureraient la
# recopie d'un exemple, pas le comportement. Le contrôle porte sur le fichier
# entier (frontmatter compris). Liste fixe (valeurs de FieldOps et des
# sources) et liste générée depuis les données des cas (evals/modele-donnees-*/
# donnees/, prompts) et les motifs et chemins des graders : identifiants en
# snake_case et noms de fichiers, hors noms imposés par la spec ou l'ADR-001 et
# noms d'outils que la skill doit citer.

# Sous-chaînes, insensibles à la casse
fixed_substrings=(
  "FieldOps" "intervention" "technicien" "technician" "work_order" "dispatcher"
  "chaudière" "Démo Thermique" "hourly_rate" "local_db" "Villefictive"
  "Technicien Fictif" "Client Fictif" "Société Exemple" "DATABASE_URL"
  "projet.sdt" "purge" "MAP_API_KEY" "priorit" "urgente" "visit_report"
  "legacy_code" "équipement" "evolution-interventions" "Sophie" "Renaud"
  "Marc Olivier"
)
# Mots entiers, insensibles à la casse
fixed_words=("report" "site" "sites")
# Noms imposés par la spec ou l'ADR-001, et outils que la skill doit nommer
allowed_generated=(
  index.md cadrage-besoin.md schema.sql donnees-test.sql requetes.sql
  migration.sql schema.prisma package.json migration-sqflite.dart
  migration-drift.dart local_database.dart tables.dart database.dart
  created_at updated_at file_path input_match pg_restore drift_dev
)

generated_terms() {
  {
    cat "$root"/evals/modele-donnees-*/donnees/* "$root"/evals/modele-donnees-*/prompt.md 2>/dev/null
    grep -h -E '^(path|pattern|input_match):' "$root"/evals/modele-donnees-*/graders/*.md 2>/dev/null
  } | grep -oE '[A-Za-z]+(_[A-Za-z]+)+|[A-Za-z0-9_-]+\.(md|sql|ts|dart|json|prisma|docx)' |
    sort -u | grep -vxF -f <(printf '%s\n' "${allowed_generated[@]}")
}

# leaks <fichier> : affiche chaque terme interdit présent dans le fichier
leaks() {
  local file=$1 term
  for term in "${fixed_substrings[@]}"; do
    grep -qiF -- "$term" "$file" && echo "$term"
  done
  for term in "${fixed_words[@]}"; do
    grep -qiwF -- "$term" "$file" && echo "$term"
  done
  while IFS= read -r term; do
    [ -n "$term" ] && grep -qiwF -- "$term" "$file" && echo "$term"
  done < <(generated_terms)
  return 0
}

found=$(leaks "$skill")
if [ -z "$found" ]; then
  ok "aucune valeur de la fixture ni des cas dans la skill (fichier entier)"
else
  ko "aucune valeur de la fixture ni des cas dans la skill ($(tr '\n' ' ' <<<"$found"))"
fi

# Contrôle par mutation du contrôle lui-même : un terme de chaque liste, injecté
# dans une copie de la skill (frontmatter compris), doit être détecté.
first_generated=$(generated_terms | head -n 1)
for term in "${fixed_substrings[0]}" "${fixed_words[0]}" "$first_generated"; do
  [ -n "$term" ] || continue
  mutant="$work/mutant-SKILL.md"
  sed "2s/\$/ $term/" "$skill" >"$mutant"
  if grep -qxF -- "$term" <<<"$(leaks "$mutant")"; then
    ok "mutation : « $term » injecté dans le frontmatter est détecté"
  else
    ko "mutation : « $term » injecté dans le frontmatter n'est pas détecté"
  fi
done

exit $fail
