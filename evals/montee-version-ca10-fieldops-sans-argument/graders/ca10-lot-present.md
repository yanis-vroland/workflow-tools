---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]+(?:\*\*)?[Ll]ot\b'
match: contains
---

CA10 : FieldOps a des dépendances en écart mineur ou correctif : « Cibles retenues » a une entrée de premier niveau qui est le lot (elle commence par « Lot »).
