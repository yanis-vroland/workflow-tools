---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: 'entrees-client/|(/Users/|/home/|/tmp/|/private/|/var/|/root/)'
match: not_contains
---

005-CA3 et CA21 : le fichier d'entrée est désigné par son nom seul, jamais par un chemin (ni le sous-dossier `entrees-client/`, ni un chemin absolu).
