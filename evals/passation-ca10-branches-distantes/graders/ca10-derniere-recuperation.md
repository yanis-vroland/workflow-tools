---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?derni[èe]re récupération'
match: contains
---

CA10 : « Travaux en cours » précise que l'état des branches distantes est celui de la dernière récupération faite sur ce poste.
