---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^\s*[-*]\s*\**B(0[7-9]|[1-9]\d)\b'
flags: m
match: contains
---

004-CA14 : un besoin absent du livrable précédent (ex. l'historique par client et par équipement de `brief-fieldops.md`) reçoit un identifiant après le plus grand jamais attribué, B07 ou plus.
