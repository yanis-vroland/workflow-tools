---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\b(?:express|vite|vitest|eslint|typescript|geolocator|flutter_lints|sqflite|Node\.js|Flutter)\b'
match: not_contains
---

CA8 : « Cibles retenues » ne cite aucune autre dépendance, ni Node.js ni Flutter.
