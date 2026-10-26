---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Questions au client *$(?:(?!^## )[\s\S])*?^[-*] +\**Q\d\d\b(?![^\n]*Bloquante\s*:\s*\**(oui|non)\b)[^\n]*$'
flags: m
match: not_contains
---

017-CA8 : chaque question indique si elle est bloquante pour le schéma physique (« Bloquante : oui » ou « Bloquante : non »).
