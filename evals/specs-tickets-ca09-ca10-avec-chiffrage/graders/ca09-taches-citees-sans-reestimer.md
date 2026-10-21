---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA9. Le chiffrage (`docs/wf/chiffrage.md`) contient, avec leurs besoins couverts et leurs estimations basse et haute en jours :

- Détail par lot : C01 (B01, 2 à 3), C02 (B01, 2 à 4), C03 (B02, 1 à 1,5), C04 (B03, 4 à 5), C05 (B03, 3 à 5), C06 (B07, 1 à 2), C07 (B04, 1 à 1,5), C08 (B05, 2 à 3), C09 (B06, 2 à 3) ;
- Activités transverses : C10 gestion de projet (3 à 4,5), C11 recette (2 à 3), C12 publication Play Store (B03, 1 à 1,5), C13 déploiement (3 à 3,5).

Dans le livrable :

- la rubrique « Estimation » de chaque ticket cite au moins une tâche `Cnn`, et uniquement des tâches dont un besoin couvert figure dans la rubrique « Besoins couverts » du ticket, ou une tâche transverse en rapport direct avec le ticket ;
- chacune des tâches C01 à C09 est citée dans la rubrique « Estimation » d'au moins un ticket ;
- aucune nouvelle estimation : toute valeur en jours qui apparaît dans une rubrique « Estimation » est l'estimation d'une tâche citée, telle que dans le chiffrage, ou la somme exacte des estimations des tâches citées ; aucun ticket n'est estimé en heures, en points ou en taille (S/M/L) ;
- aucune rubrique « Estimation » n'indique « non estimé ».

Échoue si l'un de ces points est faux.
