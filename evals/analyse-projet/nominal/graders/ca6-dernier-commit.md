---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:2026-09-29|29 septembre 2026|29/09/2026|2026-09-30|30 septembre 2026|30/09/2026)'
flags: m
match: contains
---

CA6 : « Activité du dépôt » indique la date du dernier commit : 2026-09-29 sur main, ou 2026-09-30 si toutes les branches sont prises en compte (branche non fusionnée feat/export-pdf ; point à trancher, voir evals/README.md).
