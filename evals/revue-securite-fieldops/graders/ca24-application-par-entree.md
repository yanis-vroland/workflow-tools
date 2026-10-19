---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA24 : FieldOps est un monorepo (API et back-office web JS/TS à la racine,
application compagnon Flutter dans `mobile/`).

Réussite si chaque entrée identifiée `Sn` du livrable (lignes du tableau
« Dépendances vulnérables », entrées de « Constats dans le code » et de
« Secrets et configuration ») indique l'application concernée (web ou mobile),
et si « Périmètre et méthode » liste les deux applications avec le référentiel
appliqué à chacune (OWASP Top 10 pour le web, OWASP Mobile Top 10 pour Flutter).
