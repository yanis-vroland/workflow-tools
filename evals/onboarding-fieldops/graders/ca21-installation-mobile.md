---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?flutter pub get\b'
match: contains
---

CA21 : « Installer le projet » couvre l'application Flutter (`fvm flutter pub get`, `mobile/README.md`).
