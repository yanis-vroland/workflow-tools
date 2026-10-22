---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n### R\d+\b[^\n]*\n(?!(?:(?!\n### |\n## )[\s\S])*?(?:sans impact identifié|\n[ \t]*-[ \t]*Impacts[^\n]*\(\d+[^\n)]*\)[^\n]*`[^`\n]+:\d+`))'
match: not_contains
---

CA13 : chaque rupture (`### Rn`) a soit une ligne « Impacts (N …) » qui cite au moins un emplacement `<chemin>:<ligne>`, soit la mention « sans impact identifié ». Remplace le juge `llm` ca13-impacts-ou-sans-impact, bruité sur ce livrable long ; la cohérence du total reste vérifiée par le juge du cas ca08 (`ca13-impacts-et-total`).
