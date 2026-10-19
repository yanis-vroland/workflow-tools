---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?:(?!\n##? [^\n]*Pr[ée]requis)[\s\S])*?v1\.3\.0[^\n]*\b85e1db9\b'
match: contains
---

CA16 : l'en-tête ou « Périmètre et sources » indique la référence v1.3.0 et son
commit (`git log -1 --format=%h v1.3.0 --`, déterministe : 85e1db9), sur la même ligne.
