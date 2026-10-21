---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA10. Estimations hautes du chiffrage, en jours : C01 3, C02 4, C03 1,5, C04 5, C05 5, C06 2, C07 1,5, C08 3, C09 3, C10 4,5, C11 3, C12 1,5, C13 3,5.

Pour chaque ticket dont la rubrique « Estimation » cite au moins deux tâches `Cnn`, calcule la somme des estimations hautes de ces tâches avec les valeurs ci-dessus : elle doit être d'au plus 5 jours. En particulier, aucun ticket ne cite à la fois C01 et C02 (7 jours), ni à la fois C04 et C05 (10 jours), ni C04 ou C05 avec C06 ou C12. Un ticket qui ne cite qu'une seule tâche n'est pas concerné, quelle que soit son estimation.

Les besoins B01 et B03, dont les tâches cumulent plus de 5 jours, sont donc découpés en plusieurs tickets.

Échoue si un seul ticket dépasse 5 jours d'estimation haute cumulée.
