---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Vérifications[^\n]*\n(?=(?:(?!\n## )[\s\S])*?npm (?:run )?test\b)(?=(?:(?!\n## )[\s\S])*?npm run lint\b)(?=(?:(?!\n## )[\s\S])*?npm run build\b)(?=(?:(?!\n## )[\s\S])*?flutter analyze\b)(?=(?:(?!\n## )[\s\S])*?flutter test\b)'
match: contains
---

CA16 : « Vérifications » donne les commandes tirées des scripts de `package.json` (`test`, `lint`, `build`) et celles de la stack Flutter (`flutter analyze`, `flutter test`).
