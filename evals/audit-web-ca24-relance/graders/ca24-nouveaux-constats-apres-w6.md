---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*2026-09-15)^(?![\s\S]*?(?:\n#{3,4} [^\n]*\bW[1-6]\b[^\n]*\n(?:(?!\n#{1,4} )[\s\S])*?InterventionList\.tsx))(?=[\s\S]*?wf-audit-web)'
match: contains
---

CA24 : les constats nouveaux (src/web/pages/InterventionList.tsx, absents de l'audit précédent) reçoivent un identifiant au-delà du dernier attribué (W7 et suivants).
