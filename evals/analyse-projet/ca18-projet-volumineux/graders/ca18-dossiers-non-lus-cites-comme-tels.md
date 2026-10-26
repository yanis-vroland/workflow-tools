---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^## +(?:Synthèse|Stack et dépendances|Architecture|Qualité et tests|Effort de reprise)[^\n]*\n(?:(?!## )[^\n]*\n)*?(?![^\n]*(?:\bhors (?:de )?(?:la )?(?:lecture|analyse|inventaire|périmètre)|\(hors\b|non lu|non analysé|pas (?:été )?(?:lu|analysé)|\bexclu(?:e|s|es)?\b|Points non déterminés))[^\n]*\blegacy\b'
flags: mi
match: not_contains
---

CA18 : dans « Synthèse », « Stack et dépendances », « Architecture », « Qualité et tests » et « Effort de reprise », toute ligne qui cite `src/legacy/`, sous quelque forme de chemin (`legacy/billing`…), dit aussi qu'il n'a pas été lu ou qu'il est exclu (« hors de la lecture », « hors analyse », « hors inventaire », « hors périmètre », « (hors … », « non lu », « non analysé », « exclu(e)(s) » en mot entier, renvoi à « Points non déterminés ») : aucune conclusion ne porte sur son contenu. « Activité du dépôt » peut le citer, ses chiffres venant de git et non de la lecture des fichiers.
