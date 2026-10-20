---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^> *\**D01\b'
flags: m
match: contains
---

Témoin de `ca09-encadres-references`, `ca09-decisions-vides` et `ca09-aucune-recommandation` : au moins un encadré existe, sinon ces vérifications d'absence ne prouveraient rien.
