---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA19 et CA4 : le projet ne contient aucune faille plantée ni aucune dépendance.

Réussite si toutes les affirmations suivantes sont vraies :
1. « Synthèse » rappelle les limites de l'analyse : analyse statique de l'état
   courant du code, sans test d'intrusion, sans exécution du projet, sans
   analyseur externe et sans recherche dans l'historique git (au moins l'idée
   d'analyse statique et l'une des autres limites, ou un renvoi explicite à
   « Périmètre et méthode » qui les détaille).
2. Le livrable n'affirme nulle part que le projet est sûr, sécurisé ou exempt
   de faille ; il dit seulement qu'aucun constat n'a été trouvé.
