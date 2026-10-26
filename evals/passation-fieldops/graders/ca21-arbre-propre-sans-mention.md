---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?modifications non commitées'
flags: "i"
match: not_contains
---

CA21 : arbre de travail propre, donc pas de mention « modifications non commitées » dans l'en-tête (avant la Synthèse ; « Travaux en cours » peut écrire « Modifications non commitées : aucune »).
