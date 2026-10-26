---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?(?:(?<![\w@/-])react(?![\w])|\b(?:vite|vitest|eslint|typescript|geolocator|flutter_lints|Node\.js|Flutter)\b)'
match: not_contains
---

CA8 : « Cibles retenues » ne porte que sur express.
