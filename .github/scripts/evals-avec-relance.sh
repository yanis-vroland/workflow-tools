#!/usr/bin/env bash
# Lance les evals, puis relance une fois, seuls, les cas en échec (score < 1) : les juges
# llm sont bruités sur les longs livrables, un verdict isolé ne doit pas faire tomber la CI.
# La CI n'échoue que si un cas échoue deux fois de suite.
# Usage : evals-avec-relance.sh <préfixe des résultats> <arguments de claude plugin eval>…
# Résultats : <préfixe>.json (premier passage), <préfixe>-relance-<cas>.json (relances).
# EVAL_CMD remplace « claude plugin eval » (tests).
set -u

prefix=$1
shift
read -r -a eval_cmd <<<"${EVAL_CMD:-claude plugin eval}"

"${eval_cmd[@]}" "$@" --json "$prefix.json"
code=$?

# Cas sous le seuil d'après le résultat (aucun si tout passe) ; sans résultat lisible, le code est propagé
if ! failed=$(python3 -c '
import json, sys
for case in json.load(open(sys.argv[1]))["cases"]:
    if case["aggregates"]["score"] < 1:
        print(case["name"])
' "$prefix.json" 2>/dev/null); then
  exit "$code"
fi
# Code non nul sans cas en échec (plafond de coût, erreur de l'outil) : ne pas masquer
[ -z "$failed" ] && exit "$code"

fail=0
while IFS= read -r name; do
  echo "Relance du cas en échec : $name"
  if ! "${eval_cmd[@]}" "$@" --case "$name" --json "$prefix-relance-$name.json"; then
    echo "ÉCHEC  $name échoue deux fois de suite"
    fail=1
  fi
done <<<"$failed"
exit "$fail"
