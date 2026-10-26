---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*(?:différent|diverg|écart entre)[^\n]*(?=[^\n]*17\.0\.2)(?=[^\n]*18\.2\.0)'
flags: i
match: contains
---

CA27 : une ligne de « Inventaire des versions » signale la différence de version de react entre applications, avec 17.0.2 et 18.2.0.
