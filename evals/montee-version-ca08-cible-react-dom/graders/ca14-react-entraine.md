---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n## )[\s\S])*?(?<![\w-])react@\^?19\b'
match: contains
---

CA14 : `react` 19, exigé par `react-dom` 19 en dépendance pair, est monté dans le plan (`react@19…`).
