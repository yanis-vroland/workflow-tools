---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Différences *$(?:(?!^#{1,6} )[\s\S])*?^[-*] +(?![^\n]*(Source\s*:|[Mm]ême source|supposé))[^\n]*$'
flags: m
match: not_contains
---

017-CA27 : chaque différence a sa source (ou « Même source. », qui renvoie à celle de la différence précédente), ou la marque « supposé ».
