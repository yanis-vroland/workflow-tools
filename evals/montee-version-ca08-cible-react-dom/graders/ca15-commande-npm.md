---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n## )[\s\S])*?npm install[^\n`]*\breact-dom@\^?19\b'
match: contains
---

CA15 : « Plan de montée » donne la commande npm de la montée (`npm install … react-dom@19…`), gestionnaire détecté d'après `package-lock.json`.
