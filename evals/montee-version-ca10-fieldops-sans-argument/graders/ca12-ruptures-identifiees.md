---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Ruptures et impacts[^\n]*\n(?:(?!\n## )[\s\S])*?\n### R1\b'
match: contains
---

CA12 : « Ruptures et impacts » contient au moins une rupture identifiée (`### R1 …`) : la montée de react-dom en version 19 ou plus en comporte au moins une connue (suppression de `ReactDOM.render`). Témoin des correcteurs qui suivent.
