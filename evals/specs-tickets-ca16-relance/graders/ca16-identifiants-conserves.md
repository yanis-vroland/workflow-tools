---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA16 (identifiants conservés). Le livrable précédent contenait :

- T01 « Planifier et affecter les interventions » (besoin B01), critères CA1 (planification à une date pour un technicien) et CA2 (avertissement de zone) ;
- T02 « Suivre l'état d'une intervention » (B02), critères CA1 (passage à « en cours ») et CA3 (passage à « terminée ») ;
- T04 « Saisir le compte rendu sur mobile, hors connexion » (B03), critère CA1 ;
- T05 « Envoyer le compte rendu au client » (B04), critère CA1.

Les besoins couverts par ces tickets n'ont pas changé dans le cadrage. Dans le nouveau livrable :

- le ticket qui couvre B01 est toujours T01, celui qui couvre B02 toujours T02, celui qui couvre B03 toujours T04, celui qui couvre B04 toujours T05 ;
- leurs critères conservés gardent leur numéro (ex. le passage à « terminée » est toujours T02-CA3, l'avertissement de zone toujours T01-CA2) ;
- un critère ajouté à un ticket existant reçoit un numéro supérieur au plus grand jamais attribué dans ce ticket (pour T02 : CA4 ou plus, jamais CA2).

Échoue si l'un de ces points est faux.
