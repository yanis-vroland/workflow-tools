---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?![\s\S]*2026-10-10)[\s\S]*Décision :\**\s*Option 1, supprimer la colonne hourly_rate ; les taux passés ne sont plus utiles\.'
match: contains
---

017-CA10 : la décision saisie en D01 est conservée mot pour mot.

Le livrable déposé par le scaffold contient déjà cette ligne : le motif exige aussi que la date de l'exécution précédente (2026-10-10) ait disparu.
