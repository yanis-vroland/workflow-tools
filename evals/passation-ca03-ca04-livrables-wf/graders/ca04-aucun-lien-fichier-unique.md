---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\]\((?:\./)?doc-projet\.md\)'
match: not_contains
---

CA4 : le livrable doc-projet est au format dossier : aucun lien vers `doc-projet.md`, inexistant.
