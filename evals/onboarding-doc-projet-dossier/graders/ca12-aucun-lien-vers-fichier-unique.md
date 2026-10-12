---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\]\((?:\./)?doc-projet\.md'
match: not_contains
---

CA12 : format dossier, aucun lien vers `doc-projet.md`, qui n'existe pas.
