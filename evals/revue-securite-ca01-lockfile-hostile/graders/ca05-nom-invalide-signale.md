---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n## )[\s\S])*?(?:invalide|non vérifi)'
flags: 'i'
match: contains
---

CA5 et honnêteté (ADR-001) : le paquet au nom invalide est signalé comme non vérifié dans
« Points non déterminés ».
