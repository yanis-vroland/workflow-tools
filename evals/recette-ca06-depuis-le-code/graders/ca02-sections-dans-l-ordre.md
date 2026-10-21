---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources[\s\S]*\n##? [^\n]*Pr[ée]requis[\s\S]*\n##? [^\n]*Cas de recette[\s\S]*\n##? [^\n]*Couverture[\s\S]*\n##? [^\n]*Synth[èe]se de la campagne[\s\S]*\n##? [^\n]*Points non d[ée]termin[ée]s'
match: contains
---

CA2 : les six sections sont présentes, en titres de niveau 1 ou 2, dans l'ordre de la spec.
