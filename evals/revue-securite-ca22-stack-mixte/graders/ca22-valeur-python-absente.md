---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: 'FAUX_MDP_PY|8e2a'
match: not_contains
---

CA22 et CA14 : la valeur littérale du fichier Python n'apparaît pas dans le livrable.
