---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Ruptures et impacts[^\n]*\n(?=(?:(?!\n## )[\s\S])*?src/index\.ts(?::7\b|[^\n]{0,40}\bl(?:igne|\.)\s*7\b))(?=(?:(?!\n## )[\s\S])*?src/report\.ts(?::5\b|[^\n]{0,40}\bl(?:igne|\.)\s*5\b))'
match: contains
---

CA13 : la suppression de `_.pluck` en lodash 4 touche `src/index.ts` ligne 7 et `src/report.ts` ligne 5 ; « Ruptures et impacts » cite les deux.
