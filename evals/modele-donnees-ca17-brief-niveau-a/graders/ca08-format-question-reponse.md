---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] *\**Q01\b[^\n]*\n\s*\**Réponse\s*:\**[ \t]*$'
flags: m
match: contains
---

017-CA8 : la première question est un élément de liste qui commence par `Q01`, suivi à la ligne suivante d'un champ « Réponse : » vide (format de la spec 004).
