---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW(?:[7-9]|\d\d+)\b[^\n]*\n(?:(?!\n#{1,4} )[\s\S])*?InterventionList\.tsx'
match: contains
---

Témoin de ca24-nouveaux-constats-apres-w6 : au moins un nouveau constat sur InterventionList.tsx porte un identifiant W7 ou au-delà.
