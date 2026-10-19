---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?=(?:[^"\\]|\\.)*?\bcurl\b(?:[^"\\]|\\.)*?registry\.npmjs\.org)(?=(?:[^"\\]|\\.)*?(?<!@types/)(?<![\w@-])lodash(?![\w-]))'
min: 1
---

CA9 : la dernière version publiée de `lodash` est demandée au registre npm (commande `curl … registry.npmjs.org` qui nomme le paquet), pas tirée de la mémoire du modèle.
