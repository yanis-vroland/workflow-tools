---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?=(?:[^"\\]|\\.)*?\bcurl\b(?:[^"\\]|\\.)*?registry\.npmjs\.org)(?=(?:[^"\\]|\\.)*?(?<!@types/)(?:(?<=\\n)|(?<![\w@-]))react-dom(?![\w-]))'
min: 1
---

CA9 et CA14 : les versions publiées et les métadonnées de `react-dom` (dépendances pair, `engines`) sont lues sur le registre npm (commande `curl … registry.npmjs.org` qui nomme le paquet).
