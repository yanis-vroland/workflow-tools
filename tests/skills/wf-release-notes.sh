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
  "5b26289"
  "b5808fe"
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
