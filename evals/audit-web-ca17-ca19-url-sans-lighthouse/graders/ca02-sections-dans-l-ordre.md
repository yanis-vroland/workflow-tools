---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Synthèse[\s\S]*\n#{1,2} [^\n]*Périmètre et méthode[\s\S]*\n#{1,2} [^\n]*Performance[\s\S]*\n#{1,2} [^\n]*Accessibilit[ée][\s\S]*\n#{1,2} [^\n]*Référencement[\s\S]*\n#{1,2} [^\n]*Bonnes pratiques[\s\S]*\n#{1,2} [^\n]*Plan d.action[\s\S]*\n#{1,2} [^\n]*Points non d[ée]termin[ée]s'
match: contains
---

CA2 : les huit sections, en titres de niveau 1 ou 2, dans l'ordre de la spec.
