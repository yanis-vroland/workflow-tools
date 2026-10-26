---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*\blodash\b[^\n]*\^3\.10\.1[^\n]*non déterminée?'
match: contains
---

CA19 : sans lockfile, la ligne de `lodash` se fonde sur la contrainte déclarée (`^3.10.1`) et indique la version installée « non déterminé ».
