---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?(?=(?:(?!\n##? )[\s\S])*?scheduling\.ts)(?:(?!\n##? )[\s\S])*?non commit'
flags: "i"
match: contains
---

CA10 : « Travaux en cours » signale les modifications non commitées, avec le fichier concerné (`src/domain/scheduling.ts`).
