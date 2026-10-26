---
type: regex
target: last_message
pattern: 'aucun livrable|pas de livrable|n.a (?:pas )?été (?:écrit|créé|produit)|aucun fichier (?:n.a été )?(?:écrit|créé)'
flags: i
match: contains
---

CA9, témoin positif : le dernier message dit qu'aucun livrable n'a été écrit. Sans lui, les correcteurs d'absence de livrable réussiraient même si l'outil n'avait pas tourné.
