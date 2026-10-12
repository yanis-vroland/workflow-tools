---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?npm (?:install|ci)\b'
match: contains
---

CA7 : la voie principale est l'installation native décrite par le README (`npm install`).
