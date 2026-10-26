---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\]\((?:\./)?doc-projet'
match: not_contains
---

CA4 : sans livrable wf-doc-projet, le dossier ne contient aucun lien vers un fichier doc-projet inexistant.
