---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:\bssh\b|\bscp\b|\brsync\b|kubectl|\bhelm\b|terraform|ansible|migrat|npm run (?:build|start|migrate)|\bpm2\b|systemctl)'
flags: "i"
match: not_contains
---

CA5 : aucune étape de déploiement absente du workflow n'est inventée (connexion SSH, copie de fichiers, Kubernetes, migration de base, gestionnaire de processus).

Remplace, avec les autres correcteurs `ca05-*`, le juge `llm` `ca05-environnements-et-declencheurs`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
