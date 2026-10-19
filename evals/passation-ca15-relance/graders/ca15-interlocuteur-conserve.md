---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Synth[èe]se[^\n]*\n(?:(?!\n##? )[\s\S])*?direction technique du client'
match: contains
---

CA15 : l'interlocuteur saisi à la main dans la Synthèse (responsable côté client : direction technique du client) est conservé.
