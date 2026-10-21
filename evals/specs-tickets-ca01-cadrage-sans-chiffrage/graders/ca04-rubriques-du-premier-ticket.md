---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^#{2,5} +T01 *: *[^\n]+$[\s\S]*?Récit utilisateur[\s\S]*?Contexte[\s\S]*?Critères d.acceptation[\s\S]*?Hors périmètre[\s\S]*?Dépendances[\s\S]*?Besoins couverts[\s\S]*?Estimation[\s\S]*?Fichiers concernés[\s\S]*?Points à clarifier'
flags: m
match: contains
---

006-CA4 : le premier ticket est une sous-section titrée `T01 : <titre>`, suivie des neuf rubriques de la spec dans l'ordre.
