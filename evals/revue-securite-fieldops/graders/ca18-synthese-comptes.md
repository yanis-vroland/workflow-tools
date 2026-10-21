---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA18 : dans la section « Synthèse » du livrable, comparée au reste du livrable.

Réussite si toutes les affirmations suivantes sont vraies :
1. La synthèse donne le nombre de constats par niveau (élevé, moyen, faible).
2. Elle donne le nombre de dépendances vulnérables par sévérité publiée.
3. Elle liste les identifiants `Sn` des constats de niveau élevé et des
   dépendances de sévérité critique ou élevée.
4. Ces nombres et cette liste sont cohérents avec les entrées des sections
   « Dépendances vulnérables », « Constats dans le code » et « Secrets et
   configuration ».
5. La synthèse n'affirme pas que le projet est sûr.
