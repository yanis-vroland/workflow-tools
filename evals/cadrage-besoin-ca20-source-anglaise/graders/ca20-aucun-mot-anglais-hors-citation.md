---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '(?<!«[^»\n]*)\b(?:the|and|must|should|will|with|for|is|are|to|of|be|not|in scope)\b(?![^«\n]*»)'
flags: i
match: not_contains
---

004-CA20 : la source `brief-en.md` est en anglais, le livrable est rédigé entièrement en français. Aucun mot-outil anglais courant n'apparaît hors d'une citation entre « » (les citations, y compris les titres de section de la source cités comme source, restent dans leur langue). Remplace un juge `llm` qui échouait sur un livrable conforme (3 votes FAIL sans motif exploitable).
