---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^\|(?:[^|\n]*\|){4}[^|\n]*(Sophie|Renaud|Marc|Olivier|Démo Thermique|sdt)[^|\n]*\|'
flags: mi
match: not_contains
---

017-CA6 : la colonne Exemple ne reprend aucun nom de personne ni de société des sources.
