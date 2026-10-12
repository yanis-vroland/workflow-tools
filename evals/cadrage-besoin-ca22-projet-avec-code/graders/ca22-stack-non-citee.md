---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: 'React|Express|Vitest|sqflite|shared_preferences'
match: not_contains
---

004-CA22 : aucun élément de la stack de la fixture, connu seulement par le code, n'apparaît dans le livrable.
