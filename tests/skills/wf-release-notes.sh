#!/usr/bin/env bash
# Tests structurels de la skill wf-release-notes (spec 009, ADR-001 et amendement 1).
#
# Sans modèle : on vérifie que skills/wf-release-notes/SKILL.md existe, passe la
# vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 009 impose mot pour mot dans le livrable. Le chemin du
# livrable, le titre des sections de version et les noms des sous-sections sont
# un contrat lu par wf-publication-store (spec 015). Le comportement réel est
# vérifié par les evals evals/release-notes-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-release-notes"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-release-notes : $1"; }
ko() {
  echo "ÉCHEC  wf-release-notes : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-release-notes/SKILL.md introuvable, spec 009)"
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
    ko "$1 (« $(grep -oE -- "$2" <<<"$body" | head -n 1) » présent)"
  else
    ok "$1"
  fi
}

# --- CA1 : emplacement du livrable (contrat avec la spec 015) ---------------------

cite "CA1 livrable docs/wf/release-notes.md" "docs/wf/release-notes.md"

# --- CA2 : titre de version et sous-sections dans l'ordre (contrat) ---------------

cite "CA2 titre de section de version" "## Version <numéro> (<AAAA-MM-JJ>)"

subsections=(
  "Nouveautés"
  "Améliorations"
  "Corrections"
  "Points d'attention"
  "Références"
  "Points non déterminés"
)
# Titres « ### » du bloc modèle du livrable (```markdown … ```) seulement
model=$(awk '/^```markdown$/ { in_block = 1; next } in_block && /^```$/ { exit } in_block' <<<"$body")
titles=()
while IFS= read -r line; do
  titles+=("${line#\#\#\# }")
done < <(grep -E '^### ' <<<"$model")
if [ -z "$model" ]; then
  ko "CA2 bloc modèle du livrable (\`\`\`markdown) présent"
elif [ "${titles[*]}" != "${subsections[*]}" ]; then
  ko "CA2 sous-sections ### du modèle (attendu : ${subsections[*]} ; obtenu : ${titles[*]})"
else
  ok "CA2 les six sous-sections, dans l'ordre"
fi
if grep -qE '^## Version <numéro> \(<AAAA-MM-JJ>\)$' <<<"$model"; then
  ok "CA2 titre de version dans le modèle du livrable"
else
  ko "CA2 titre « ## Version <numéro> (<AAAA-MM-JJ>) » absent du modèle du livrable"
fi

# --- CA3 : en-tête ------------------------------------------------------------------

cite "CA3 en-tête : nom de l'outil" "Outil : wf-release-notes"
cite "CA3 en-tête : mention « modifications non commitées »" "modifications non commitées"

# --- CA4 : tag de version X.Y.Z ou vX.Y.Z ------------------------------------------

cite "CA4 forme d'un tag de version" '^v?[0-9]+\.[0-9]+\.[0-9]+$'

# --- CA6, CA7 : numéro de version ----------------------------------------------------

cite "CA6 manifeste package.json" "package.json"
cite "CA6 manifeste pubspec.yaml" "pubspec.yaml"
cite "CA6 mention « Version non déterminée »" "Version non déterminée"
cite "CA7 numéro de build retiré (exemple de la spec)" "1.4.0+42"

# --- CA8 : classement Conventional Commits ------------------------------------------

cite "CA8 marqueur de changement cassant" "BREAKING CHANGE:"
for type in chore ci test refactor build style docs; do
  cite "CA8 type sans entrée : $type" "\`$type\`"
done

# --- CA10, CA12, CA16 : mentions fixes ------------------------------------------------

cite "CA10 mention « Aucun changement visible pour les utilisateurs »" \
  "Aucun changement visible pour les utilisateurs"
cite "CA12 mention « sans entrée »" "sans entrée"
cite "CA12 commits de fusion exclus" "--no-merges"
cite "CA16 mention « action requise non déterminée »" "action requise non déterminée"

# --- CA22, CA23 : dépôt git et clone superficiel ------------------------------------

cite "CA22 vérification d'un dépôt avec commit" "git rev-parse -q --verify HEAD"
cite "CA23 détection du clone superficiel" "git rev-parse --is-shallow-repository"

# --- CA25 : aucun nom de contributeur -------------------------------------------------
# Aucun format git qui affiche l'auteur ou le committer, ni git shortlog.

absent "CA25 aucun format d'auteur ou de committer (%an, %ae, %cn, %ce…)" '%[ac][nNeElL]'
absent "CA25 pas de git shortlog" 'git shortlog'

# --- CA26 : diffs sans fichier d'environnement ---------------------------------------

cite "CA26 exclusion des fichiers d'environnement des diffs" ":(exclude,glob)**/.env*"

# --- Injection shell et injection d'option git ---------------------------------------
# Une référence passée en argument n'entre dans le shell que par un heredoc à
# délimiteur entre apostrophes, validée par bash avant usage. Toute autre
# valeur insérée dans une commande est un hash produit par git, entre
# apostrophes, après --end-of-options : une valeur qui commence par « - » ne
# peut pas devenir une option de git.

# Accents graves et $ littéraux, sans expansion voulue
# shellcheck disable=SC2016
commands=$(
  awk '/^ *```bash$/ { in_block = 1; next } in_block && /^ *```$/ { in_block = 0 } in_block' <<<"$body"
  grep -oE '`(git|date) [^`]*`' <<<"$body"
)
# Corps du heredoc : la seule ligne où un emplacement est nu
slots=$(grep -vxE ' *<référence>' <<<"$commands")

if grep -qE '"[^"]*<[^>"]+>[^"]*"' <<<"$slots"; then
  ko "aucun emplacement <…> entre guillemets doubles dans une commande ($(grep -oE '"[^"]*<[^>"]+>[^"]*"' <<<"$slots" | head -n 1))"
else
  ok "aucun emplacement <…> entre guillemets doubles dans une commande"
fi
# Hors heredoc, chaque emplacement est dans un mot entre apostrophes
bare=$(sed -E "s/'[^']*'//g" <<<"$slots" | grep -E '<[^>]+>' || true)
if [ -n "$bare" ]; then
  ko "tout emplacement <…> d'une commande est entre apostrophes (nu : $(head -n 1 <<<"$bare"))"
else
  ok "tout emplacement <…> d'une commande est entre apostrophes"
fi
# Chaque commande git qui reçoit une révision (emplacement ou variable) porte --end-of-options
missing=$(grep -E '\bgit [^|;&]*(<[^>]+>|"\$[a-z_]+)' <<<"$slots" | grep -v -- '--end-of-options' || true)
if [ -n "$missing" ]; then
  ko "--end-of-options devant chaque révision fournie (absent : $(head -n 1 <<<"$missing"))"
else
  ok "--end-of-options devant chaque révision fournie"
fi
# shellcheck disable=SC2016
if grep -qF '$ARGUMENTS' <<<"$commands"; then
  ko "\$ARGUMENTS jamais inséré dans une commande"
else
  ok "\$ARGUMENTS jamais inséré dans une commande"
fi
# Aucune substitution de commande : le correcteur du cas de référence piégée
# signale tout « $( » dans une commande Bash
# shellcheck disable=SC2016
if grep -qF '$(' <<<"$commands"; then
  ko "aucune substitution \$( dans les commandes prescrites"
else
  ok "aucune substitution \$( dans les commandes prescrites"
fi
cite "référence passée par un heredoc à délimiteur entre apostrophes" "<<'WF_FIN_REF'"
cite "validation bash des caractères de la référence" "*[!A-Za-z0-9._/~^@{}+-]*"
cite "règle : valeur commençant par « - » jamais insérée" \
  "Une valeur qui commence par \`-\` n'est jamais insérée dans une commande"
cite "message de référence refusée" "référence refusée : caractères non pris en charge"
cite "validation de --version" '^[0-9A-Za-z.+-]+$'
cite "message de numéro de version refusé" "numéro de version refusé"

# --- Hors périmètre : aucun tag, aucun CHANGELOG ---------------------------------------

cite "CA1 CHANGELOG.md jamais modifié" "CHANGELOG.md"

# --- Aucune valeur propre à la fixture FieldOps -------------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement.

fieldops_values=(
  "FieldOps"
  "intervention"
  "export PDF"
  "SMS"
  "T07"
  "1.2.0+14"
  "v1.1.0"
  "v1.2.0"
  "feat/export-pdf"
  "2fc99c0"
  "db46741"
  "purge"
  "MAP_API_KEY"
  "3.6.0"
  "CSV"
  "Export Excel"
  "bouton"
  "production"
)
leak_ok=1
for value in "${fieldops_values[@]}"; do
  if grep -qiF -- "$value" <<<"$body"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

# Valeurs extraites automatiquement des cas d'eval (graders, prompts, données
# déposées) : hash courts, numéros de version, identifiants de ticket
case_values=$(
  cat "$root"/evals/release-notes-*/case.yaml "$root"/evals/release-notes-*/prompt.md \
    "$root"/evals/release-notes-*/donnees/* 2>/dev/null |
    grep -oE '\b[0-9a-f]{7}\b|v?[0-9]+\.[0-9]+\.[0-9]+(\+[0-9]+)?|\bT[0-9]{2}\b' |
    grep -E '[0-9]' | sort -u
)
auto_ok=1
while IFS= read -r value; do
  [ -n "$value" ] || continue
  if grep -qF -- "$value" <<<"$body"; then
    ko "aucune valeur des cas d'eval dans la skill (« $value » présent)"
    auto_ok=0
  fi
done <<<"$case_values"
if [ -z "$case_values" ]; then
  ko "valeurs des cas d'eval extraites (aucune trouvée sous evals/release-notes-*)"
elif [ "$auto_ok" -eq 1 ]; then
  ok "aucune valeur des cas d'eval dans la skill ($(wc -l <<<"$case_values" | tr -d ' ') valeurs)"
fi

exit $fail
