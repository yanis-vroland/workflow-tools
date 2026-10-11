---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\]\((?:\./)?doc-projet'
match: not_contains
---

CA12 : sans livrable wf-doc-projet, le guide ne contient aucun lien vers un fichier doc-projet inexistant.
