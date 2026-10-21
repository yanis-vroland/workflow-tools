---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '2026-10-10'
match: not_contains
---

Témoin : le livrable a été mis à jour (la date de l'exécution précédente, 2026-10-10, a été remplacée), sinon les vérifications de conservation de ce cas réussiraient sur le livrable précédent intact.
