---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n## )[\s\S])*?npm install[^\n`]*\breact-dom@\d'
match: contains
---

CA15 : « Plan de montée » donne la commande npm de la montée de react-dom (`npm install … react-dom@<version>`).
