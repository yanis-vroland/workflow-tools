---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?À décider *$(?:(?!^## )[\s\S])*?(recommand|préconis|privilégi|conseill|la meilleure|à retenir)'
flags: mi
match: not_contains
---

017-CA9 : l'outil ne recommande ni ne préfère aucune option dans « À décider ».
