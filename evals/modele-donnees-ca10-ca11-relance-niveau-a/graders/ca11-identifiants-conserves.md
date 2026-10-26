---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA11 (identifiants conservés). Le livrable précédent contenait :

- les entités E01 Client, E02 Technicien, E04 Intervention, E05 Équipement ;
- les règles RG01 (intervention demandée par un client), RG02 (au plus un technicien par intervention), RG04 (un client possède des équipements), RG05 (une intervention concerne un équipement) ;
- les questions Q01 (sites du client), Q03 (plusieurs techniciens par intervention), Q04 (indicateurs du tableau de bord), Q05 (reprise de l'historique du tableur) ;
- la décision D01 (retrait d'un technicien).

Dans le nouveau livrable, chacun de ces éléments, s'il figure encore, porte exactement le même identifiant qu'avant (ex. l'intervention est toujours E04, la reprise de l'historique toujours Q05). Une règle reformulée pour intégrer une saisie garde son identifiant.

Échoue si l'un d'eux a changé d'identifiant.
