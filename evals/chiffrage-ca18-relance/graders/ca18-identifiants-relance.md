---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA18. Le livrable précédent (2026-10-01) comptait les tâches C01 à C09, avec « Dernier identifiant attribué : C10 » (C10 retiré auparavant). Depuis, dans le cadrage : B01, B02 et B04 sont inchangés ; B03 (saisie mobile, tâche C04) a été retiré ; B05 (tableau de bord, tâche C06) a été modifié (export tableur ajouté) ; B06 (rappel par SMS) a été ajouté.

Vérifie :

- C01, C02 (B01), C03 (B02) et C05 (B04) existent toujours, avec les mêmes estimations qu'avant (C01 : 2 et 3 ; C02 : 1,5 et 3 ; C03 : 1 et 1,5 ; C05 : 2 et 3) ;
- aucune tâche ne porte l'identifiant C04 ni C10 ;
- chaque tâche nouvelle (B06 notamment) a un identifiant supérieur à C10, et aucun identifiant n'est utilisé deux fois ;
- l'en-tête indique comme dernier identifiant attribué le plus grand identifiant jamais attribué (au moins C11) ;
- B03 n'est plus couvert par aucune tâche (il peut être mentionné dans « Exclusions » comme reporté ou hors périmètre).

Échoue si l'un de ces points est faux.
