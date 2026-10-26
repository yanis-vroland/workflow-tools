---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n## )[\s\S])*?flutter pub (?:add|upgrade)\b'
match: contains
---

CA15 : « Plan de montée » donne une commande `flutter pub add` ou `flutter pub upgrade` pour l'application Flutter.
