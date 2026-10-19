---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA4. Dans la section « Tickets » :

- chaque ticket est une sous-section dont le titre est `Tnn : <titre>`, avec des identifiants sur deux chiffres (`T01`, `T02`…), uniques ;
- chaque ticket contient, dans cet ordre et sous ces noms exacts, les neuf rubriques : Récit utilisateur, Contexte, Critères d'acceptation, Hors périmètre, Dépendances, Besoins couverts, Estimation, Fichiers concernés, Points à clarifier ;
- la rubrique « Récit utilisateur » est une phrase de la forme « En tant que …, je veux …, afin de … ».

Échoue si un seul ticket déroge à l'un de ces points.
