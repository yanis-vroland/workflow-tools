---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:docker (?:build|push|compose)|vercel|netlify|fly(?:ctl)? deploy|firebase deploy|kubectl|scp |rsync|ssh |npm run (?:build|start)|flutter build)'
flags: "i"
match: not_contains
---

CA6 : aucune commande de déploiement n'est inventée dans « Environnements et déploiement ».
