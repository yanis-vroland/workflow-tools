---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Questions au client *$(?:(?!^## )[\s\S])*?^[-*] +\**(Q\d\d)\b(?:(?!^## )[\s\S])*?^[-*] +\**\2\b'
flags: m
match: not_contains
---

017-CA8 : aucun identifiant de question n'est utilisé deux fois dans « Questions au client ».
