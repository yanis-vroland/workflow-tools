---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Risques *$(?:(?!^#{1,6} )[\s\S])*?^[^\n]*(?:SQL|concaténation|injection)[^\n]*\bC\d{2}\b'
flags: mi
match: contains
---

005-CA16 : dans « Risques », le risque élevé de requête SQL concaténée indique, sur sa propre ligne, au moins une tâche `Cnn` affectée.
