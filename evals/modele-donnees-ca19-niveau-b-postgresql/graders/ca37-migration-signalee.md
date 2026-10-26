---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Points non déterminés *$[\s\S]*migration\.sql[^\n]*plus lieu d.être'
flags: m
match: contains
---

017-CA37 : l'ancienne `migration.sql`, sans objet au niveau B, est signalée dans « Points non déterminés » comme n'ayant plus lieu d'être (une simple mention ailleurs, par exemple dans un tableau de fichiers, ne suffit pas).
