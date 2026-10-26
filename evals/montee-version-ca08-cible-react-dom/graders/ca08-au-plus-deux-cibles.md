---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]){3}'
match: not_contains
---

CA8 : « Cibles retenues » a au plus deux entrées de premier niveau (liste numérotée ou à puces) : `react-dom` et, éventuellement, `react` qu'il entraîne. Remplace le juge `llm` ca08-cible-unique, bruité sur ce livrable long.
