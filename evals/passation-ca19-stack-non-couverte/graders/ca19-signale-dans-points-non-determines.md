---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:non couverte|d[ée]pendances)'
flags: "i"
match: contains
---

CA19 : « Points non déterminés » signale que les services tiers n'ont pas été recherchés dans les dépendances (stack non couverte).
