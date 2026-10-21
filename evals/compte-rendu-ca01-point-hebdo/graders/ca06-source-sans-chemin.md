---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdo-fieldops.md" }
pattern: 'notes/2026-10-07-point-hebdo|/Users/|/home/|/tmp/|/private/|/var/|/root/|[A-Za-z]:\\'
match: not_contains
---

007-CA6 (amendement 1 de l'ADR-001) : la source est citée par son nom de fichier seul ; ni le dossier `notes/`, ni aucun chemin absolu n'apparaît.
