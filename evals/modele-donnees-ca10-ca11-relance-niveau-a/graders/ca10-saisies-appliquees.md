---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA10. Le livrable précédent contenait deux saisies à la main :

- réponse à Q01 : « Oui, un client peut avoir plusieurs sites ; chaque équipement est installé sur un seul site, et une intervention a lieu sur un site. »
- décision en D01 (retrait d'un technicien) : « Option 2, désactivation avec une date de départ ; on garde l'historique. »

Dans le nouveau livrable :

- le modèle intègre la réponse à Q01 : une notion de site (ou adresse d'intervention) rattachée au client, à laquelle sont rattachés les équipements et les interventions, avec pour source « réponse saisie à la question Q01 » ;
- le modèle applique la décision D01 : le technicien porte une information de désactivation ou de date de départ, et aucune suppression définitive n'est prévue, avec pour source « décision saisie en D01 » ;
- Q01 et D01 figurent toujours, avec leur saisie inchangée ;
- la question Q03, bloquante et sans réponse, garde un champ « Réponse : » vide, et l'outil n'en invente pas la réponse.

Échoue si l'un de ces points est faux.
