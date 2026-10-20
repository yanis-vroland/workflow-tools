#!/usr/bin/env bash
# Tests structurels de wf-cadrage-besoin (spec 004), lancés par tests/skills.sh.
#
# Le chemin du livrable, les noms de sections et les identifiants sont un contrat
# lu par wf-chiffrage et wf-specs-tickets (spec 004, amendement 1 de l'ADR-001) ;
# l'échelle de priorité, le champ de réponse et la mention de source des réponses
# saisies sont fixés mot pour mot par la spec. La skill doit les citer
# textuellement. La qualité du livrable lui-même est vérifiée par les evals
# (evals/cadrage-besoin-*).
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
verifier="$root/.github/scripts/verifier-skills.sh"
skill_dir="$root/skills/wf-cadrage-besoin"
skill="$skill_dir/SKILL.md"
fail=0

sections=('Synthèse' 'Contexte et objectifs' 'Utilisateurs et rôles'
  'Besoins fonctionnels' 'Contraintes' 'Hors périmètre' 'Hypothèses'
  'Questions au client' 'Points non déterminés')

# contract <identifiant et description> <fragment attendu dans SKILL.md>
contract() {
  local description=$1 fragment=$2
  if [ ! -f "$skill" ]; then
    echo "ÉCHEC  wf-cadrage-besoin, $description (skills/wf-cadrage-besoin/SKILL.md absent)"
    fail=1
  elif ! grep -qF -- "$fragment" "$skill"; then
    echo "ÉCHEC  wf-cadrage-besoin, $description (« $fragment » absent de SKILL.md)"
    fail=1
  else
    echo "OK     wf-cadrage-besoin, $description"
  fi
}

# --- Présence et conformité à l'ADR-001 ----------------------------------------

if [ -f "$skill" ]; then
  echo "OK     wf-cadrage-besoin : skill présente"
  work=$(mktemp -d)
  trap 'rm -rf "$work"' EXIT
  cp -R "$skill_dir" "$work/"
  if output=$(bash "$verifier" "$work" 2>&1); then
    echo "OK     wf-cadrage-besoin : conforme à l'ADR-001 (frontmatter, consignes communes)"
  else
    echo "ÉCHEC  wf-cadrage-besoin : non conforme à l'ADR-001 ($output)"
    fail=1
  fi
else
  echo "ÉCHEC  wf-cadrage-besoin : skills/wf-cadrage-besoin/SKILL.md absent (spec 004)"
  fail=1
fi

# --- Contrat de la spec 004 ---------------------------------------------------

contract "CA1 : chemin du livrable" 'docs/wf/cadrage-besoin.md'

for section in "${sections[@]}"; do
  contract "CA2 : section « $section »" "$section"
done

# CA2 : les neuf sections apparaissent dans l'ordre de la spec, parmi les lignes
# de titre Markdown de SKILL.md (modèle du livrable), première occurrence de
# chaque nom
if [ -f "$skill" ]; then
  headings=$(grep -nE '^[[:space:]]*#{1,6}[[:space:]]' "$skill" || true)
  order_ok=1
  previous=0
  for section in "${sections[@]}"; do
    line=$(grep -F -- "$section" <<<"$headings" | head -n 1 | cut -d: -f1)
    if [ -z "$line" ] || [ "$line" -le "$previous" ]; then
      order_ok=0
      break
    fi
    previous=$line
  done
  if [ "$order_ok" -eq 1 ]; then
    echo "OK     wf-cadrage-besoin, CA2 : sections dans l'ordre de la spec"
  else
    echo "ÉCHEC  wf-cadrage-besoin, CA2 : sections hors de l'ordre de la spec (premier écart : « $section »)"
    fail=1
  fi
else
  echo "ÉCHEC  wf-cadrage-besoin, CA2 : ordre des sections (skills/wf-cadrage-besoin/SKILL.md absent)"
  fail=1
fi

# CA4 et CA5 : ligne de besoin du modèle, avec son identifiant et l'échelle de
# priorité complète (un mot isolé ailleurs dans SKILL.md ne suffit pas)
contract "CA4, CA5 : modèle de besoin (identifiant, échelle de priorité)" \
  'B01 : <libellé>. Priorité : <indispensable | important | souhaitable | non précisée>.'
contract "CA11 : identifiant de question" 'Q01'
contract "CA11 : champ de réponse à remplir" 'Réponse :'
contract "CA12 : source d'une réponse saisie" 'réponse saisie à la question'
contract "CA2 : section vide présente avec « Aucun élément. »" 'Aucun élément.'
contract "CA15 : source introuvable conservée dans l'en-tête" '(introuvable)'
# CA17 : extractibilité d'un PDF testée de façon déterministe, page par page
contract "CA17 : nombre de pages d'un PDF (pdfinfo)" 'pdfinfo'
contract "CA17 : texte d'une page de PDF (pdftotext)" 'pdftotext -f'

# CA20 (amendement) : consigne explicite de langue, titres et libellés compris
contract "CA20 : livrable entièrement en français" 'entièrement rédigé en français, y compris'

# --- Injection shell par un chemin de source (amendement de CA17) ---------------
# Un chemin de source vient de l'utilisateur (argument) ou du livrable (en-tête) :
# il n'est jamais recopié dans le texte d'une commande (ni entre guillemets
# doubles, où `$(…)` et les accents graves seraient interprétés, ni entre
# apostrophes, qu'une apostrophe du nom refermerait). Il passe par un heredoc à
# délimiteur entre apostrophes, est vérifié par le shell, préfixé par `./` s'il
# est relatif (un nom qui commence par `-` n'est pas pris pour une option), puis
# utilisé seulement en variable.

inj=$(mktemp -d)
trap 'rm -rf "${work:-}" "$inj"' EXIT

# ko <description> / ok <description>
ko() { echo "ÉCHEC  wf-cadrage-besoin, $1"; fail=1; }
ok() { echo "OK     wf-cadrage-besoin, $1"; }

if [ -f "$skill" ]; then
  # shellcheck disable=SC2016 # motifs littéraux
  if grep -qE "\"<[^>]+>\"|'<[^>]+>'" "$skill"; then
    ko "injection : un chemin est recopié entre guillemets ou apostrophes dans une commande ($(grep -oE "\"<[^>]+>\"|'<[^>]+>'" "$skill" | sort -u | tr '\n' ' '))"
  else
    ok "injection : aucun chemin recopié entre guillemets ou apostrophes dans une commande"
  fi
fi

contract "injection : raison du refus" 'nom de fichier refusé (caractère spécial), jamais lu'
contract "injection : argument sur plusieurs lignes écarté" 'plusieurs lignes'
contract "injection : chemin jamais recopié dans une commande" "n'est jamais recopié dans le texte d'une commande"

# bash_block <délimiteur> : bloc ```bash de SKILL.md qui contient le heredoc
# <<'<délimiteur>', sans son indentation
bash_block() {
  awk -v d="<<'$1'" '
    /^[[:space:]]*```bash$/ { on = 1; buf = ""; has = 0; next }
    on && /^[[:space:]]*```$/ { if (has) { printf "%s", buf; exit } on = 0; next }
    on { line = $0; sub(/^[[:space:]]+/, "", line); buf = buf line "\n"; if (index(line, d)) has = 1 }
  ' "$skill"
}

# run_block <shell> <bloc> <chemins, un par ligne> : lance le bloc dans $inj/run
# avec les chemins dans le corps du heredoc, à la place de la ligne <chemin>
# (par l'environnement : awk -v refuse les sauts de ligne et interprète les \)
run_block() {
  local script
  script=$(PATHS_BODY="$3" awk '$0 == "<chemin>" { print ENVIRON["PATHS_BODY"]; next } { print }' <<<"$2")
  (cd "$inj/run" && PATH="$inj/bin:$PATH" FAKE_LOG="$inj/log" "$1" -c "$script" 2>&1)
}

sources_block=$(bash_block WF_SOURCES_7c3e)
pdf_block=$(bash_block WF_PDF_7c3e)
for entry in "sources|$sources_block|WF_SOURCES_7c3e" "PDF|$pdf_block|WF_PDF_7c3e"; do
  label=${entry%%|*}; delim=${entry##*|}; rest=${entry#*|}
  if [ -n "${rest%|*}" ]; then
    ok "injection : bloc $label avec heredoc <<'$delim'"
  else
    ko "injection : bloc bash $label avec heredoc <<'$delim' absent"
  fi
done

mkdir -p "$inj/run" "$inj/bin"
# Faux outils poppler : notent leurs arguments, un par ligne
cat >"$inj/bin/pdfinfo" <<'SH'
#!/usr/bin/env bash
printf 'pdfinfo %s\n' "$@" >>"$FAKE_LOG"
echo "Pages:          2"
SH
cat >"$inj/bin/pdftotext" <<'SH'
#!/usr/bin/env bash
printf 'pdftotext %s\n' "$@" >>"$FAKE_LOG"
echo "texte"
SH
chmod +x "$inj/bin/pdfinfo" "$inj/bin/pdftotext"

# shellcheck disable=SC2016 # noms piégés : substitutions littérales
traps=('$(touch pwned1).md' '`touch pwned2`.md' "x'\$(touch pwned3)'.md" 'y"$(touch pwned4)".md' 'z\$(touch pwned5).md')
for name in "${traps[@]}" "-n.md" "l'équipe.md" "-x.pdf"; do
  : >"$inj/run/$name"
done

shells=(bash)
[ -x /bin/zsh ] && shells+=(/bin/zsh)
for sh in "${shells[@]}"; do
  [ -n "$sources_block" ] || break
  out=$(run_block "$sh" "$sources_block" "$(printf '%s\n' "${traps[@]}" "-n.md" "l'équipe.md" "absent.md")")
  if compgen -G "$inj/run/pwned*" >/dev/null; then
    ko "injection ($sh) : un nom piégé a exécuté une commande dans le bloc des sources"
    for f in "$inj"/run/pwned*; do rm -f "$f"; done
  else
    ok "injection ($sh) : aucun nom piégé exécuté dans le bloc des sources"
  fi
  refused=$(grep -c '^refusé : ' <<<"$out")
  if [ "$refused" -eq "${#traps[@]}" ]; then
    ok "injection ($sh) : noms à caractère spécial refusés par le shell"
  else
    ko "injection ($sh) : ${#traps[@]} refus attendus, $refused obtenus ($out)"
  fi
  if grep -qxF 'fichier : -n.md' <<<"$out" && grep -qxF "fichier : l'équipe.md" <<<"$out" &&
    grep -qxF 'introuvable : absent.md' <<<"$out"; then
    ok "injection ($sh) : noms ordinaires (tiret initial, apostrophe) trouvés, absent signalé"
  else
    ko "injection ($sh) : sortie inattendue du bloc des sources ($out)"
  fi
done

for sh in "${shells[@]}"; do
  [ -n "$pdf_block" ] || break
  pdf_ok=1
  for name in "${traps[@]}"; do
    : >"$inj/log"
    out=$(run_block "$sh" "$pdf_block" "$name")
    if compgen -G "$inj/run/pwned*" >/dev/null || [ -s "$inj/log" ]; then
      ko "injection ($sh) : nom piégé exécuté ou transmis à poppler dans le bloc PDF ($name)"
      pdf_ok=0
      for f in "$inj"/run/pwned*; do rm -f "$f"; done
    elif ! grep -qF 'nom de fichier refusé (caractère spécial), jamais lu' <<<"$out"; then
      ko "injection ($sh) : refus non signalé par le bloc PDF ($name : $out)"
      pdf_ok=0
    fi
  done
  if [ "$pdf_ok" -eq 1 ]; then ok "injection ($sh) : bloc PDF, noms piégés refusés sans rien exécuter"; fi
  : >"$inj/log"
  out=$(run_block "$sh" "$pdf_block" "-x.pdf")
  if grep -qxF 'pdfinfo ./-x.pdf' "$inj/log" && [ "$(grep -cxF 'pdftotext ./-x.pdf' "$inj/log")" -eq 2 ] &&
    ! grep -qE '^pdf(info|totext) -x\.pdf$' "$inj/log" && grep -qF -- '--- page 2 ---' <<<"$out"; then
    ok "injection ($sh) : bloc PDF, chemin relatif préfixé par ./ et chaque page extraite"
  else
    ko "injection ($sh) : bloc PDF, arguments inattendus ($(tr '\n' ' ' <"$inj/log") ; $out)"
  fi
done

exit $fail
