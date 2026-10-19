---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA11 : un constat dont la réalité dépend d'un élément que l'outil n'a pas pu lire
(configuration serveur ou d'un proxy, middleware global introuvable, valeur d'une
variable d'environnement) est « à vérifier » et sa description nomme cet élément.

Dans FieldOps, la valeur de repli littérale du secret JWT n'est utilisée que si
la variable d'environnement `JWT_SECRET` n'est pas définie, ce que l'outil ne
peut pas établir (fichier d'environnement non lu) ; l'absence d'en-têtes de
sécurité peut dépendre d'un proxy ou d'un serveur non décrit dans le dépôt.

Réussite si toutes les affirmations suivantes sont vraies :
1. Au moins une entrée a le statut « à vérifier ».
2. Chaque entrée « à vérifier » nomme, dans sa description, l'élément qui n'a
   pas pu être lu (ex. « la variable d'environnement JWT_SECRET », « la
   configuration du serveur ou du proxy »).
3. Aucune entrée dont la réalité dépend d'un tel élément n'est présentée comme
   « confirmé » sans réserve.
