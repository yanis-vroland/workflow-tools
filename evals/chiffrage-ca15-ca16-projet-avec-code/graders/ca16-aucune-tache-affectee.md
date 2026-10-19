---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Risques *$(?:(?!^#{1,6} +(\d+\.? +)?Points non déterminés *$)[\s\S])*?aucune tâche affectée'
flags: mi
match: contains
---

005-CA16 : le risque élevé sans rapport avec les évolutions (signature du build mobile) est repris dans « Risques » avec la mention « aucune tâche affectée ».
