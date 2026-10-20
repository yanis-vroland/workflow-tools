---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Périmètre et méthode[^\n]*\n(?=(?:(?!\n#{1,2} )[\s\S])*?https://fieldops\.example\.invalid/interventions)(?=(?:(?!\n#{1,2} )[\s\S])*?code seul)'
flags: "i"
match: contains
---

CA3 et CA17 : « Périmètre et méthode » cite l'URL demandée et indique que l'audit s'est fait en mode code seul.
