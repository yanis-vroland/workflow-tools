---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?![\s\S]*2026-10-08)[\s\S]*Décision :\**\s*Option 2, désactivation avec une date de départ ; on garde l.historique\.'
match: contains
---

017-CA10 : la décision saisie en D01 est conservée mot pour mot au passage au niveau B.

Le livrable déposé par le scaffold contient déjà cette ligne : le motif exige aussi que la date de l'exécution précédente (2026-10-08) ait disparu.
