---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:2026-09-29|29 septembre 2026|29/09/2026)'
flags: m
match: contains
---

CA6 : « Activité du dépôt » indique la date du dernier commit de la branche courante (main) : 2026-09-29. La skill analyse la branche courante (`HEAD`) : le 2026-09-30 de la branche non fusionnée feat/export-pdf n'est pas accepté.
