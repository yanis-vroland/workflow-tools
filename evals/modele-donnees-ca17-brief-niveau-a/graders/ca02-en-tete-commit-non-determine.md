---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?:(?!^## )[\s\S])*?^[-*] *\**Commit analysé\** *:\**[^\n]*non déterminé'
flags: m
match: contains
---

017-CA2 (ADR-001) : le projet n'ayant aucun commit, la ligne « Commit analysé » indique « non déterminé ».
