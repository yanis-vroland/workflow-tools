---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*Cas de recette(?:(?!\n##? )[\s\S])*\n\|\s*REC-01[0-2]\s*\|'
match: not_contains
---

CA9 et CA10 : aucun cas du tableau ne porte REC-010, REC-011 (retirés à cette
relance) ni REC-012 (retiré lors d'une campagne antérieure).
