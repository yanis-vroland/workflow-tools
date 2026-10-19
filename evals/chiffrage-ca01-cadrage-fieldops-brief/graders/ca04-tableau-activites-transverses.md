---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Activités transverses *$(?:(?!^#{1,6} +(\d+\.? +)?Hypothèses *$)[\s\S])*?^\| *Identifiant *\| *Tâche *\| *Besoins couverts *\| *Estimation basse[^|\n]*\| *Estimation haute[^|\n]*\| *Commentaire *\| *\n\|[ :-]+\|(?:[ :-]*\|){5} *\n\| *C\d{2} *\|'
flags: m
match: contains
---

005-CA4 : « Activités transverses » contient un tableau aux six colonnes de la spec, dont la première ligne est une tâche `Cnn` (le cadrage justifie au moins le déploiement et la publication sur les stores).
