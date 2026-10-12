---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Glossaire m[ée]tier[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*\bRavel\b)(?=[^\n]*définition non déterminée)'
match: contains
---

CA11 : le terme Ravel, dont aucun fichier n'établit le sens, porte la mention « définition non déterminée ».
