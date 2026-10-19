---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?local_db\.dart)(?=(?:(?!\n###? )[\s\S])*?injection)'
flags: 'i'
match: contains
---

CA22 : la partie Flutter est analysée normalement (rawQuery de `mobile/lib/db/local_db.dart`).
