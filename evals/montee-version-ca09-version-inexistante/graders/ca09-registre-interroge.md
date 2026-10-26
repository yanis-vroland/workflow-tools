---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?=(?:[^"\\]|\\.)*?\bcurl\b(?:[^"\\]|\\.)*?registry\.npmjs\.org)(?=(?:[^"\\]|\\.)*?(?<!@types/)(?:(?<=\\n)|(?<![\w@-]))react(?![\w-]))'
min: 1
---

CA9 : l'existence de la version est vérifiée sur le registre npm (commande `curl … registry.npmjs.org` qui nomme `react`).
