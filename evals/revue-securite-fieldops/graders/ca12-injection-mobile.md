---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?local_db\.dart[^\n]{0,15}\b33\b)(?=(?:(?!\n###? )[\s\S])*?injection)'
flags: 'i'
match: contains
---

CA12 : la `rawQuery` interpolée de `mobile/lib/db/local_db.dart` (ligne 33) donne un constat de
catégorie « injection » avec le fichier et la ligne.
