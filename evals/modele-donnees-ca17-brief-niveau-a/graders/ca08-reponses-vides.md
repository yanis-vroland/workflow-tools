---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Questions au client *$(?:(?!^## )[\s\S])*?^[-*] +\**Q\d\d\b[^\n]*\n(?![ \t]*\**Réponse\s*:\**[ \t]*\n)'
flags: m
match: not_contains
---

017-CA8 : chaque question est suivie, à la ligne suivante, d'un champ « Réponse : » vide (première exécution).
