---
type: llm
focus: { source: file, path: "docs/wf/cadrage-besoin.md" }
---

004-CA4. Dans la section « Besoins fonctionnels » du livrable :

- chaque besoin porte un identifiant de la forme `Bnn` (`B01`, `B02`…), et aucun identifiant n'est utilisé deux fois ;
- chaque besoin a un libellé, une priorité et au moins une source ;
- chaque source cite le nom du fichier (`brief-fieldops.md` ou `notes-appel.md`) ET le titre de la section Markdown d'où vient le besoin (ex. « Fonctionnalités souhaitées », « Ce qui ressort de l'appel ») ;
- la section contient au moins : la planification des interventions, le suivi de l'état des interventions, la saisie du compte rendu avec envoi au client, l'historique par client et par équipement, le tableau de bord mensuel.

Échoue si un besoin n'a pas d'identifiant, de libellé, de priorité ou de source, si une source omet le titre de section, si un de ces cinq besoins manque, ou si deux besoins partagent un identifiant.
