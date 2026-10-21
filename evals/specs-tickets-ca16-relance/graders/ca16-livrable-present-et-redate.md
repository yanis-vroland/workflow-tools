---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^[-*] *\**Date\** *: *(?!2026-10-10)\d{4}-\d{2}-\d{2}\b'
flags: m
match: contains
---

006-CA16 (témoin) : à la fin de l'exécution, `docs/wf/specs-tickets.md` existe toujours (un motif `contains` échoue sur un fichier absent) et son en-tête porte une nouvelle date, autre que celle du livrable précédent (2026-10-10) : le livrable a été réécrit en place, ni supprimé, ni déplacé.

Un correcteur `file_exists` ne convient pas ici : il ne voit que les fichiers créés pendant l'exécution, or ce livrable est déposé par le scaffold puis réécrit.
