---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Ruptures et impacts[^\n]*\n(?:(?!\n## )[\s\S])*?src/web/main\.tsx(?::5\b|[^\n]{0,40}\bl(?:igne|\.)\s*5\b)'
match: contains
---

CA13 : la suppression de `ReactDOM.render` en React 19 touche `src/web/main.tsx` ligne 5 ; « Ruptures et impacts » cite ce fichier et cette ligne.
