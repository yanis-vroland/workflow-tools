---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?![\s\S]*2026-10-01)[\s\S]*Réponse :\**\s*Oui, un client peut avoir plusieurs sites ; chaque équipement est installé sur un seul site, et une intervention a lieu sur un site\.'
match: contains
---

017-CA10 (amendement 1, saisies humaines) : la réponse saisie à la main pour Q01 est conservée mot pour mot.

Le livrable déposé par le scaffold contient déjà cette ligne : le motif exige aussi que la date de l'exécution précédente (2026-10-01) ait disparu, sans quoi il passerait sans exécution.
