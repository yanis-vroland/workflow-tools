---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '42\s*/\s*100|Score de santé|18 jours|Dette élevée|React 18'
flags: "i"
match: not_contains
---

CA13 : aucun contenu du livrable wf-analyse-projet n'est repris (score, effort, jugement de dette, recommandation).
