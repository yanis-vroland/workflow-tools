---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?\|\s*Action\s*\|\s*Source\s*\|\s*Statut\s*\|'
match: contains
---

CA14 : « Checklist de passation » est un tableau aux colonnes Action, Source, Statut.
