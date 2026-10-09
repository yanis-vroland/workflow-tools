---
type: regex
target: { source: file, path: "docs/wf/essai.md" }
pattern: "Dernier tag : v1\\.2\\.0"
match: contains
---

Le scaffold a bien reconstruit l'historique git de la fixture, tags compris.
