---
type: llm
focus: trace
---

017-CA24. En t'appuyant sur le contenu de `schema.sql`, `donnees-test.sql` et `requetes.sql` écrits par l'outil (appels Write visibles dans la trace) :

- les données de test sont manifestement fictives (aucun nom, adresse, e-mail ou téléphone réaliste d'une vraie personne ; une adresse e-mail, s'il y en a, est dans un domaine réservé comme `example.invalid`) ;
- elles respectent les contraintes du schéma : chaque ligne référencée par une clé étrangère est insérée avant la ligne qui la référence, avec un identifiant existant ; chaque valeur soumise à un `CHECK` fait partie des valeurs autorisées ; aucune colonne `NOT NULL` sans valeur par défaut n'est omise ;
- chaque requête de `requetes.sql`, appliquée à ces données, renvoie au moins une ligne (examine les filtres : dates, états, identifiants).

Échoue si une donnée paraît réelle, si une contrainte serait violée, ou si une requête ne renverrait aucune ligne.
