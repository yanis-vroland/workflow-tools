---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n##? [^\n]*Synth[èe]se[\s\S]*\n##? [^\n]*P[ée]rim[èe]tre et m[ée]thode[\s\S]*\n##? [^\n]*D[ée]pendances vuln[ée]rables[\s\S]*\n##? [^\n]*Constats dans le code[\s\S]*\n##? [^\n]*Secrets et configuration[\s\S]*\n##? [^\n]*Points non d[ée]termin[ée]s'
match: contains
---

CA2 : les six sections sont présentes, en titres de niveau 1 ou 2, dans l'ordre de la spec.
