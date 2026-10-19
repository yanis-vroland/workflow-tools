---
type: llm
focus: { source: file, path: "docs/wf/recette.md" }
---

CA11 : sous « Critères non recettables manuellement », chaque critère listé
porte sa source et une raison.

Réussite si `docs/wf/specs-tickets.md#T02-CA3` (cache mémoire côté serveur) et
`docs/specs/004-liste-des-interventions.md#CA2` (95e centile du temps de réponse
sous charge) y figurent, chacun avec une raison qui explique pourquoi une
personne ne peut pas le vérifier à la main (comportement interne non
observable, performance qui exige une mesure outillée). Échec si l'un manque ou
n'a pas de raison.
