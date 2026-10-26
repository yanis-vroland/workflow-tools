---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n## )[\s\S])*?\n[ \t]*-[ \t]*Paquets[^\n]*(?:@types/|\b(?:express|vite|vitest|eslint|typescript|geolocator|http|flutter_lints|Node\.js|Flutter)\b)'
match: not_contains
---

CA8 : les lignes « Paquets » du plan ne portent que sur `react-dom` et `react`.
