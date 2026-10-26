---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] +\**Q03\b[^\n]*\n[ \t]*\**Réponse\s*:\**[ \t]*$'
flags: m
match: contains
---

017-CA21 : le champ « Réponse : » de Q03 reste vide ; l'outil n'invente pas la réponse.
