---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] +\**(RG\d\d)\b[\s\S]*^[-*] +\**\1\b'
flags: m
match: not_contains
---

017-CA7 : aucun identifiant de règle n'est utilisé deux fois.
