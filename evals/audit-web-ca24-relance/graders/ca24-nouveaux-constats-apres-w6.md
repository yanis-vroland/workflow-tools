---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW[1-6]\b[^\n]*\n(?:(?!\n#{1,4} )[\s\S])*?InterventionList\.tsx'
match: not_contains
---

CA24 : les constats nouveaux (src/web/pages/InterventionList.tsx, absents de l'audit précédent) reçoivent un identifiant au-delà du dernier attribué (W7 et suivants).
