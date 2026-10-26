---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?![\s\S]*2026-10-01)[\s\S]*^[-*] *\**Niveau atteint\** *: *\**A\b'
flags: m
match: contains
---

017-CA11 et CA20 : la question bloquante Q03 restant vide, le livrable reste au niveau A.

Le livrable déposé par le scaffold contient déjà cette ligne : le motif exige aussi que la date de l'exécution précédente (2026-10-01) ait disparu, sans quoi il passerait sans exécution.
