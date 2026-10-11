---
type: llm
focus: { source: file, path: "docs/wf/cadrage-besoin.md" }
---

004-CA11. Dans la section « Questions au client » du livrable :

- chaque question porte un identifiant de la forme `Qnn` (`Q01`, `Q02`…), et aucun identifiant n'est utilisé deux fois ;
- chaque question qui porte sur un besoin de « Besoins fonctionnels » indique l'identifiant `Bnn` de ce besoin, et cet identifiant existe ;
- chaque question a un champ « Réponse : » vide (rien après les deux-points), puisque c'est une première exécution.

Échoue si une question n'a pas d'identifiant ou de champ « Réponse : », si un champ « Réponse : » est déjà rempli, si une question sur un besoin n'indique pas son `Bnn`, ou si un identifiant est en double.
