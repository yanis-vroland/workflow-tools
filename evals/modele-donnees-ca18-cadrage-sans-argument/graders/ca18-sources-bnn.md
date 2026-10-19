---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA18 et CA4. Le livrable est tiré de `cadrage-besoin.md`, dont la section « Besoins fonctionnels » porte les besoins B01 (planification et affectation selon zone et compétences), B02 (suivi de l'état : planifiée, en cours, terminée), B03 (compte rendu envoyé au client), B04 (historique par client et par équipement), B05 (tableau de bord mensuel), B06 (photos avant et après intervention).

- Les entités, attributs et relations tirés d'un besoin citent son identifiant `Bnn` comme source (ex. l'état d'une intervention cite B02, les photos citent B06), et l'identifiant cité correspond bien au besoin dont l'élément découle.
- Un élément tiré de la réponse déjà saisie à Q01 du cadrage (application mobile hors connexion) peut la citer ; un élément sans source est marqué « supposé ».
- Aucun identifiant `Bnn` cité n'est inventé (B07 ou plus n'existe pas).

Échoue si un élément tiré d'un besoin ne cite pas son `Bnn`, si un `Bnn` cité ne correspond pas, ou si un `Bnn` est inventé.
