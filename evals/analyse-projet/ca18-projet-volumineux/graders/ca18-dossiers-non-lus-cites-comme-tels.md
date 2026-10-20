---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^## +(?:Synthèse|Stack et dépendances|Architecture|Qualité et tests|Effort de reprise)[^\n]*\n(?:(?!## )[^\n]*\n)*?(?![^\n]*(?:\bhors\b|non lu|non analysé|pas (?:été )?(?:lu|analysé)|exclu|Points non déterminés))[^\n]*src/legacy'
flags: mi
match: not_contains
---

CA18 : dans « Synthèse », « Stack et dépendances », « Architecture », « Qualité et tests » et « Effort de reprise », toute ligne qui cite `src/legacy/` dit aussi qu'il n'a pas été lu ou qu'il est exclu (« hors », « non lu », « non analysé », « exclu », renvoi à « Points non déterminés ») : aucune conclusion ne porte sur son contenu. « Activité du dépôt » peut le citer, ses chiffres venant de git et non de la lecture des fichiers.
