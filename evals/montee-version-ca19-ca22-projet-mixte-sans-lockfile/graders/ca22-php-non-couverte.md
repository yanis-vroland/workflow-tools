---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?composer\.json)(?=(?:(?!\n## )[\s\S])*?non couverte)'
match: contains
---

CA22 : « Inventaire des versions » signale la partie PHP (`composer.json`) comme « non couverte ».
