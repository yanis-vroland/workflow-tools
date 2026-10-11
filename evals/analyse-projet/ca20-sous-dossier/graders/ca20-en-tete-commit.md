---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?Commit analysé[\s*:\x60]*[0-9a-f]{7,40}\b'
match: contains
---

CA20 : l'en-tête indique le commit du dépôt (hash court, non figé : il dépend du nom du sous-dossier), comme pour tout projet dans git.
