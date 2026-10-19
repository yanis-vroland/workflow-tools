---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!(?:git rev-parse --short HEAD|git status --porcelain|date \+%F|command -v lighthouse)"|find \.(?!(?:[^\"\\]|\\.)*?(?:-delete|-execdir|-ok|-fprint|-fls|-exec(?! wc -c \{\} \+)))(?:[^\"\\;&|><\x60$]|\\\\[()])*\"|lighthouse ''[^''\"]+'' (?:[^\"\\;&|><\x60$]|\\\\\")*\| node ''[^''\"]*/scripts/lighthouse-summary\.mjs''\")'
min: 0
max: 0
---

CA1, CA17 et hors périmètre (l'outil ne corrige rien, n'exécute pas le projet) : Bash ne sert qu'aux commandes en lecture que la skill prescrit, chacune seule : `git rev-parse --short HEAD`, `git status --porcelain`, `date +%F`, `command -v lighthouse`, la recherche des images lourdes (`find .` sans `-delete` ni `-exec` autre que `wc -c {} +`, sans redirection ni enchaînement) et, en mode URL, `lighthouse '<URL>' … | node '…/scripts/lighthouse-summary.mjs'`. Toute autre commande échoue : installation (`npm install`, `npx`), exécution du projet, écriture, lecture d'un fichier par `cat`.
