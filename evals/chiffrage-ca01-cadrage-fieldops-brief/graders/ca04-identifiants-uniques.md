---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA4. Dans les tableaux de « Détail par lot » et de « Activités transverses » :

- chaque ligne de tâche a un identifiant de la forme `Cnn` (`C01`, `C02`…), sur deux chiffres ;
- aucun identifiant n'est utilisé par deux tâches ;
- chaque ligne remplit les six colonnes (identifiant, tâche, besoins couverts, estimation basse, estimation haute, commentaire) ; la colonne « besoins couverts » d'une activité transverse peut indiquer qu'elle ne couvre aucun besoin ;
- aucune tâche n'est décrite hors d'un tableau (une liste à puces de tâches estimées serait une erreur).

Échoue si l'un de ces points est faux.
