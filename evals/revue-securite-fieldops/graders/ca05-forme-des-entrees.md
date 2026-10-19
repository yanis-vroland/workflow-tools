---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA5 et CA10 : dans la section « Dépendances vulnérables ».

Réussite si toutes les affirmations suivantes sont vraies :
1. Chaque dépendance vulnérable citée porte : un identifiant `Sn`, son nom, son
   écosystème (npm ou pub), sa version installée, l'identifiant d'un avis (CVE,
   GHSA ou OSV), une sévérité publiée (ex. « HIGH », « MODERATE », un vecteur
   CVSS, ou une mention explicite qu'aucune sévérité n'est publiée) et la
   première version corrigée, ou « aucune correction publiée ».
2. La sévérité est reprise telle que publiée : elle n'est pas remplacée par la
   grille élevé, moyen, faible des constats du code.
3. Les versions installées sont celles du lockfile (ex. express 4.18.2), pas
   une version supposée.
