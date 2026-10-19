---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA11. Questions du cadrage :

- sans réponse et liées à un besoin : Q01 (B01, B06), Q02 (B01), Q04 (B03), Q06 (B05) ;
- sans réponse et sans besoin : Q05 (hébergement) ;
- avec réponse : Q03 (B03) et Q07 (B04).

Pour chaque ticket, la rubrique « Points à clarifier » :

- cite chaque question sans réponse qui porte sur un besoin couvert par ce ticket (ex. un ticket couvrant B01 cite Q01 et Q02 ; un ticket couvrant B03 cite Q04 ; un ticket couvrant B05 cite Q06 ; un ticket couvrant B06 cite Q01) ;
- ne cite ni Q03 ni Q07, dont la réponse est remplie ;
- indique « aucun » quand aucune question sans réponse ne porte sur les besoins du ticket (ex. un ticket qui ne couvre que B02, B04 ou B07).

Échoue si une seule rubrique déroge à ces règles.
