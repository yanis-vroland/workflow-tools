---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:npx tsx|purge-closed-interventions)'
match: not_contains
---

CA5 : `.github/workflows/purge.yml` est une tâche planifiée, pas une procédure de déploiement : sa commande n'est pas donnée comme étape de déploiement.
