---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S(?:1[2-9]|[2-9]\d)\b(?=(?:(?!\n###? )[\s\S])*?local_db\.dart)'
match: contains
---

CA20 : un nouveau constat (rawQuery interpolée de `mobile/lib/db/local_db.dart`, absent du livrable
précédent) reçoit un numéro supérieur au plus grand déjà attribué (S11), soit S12 ou plus.
