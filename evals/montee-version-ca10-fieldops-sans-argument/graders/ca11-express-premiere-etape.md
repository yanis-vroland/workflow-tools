---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n#{2,3} )[\s\S])*\n### (?:(?!\n#{2,3} )[\s\S])*?\n[ \t]*-[ \t]*Paquets\s*:[^\n]*`express`'
match: contains
---

CA11 : la première étape (`###`) de « Plan de montée » monte `express` (ligne « Paquets »).
