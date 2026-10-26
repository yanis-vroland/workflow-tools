---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?À décider *$(?:(?!^## )[\s\S])*?(recommand|préconis|privilégi|conseill|la meilleure|à retenir)'
flags: mi
match: not_contains
---

017-CA30 et CA9 : aucune option de « À décider » n'est recommandée ni préférée.
