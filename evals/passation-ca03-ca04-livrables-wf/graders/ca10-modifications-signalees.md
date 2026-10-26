---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?scheduling\.ts'
match: contains
---

CA10 : « Travaux en cours » signale la modification non commitée de `src/domain/scheduling.ts`.
