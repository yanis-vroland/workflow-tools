---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA7 : le projet n'a pas de lockfile (`package-lock.json` retiré).

Réussite si toutes les affirmations suivantes sont vraies :
1. Les dépendances citées dans « Dépendances vulnérables » sont toutes déclarées
   dans `package.json` ; aucune n'est marquée transitive.
2. La version de chaque entrée est présentée comme tirée de la contrainte
   déclarée (ex. `^4.18.2`), pas comme une version installée établie.
3. « Points non déterminés » indique que les versions installées et les
   dépendances transitives n'ont pas pu être établies, faute de lockfile.
