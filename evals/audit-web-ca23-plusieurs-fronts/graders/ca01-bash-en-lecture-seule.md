---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!(?:git rev-parse --short HEAD|git status --porcelain|date \+%F)"|find \.(?!(?:[^\"\\]|\\.)*?(?:-delete|-execdir|-ok|-fprint|-fls|-exec(?! wc -c \{\} \+)))(?:[^\"\\;&|><\x60$]|\\\\[()])*\"|find \.(?!(?:[^\"\\]|\\.)*?(?:-delete|-execdir|-ok|-fprint|-fls))(?:[^\"\\;&|><\x60$]|\\\\[()])* -exec dirname \{\} \+ \| sort \| uniq -c\")'
min: 0
max: 0
---

CA1, CA17 et hors périmètre (l'outil ne corrige rien, n'exécute pas le projet) : Bash ne sert qu'aux commandes en lecture que la skill prescrit, chacune seule : `git rev-parse --short HEAD`, `git status --porcelain`, `date +%F`, la recherche des images lourdes (`find .` sans `-delete` ni `-exec` autre que `wc -c {} +`, sans redirection ni enchaînement), le décompte des gabarits par dossier et, en mode URL seulement, `command -v lighthouse` et la commande Lighthouse prescrite (URL passée par un heredoc puis validée par le shell). Toute autre commande échoue : installation (`npm install`, `npx`), exécution du projet, écriture, lecture d'un fichier par `cat`.
