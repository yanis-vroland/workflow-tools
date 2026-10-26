---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\]\([^)\n]*(?:analyse-projet|chiffrage|revue-securite)'
match: not_contains
---

CA3 : le dossier ne contient aucun lien vers un livrable à usage interne.
