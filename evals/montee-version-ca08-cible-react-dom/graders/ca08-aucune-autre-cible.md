---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?(?:@types/|\b(?:express|vite|vitest|eslint|typescript|geolocator|flutter_lints|sqflite|Node\.js|Flutter)\b)'
match: not_contains
---

CA8 : « Cibles retenues » ne cite aucune autre dépendance que `react-dom` et `react` (entraîné par dépendance pair, CA14) : ni paquet de types « recommandé » (`@types/…`, non exigé par les métadonnées de `react-dom`), ni outillage, ni Node.js, ni Flutter.
