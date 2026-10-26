---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?react-dom[^\n]*\b19\.\d+\.\d+\b'
match: contains
---

CA8 et CA9 : la version partielle `19` est résolue en une version publiée précise (19.x.y) dans « Cibles retenues ».
