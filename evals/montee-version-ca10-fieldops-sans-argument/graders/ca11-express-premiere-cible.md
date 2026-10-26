---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )(?!\n[ \t]*(?:\d+[.)]|[-*])[ \t])[\s\S])*\n[ \t]*(?:\d+[.)]|[-*])[ \t]+[^\n]*?`express`[^\n]*\b(?:[5-9]|\d\d)\.\d+\.\d+\b'
match: contains
---

CA11 : la première entrée de « Cibles retenues » monte `express` vers une version supérieure ou égale à la première version corrigée de S3 (4.19.2) : ici la dernière version publiée, 5 ou plus. Avec ca11-s3-en-tete-des-cibles (S3 cité), remplace le juge `llm` ca11-express-en-tete, bruité sur ce livrable long.
