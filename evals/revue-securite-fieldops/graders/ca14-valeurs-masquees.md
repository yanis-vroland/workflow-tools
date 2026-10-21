---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: 'dev-secret|FAUX_JETON|c41d'
match: not_contains
---

CA14 : aucun fragment des valeurs littérales (`dev-secret`, `FAUX_JETON_FIELDOPS_c41d`) ne figure
dans le livrable.
