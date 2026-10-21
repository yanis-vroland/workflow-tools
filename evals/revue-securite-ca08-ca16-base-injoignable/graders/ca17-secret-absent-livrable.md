---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: 'FIELDOPS_FAUX_SECRET'
match: not_contains
---

CA17 : aucune valeur du fichier d'environnement local (marqueur `FIELDOPS_FAUX_SECRET_7f3a`)
n'apparaît dans le livrable.
