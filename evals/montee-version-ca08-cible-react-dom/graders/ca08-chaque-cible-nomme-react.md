---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\n[ \t]*(?:\d+[.)]|[-*])[ \t](?![^\n]*(?<![\w@/-])react(?:-dom)?(?![\w-]))'
match: not_contains
---

CA8 : chaque entrée de « Cibles retenues », à tout niveau de liste, nomme `react-dom` ou `react` : aucune autre cible, quelle que soit sa forme.
