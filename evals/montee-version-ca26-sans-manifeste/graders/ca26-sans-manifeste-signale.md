---
type: regex
target: last_message
pattern: '^(?=[\s\S]*(?:aucun|pas de|sans) manifeste)(?=[\s\S]*(?:aucun livrable|pas de livrable|n.a (?:pas )?été (?:écrit|créé|produit)))'
flags: i
match: contains
---

CA26, témoin positif : le dernier message indique qu'aucun manifeste de dépendances n'a été trouvé et qu'aucun livrable n'a été écrit. Sans lui, les correcteurs d'absence de livrable réussiraient même si l'outil n'avait pas tourné.
