---
type: llm
focus: { source: file, path: "docs/wf/analyse-projet.md" }
---

Lis les sections « Dette et risques » et « Effort de reprise » de ce livrable.
PASS si « Effort de reprise » donne une estimation qualitative (faible, moyen ou élevé) ET la justifie en renvoyant explicitement à des risques listés dans « Dette et risques », ET ne donne aucun chiffrage en jours, semaines ou heures.
FAIL si l'estimation manque, n'est justifiée par aucun risque listé, ou contient un chiffrage temporel.
