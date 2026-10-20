---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '\bB(0[7-9]|[1-9]\d)\b'
match: not_contains
---

017-CA18 : le cadrage ne compte que B01 à B06 ; aucun identifiant de besoin n'est inventé.
