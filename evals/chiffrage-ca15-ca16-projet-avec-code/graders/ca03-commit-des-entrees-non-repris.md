---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '921f57c'
match: not_contains
---

005-CA3 : le cadrage et l'analyse fournis en entrée portent un commit plus ancien de la fixture (`921f57c`) ; le livrable ne le recopie pas, il donne le commit du projet au lancement.
