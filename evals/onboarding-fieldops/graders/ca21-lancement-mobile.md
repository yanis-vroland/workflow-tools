---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Lancer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?flutter run\b'
match: contains
---

CA21 : « Lancer le projet » couvre l'application Flutter (`fvm flutter run`, `mobile/README.md`).
