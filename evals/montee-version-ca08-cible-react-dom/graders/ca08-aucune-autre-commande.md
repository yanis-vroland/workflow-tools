---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '(?:npm install|flutter pub)[^\n`]*\b(?:express|vite|vitest|eslint|typescript|geolocator|http|flutter_lints)\b'
match: not_contains
---

CA8 : le plan ne donne aucune commande de montée d'une autre dépendance.
