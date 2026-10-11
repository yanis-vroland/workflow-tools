---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: 'deploy-commun|plateforme/'
match: not_contains
---

CA20 : le livrable ne cite aucun fichier hors du sous-dossier (plateforme/deploy-commun.sh, pourtant le fichier le plus modifié du dépôt).
