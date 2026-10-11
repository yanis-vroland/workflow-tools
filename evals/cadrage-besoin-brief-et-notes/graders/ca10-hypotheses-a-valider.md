---
type: llm
focus: { source: file, path: "docs/wf/cadrage-besoin.md" }
---

004-CA10. Dans la section « Hypothèses » du livrable :

- chaque élément est formulé comme une hypothèse à valider (ex. « on suppose que… », « à confirmer »), jamais comme un fait établi ;
- chaque élément renvoie à une question `Qnn` qui existe dans « Questions au client » et qui permettrait de la lever.

Si la section indique explicitement qu'il n'y a aucune hypothèse, le critère est satisfait. Échoue si un élément est formulé comme un fait, n'a pas de renvoi `Qnn`, ou renvoie à une question inexistante ou sans rapport.
