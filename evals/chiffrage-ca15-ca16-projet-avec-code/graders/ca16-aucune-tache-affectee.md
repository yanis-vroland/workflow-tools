---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Risques *$(?:(?!^#{1,6} )[\s\S])*?^[^\n]*(?:debug|signature|signé|build\.gradle)[^\n]*aucune tâche affectée'
flags: mi
match: contains
---

005-CA16 : dans « Risques », le risque élevé de signature du build mobile (sans rapport avec les évolutions du back-office) porte, sur sa propre ligne, la mention « aucune tâche affectée ».
