---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA21. Le fichier `cahier-des-charges.md` n'utilise pas d'identifiants `Bnn`. Il décrit quatre fonctionnalités, sous les titres « 2.1 Compte client », « 2.2 Suivi des interventions », « 2.3 Comptes rendus » et « 2.4 Demande d'intervention ».

Dans la section « Périmètre chiffré » :

- l'outil a attribué lui-même des identifiants `B01`, `B02`… aux besoins, sans doublon ;
- les quatre fonctionnalités y figurent ;
- chaque besoin indique sa source : le nom de fichier seul (`cahier-des-charges.md`, sans le dossier `entrees-client/`) ET la section (titre ou numéro de section) d'où il vient.

Les tâches de « Détail par lot » utilisent ces mêmes identifiants dans leur colonne « besoins couverts ».

Échoue si un de ces points est faux.
