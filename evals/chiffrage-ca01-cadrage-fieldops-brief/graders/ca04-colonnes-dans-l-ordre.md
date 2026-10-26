---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *Identifiant *\|(?! *Tâche *\| *Besoins couverts *\| *Estimation basse[^|\n]*\| *Estimation haute[^|\n]*\| *Commentaire *\| *$)'
flags: m
match: not_contains
---

005-CA4 : aucun tableau de tâches n'a d'autres colonnes, ou un autre ordre, que ceux de la spec (identifiant, tâche, besoins couverts, estimation basse, estimation haute, commentaire).
