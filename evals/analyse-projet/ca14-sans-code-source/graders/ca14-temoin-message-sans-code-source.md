---
type: regex
target: last_message
pattern: '^(?=[\s\S]*(?:(?:aucun|pas de|sans) (?:code|fichier) source|ne contient (?:pas de|aucun) code))(?=[\s\S]*(?:aucun livrable|aucune analyse|aucun diagnostic|aucun fichier (?:n.a été )?(?:écrit|créé)|pas (?:de |d.)(?:livrable|analyse|diagnostic)|n.a (?:pas )?été (?:produit|écrit|créé|généré)e?|n.ai (?:pas|rien) (?:produit|écrit|créé|généré)|non (?:produit|écrit|généré)e?))'
flags: i
match: contains
---

CA14, témoin positif : le message final indique que le répertoire ne contient pas de code source ET que l'analyse n'a pas été produite. Sans ce témoin, les correcteurs d'absence de livrable réussiraient même si l'outil n'avait pas tourné.
