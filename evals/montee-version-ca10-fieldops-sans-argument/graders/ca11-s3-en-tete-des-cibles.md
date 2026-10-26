---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )(?!\n[ \t]*(?:\d+[.)]|[-*])[ \t])[\s\S])*\n[ \t]*(?:\d+[.)]|[-*])[ \t][^\n]*\bS3\b'
match: contains
---

CA11 : la première entrée de « Cibles retenues » cite `S3`, l'entrée du livrable `docs/wf/revue-securite.md` (express 4.18.2, première version corrigée 4.19.2) : la montée d'express atteint cette version.
