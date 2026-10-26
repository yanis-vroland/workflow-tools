---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\blodash\b'
match: contains
---

CA22 : dans ce projet mixte, la partie JS/TS est traitée normalement : lodash (écart majeur) est une cible.
