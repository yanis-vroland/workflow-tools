---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Relations *$\n+[-*] +\S'
flags: m
match: contains
---

Témoin de `ca04-relations-sourcees` : la sous-section « Relations » existe et liste au moins une relation, sinon l'absence de relation non sourcée ne prouverait rien.
