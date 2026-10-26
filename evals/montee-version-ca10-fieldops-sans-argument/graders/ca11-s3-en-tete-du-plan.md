---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n#{2,3} )[\s\S])*\n### (?:(?!\n#{2,3} )[\s\S])*?\bS3\b'
match: contains
---

CA11 : la première étape (`###`) de « Plan de montée » cite `S3`.
