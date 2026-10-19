---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?\bDELETE\b)(?=(?:(?!\n###? )[\s\S])*?élevé)'
match: contains
---

CA10 et CA13 : le constat sur la route DELETE sans authentification est de niveau élevé.
