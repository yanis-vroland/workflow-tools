---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Secrets et configuration[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?\.env\.staging)(?=(?:(?!\n###? )[\s\S])*?élevé)'
match: contains
---

CA16 : le fichier `.env.staging`, suivi par git, donne un constat de niveau élevé dans « Secrets et
configuration », qui cite son chemin.
