---
type: llm
focus: trace
---

017-CA22 (index justifiés). Dans le contenu de `docs/wf/modele-donnees/schema.sql` écrit par l'outil (appel Write visible dans la trace) :

- chaque index autre qu'une clé primaire ou une contrainte d'unicité (`CREATE INDEX`) est accompagné d'une justification qui cite une requête de `requetes.sql` (par son identifiant, ex. `R03`) ou une règle `RGnn` ;
- la requête citée existe dans le contenu de `requetes.sql` écrit par l'outil, et utilise bien les colonnes de l'index (filtre, jointure ou tri) ; la règle citée existe dans `index.md`.

S'il n'y a aucun `CREATE INDEX`, le critère est satisfait. Échoue si un index n'est pas justifié ou si sa justification ne correspond à rien.
