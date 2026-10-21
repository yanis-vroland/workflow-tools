---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: 'besoins/cahier-des-charges-export|(/Users/|/home/|/tmp/|/private/|/var/|/root/)'
match: not_contains
---

006-CA3 (amendement 1) : le fichier d'entrée n'est jamais désigné avec son répertoire, ni par un chemin absolu.
