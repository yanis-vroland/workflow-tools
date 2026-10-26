---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Périmètre et méthode[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?[ée]cart[ée]'
flags: "i"
match: contains
---

Argument écarté : « Périmètre et méthode » signale que l'argument a été écarté.
