---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?[ée]cart[ée]'
flags: "i"
match: contains
---

Argument écarté : « Points non déterminés » signale que l'argument a été écarté (aucune mesure).
