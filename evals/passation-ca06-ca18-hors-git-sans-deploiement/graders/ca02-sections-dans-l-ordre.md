---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Synth[èe]se[\s\S]*\n##? [^\n]*Documentation de r[ée]f[ée]rence[\s\S]*\n##? [^\n]*Environnements et d[ée]ploiement[\s\S]*\n##? [^\n]*Services tiers et acc[èe]s[\s\S]*\n##? [^\n]*Secrets [àa] transmettre[\s\S]*\n##? [^\n]*Travaux en cours[\s\S]*\n##? [^\n]*Points d.attention[\s\S]*\n##? [^\n]*Checklist de passation[\s\S]*\n##? [^\n]*Points non d[ée]termin[ée]s'
match: contains
---

CA2 : les neuf sections sont présentes, en titres de niveau 1 ou 2, dans l'ordre de la spec.
