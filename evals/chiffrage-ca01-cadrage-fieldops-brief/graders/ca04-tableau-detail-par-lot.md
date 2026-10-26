---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Détail par lot *$(?:(?!^#{1,6} +(\d+\.? +)?Activités transverses *$)[\s\S])*?^\| *Identifiant *\| *Tâche *\| *Besoins couverts *\| *Estimation basse[^|\n]*\| *Estimation haute[^|\n]*\| *Commentaire *\| *\n\|[ :-]+\|(?:[ :-]*\|){5} *\n\| *C\d{2} *\|'
flags: m
match: contains
---

005-CA4 : « Détail par lot » contient un tableau aux six colonnes de la spec, dans l'ordre (identifiant, tâche, besoins couverts, estimation basse, estimation haute, commentaire), dont la première ligne est une tâche `Cnn`.
