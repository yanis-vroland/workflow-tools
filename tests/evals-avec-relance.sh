#!/usr/bin/env bash
# Vérifie .github/scripts/evals-avec-relance.sh : les cas d'eval en échec sont relancés
# une fois, seuls, et la CI n'échoue que si un cas échoue deux fois de suite (juges llm
# bruités). La commande d'eval est remplacée par un faux (EVAL_CMD) qui lit un scénario.
set -u

script="$(cd "$(dirname "$0")/.." && pwd)/.github/scripts/evals-avec-relance.sh"
fail=0

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Faux « claude plugin eval » : sans --case, écrit $FAKE_DIR/premier.json ; avec
# --case X, écrit $FAKE_DIR/relance-X.json. Journalise chaque appel dans $FAKE_DIR/appels.
# Code de sortie : 1 si un cas a un score < 1, sinon 0 ; 3 si le scénario manque.
fake="$work/faux-eval.sh"
cat >"$fake" <<'EOF'
#!/usr/bin/env bash
json="" case=""
while [ $# -gt 0 ]; do
  case $1 in
    --json) json=$2; shift ;;
    --case) case=$2; shift ;;
  esac
  shift
done
echo "case=${case:-tous}" >>"$FAKE_DIR/appels"
src="$FAKE_DIR/premier.json"
[ -n "$case" ] && src="$FAKE_DIR/relance-$case.json"
[ -f "$src" ] || exit 3
cp "$src" "$json"
grep -q '"score": *0' "$src" && exit 1
exit 0
EOF
chmod +x "$fake"

# result <fichier> <nom:score>... : écrit un résultat d'eval minimal
result() {
  local file=$1
  shift
  local cases="" sep=""
  for c in "$@"; do
    cases="$cases$sep{\"name\": \"${c%%:*}\", \"aggregates\": {\"score\": ${c#*:}}}"
    sep=","
  done
  printf '{"cases": [%s]}\n' "$cases" >"$file"
}

# check <code attendu> <description> <appels attendus, séparés par des espaces>
check() {
  local expected=$1 description=$2 calls=$3
  local out
  out=$(EVAL_CMD="$fake" FAKE_DIR="$d" bash "$script" "$d/sortie" --tag x 2>&1)
  local code=$?
  local got
  got=$(tr '\n' ' ' <"$d/appels" 2>/dev/null | sed 's/ $//')
  if [ "$code" -ne "$expected" ]; then
    echo "ÉCHEC  $description (attendu $expected, obtenu $code : $out)"
    fail=1
  elif [ "$got" != "$calls" ]; then
    echo "ÉCHEC  $description (appels attendus « $calls », obtenus « $got »)"
    fail=1
  else
    echo "OK     $description"
  fi
}

d="$work/vert"; mkdir -p "$d"
result "$d/premier.json" a:1 b:1
check 0 "Tout passe : succès, aucune relance" "case=tous"

d="$work/bruit"; mkdir -p "$d"
result "$d/premier.json" a:1 b:0 c:0
result "$d/relance-b.json" b:1
result "$d/relance-c.json" c:1
check 0 "Cas en échec qui passent à la relance : succès" "case=tous case=b case=c"

d="$work/regression"; mkdir -p "$d"
result "$d/premier.json" a:0 b:0
result "$d/relance-a.json" a:1
result "$d/relance-b.json" b:0
check 1 "Un cas échoue deux fois : échec" "case=tous case=a case=b"

d="$work/partiel"; mkdir -p "$d"
result "$d/premier.json" a:1 b:0.75
result "$d/relance-b.json" b:1
check 0 "Score partiel (< 1) compté comme échec puis relancé" "case=tous case=b"

d="$work/erreur"; mkdir -p "$d"
check 3 "Erreur de l'eval sans résultat : code propagé, aucune relance" "case=tous"

d="$work/erreur-sans-echec"; mkdir -p "$d"
result "$d/premier.json" a:1
# Code non nul mais aucun cas sous le seuil : l'échec n'est pas masqué
cat >"$work/faux-erreur.sh" <<'EOF'
#!/usr/bin/env bash
while [ $# -gt 0 ]; do [ "$1" = --json ] && cp "$FAKE_DIR/premier.json" "$2"; shift; done
echo "case=tous" >>"$FAKE_DIR/appels"
exit 2
EOF
chmod +x "$work/faux-erreur.sh"
out=$(EVAL_CMD="$work/faux-erreur.sh" FAKE_DIR="$d" bash "$script" "$d/sortie" --tag x 2>&1)
code=$?
if [ "$code" -eq 2 ]; then
  echo "OK     Code non nul sans cas en échec (plafond de coût…) : code propagé"
else
  echo "ÉCHEC  Code non nul sans cas en échec : attendu 2, obtenu $code ($out)"
  fail=1
fi

d="$work/args"; mkdir -p "$d"
result "$d/premier.json" a:1
EVAL_CMD="$fake" FAKE_DIR="$d" bash "$script" "$d/sortie" --tag reseau --allow-tools Write >/dev/null 2>&1
if [ -f "$d/sortie.json" ]; then
  echo "OK     Résultat du premier passage écrit dans <préfixe>.json"
else
  echo "ÉCHEC  Résultat du premier passage absent de <préfixe>.json"
  fail=1
fi

exit "$fail"
