---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*(?<![\w@/-])react(?![\w-])[^\n]*\b17\.0\.2\b[^\n]*non déterminée?'
match: contains
---

CA7 : la ligne de `react` garde la version installée du lockfile (17.0.2) et indique « non déterminé » pour la dernière version publiée.
