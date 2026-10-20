---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] +\**(Q\d\d)\b[\s\S]*^[-*] +\**\1\b'
flags: m
match: not_contains
---

017-CA8 : aucun identifiant de question n'est utilisé deux fois.
