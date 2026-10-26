---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n\| `([^`]+)` \|[^\n]*\| majeur \|(?=[\s\S]*\n## Cibles retenues[^\n]*\n)(?![\s\S]*\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?`\1`)'
match: not_contains
---

CA10 : chaque dépendance que l'inventaire classe en écart « majeur » figure dans « Cibles retenues » (comparaison avec l'inventaire du livrable lui-même, sans valeur publique figée).
