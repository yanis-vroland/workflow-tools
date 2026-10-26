---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '2026-10-01|2026-09-30'
match: not_contains
---

Témoin : le livrable a été mis à jour (date de génération du 2026-10-01 et date du cadrage précédent, 2026-09-30, remplacées), sinon les vérifications de conservation réussiraient sur le livrable précédent intact.
