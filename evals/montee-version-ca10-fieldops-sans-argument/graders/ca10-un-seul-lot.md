---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]+(?:\*\*)?[Ll]ot\b(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]+(?:\*\*)?[Ll]ot\b'
match: not_contains
---

CA10 : les écarts mineurs et correctifs forment un lot unique : « Cibles retenues » n'a pas deux entrées de premier niveau qui sont des lots (entrées qui commencent par « Lot ») ; une autre entrée qui mentionne le lot (« exigé par le lot ») n'en est pas un.
