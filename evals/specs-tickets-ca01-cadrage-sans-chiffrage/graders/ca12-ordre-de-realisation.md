---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA12. La section « Ordre de réalisation » :

- liste tous les tickets de la section « Tickets », chacun une seule fois, et aucun ticket inexistant ;
- place chaque ticket après tous ceux dont il dépend, d'après la rubrique « Dépendances » des tickets ;
- contient un schéma Mermaid dont les arêtes correspondent aux dépendances déclarées dans les tickets (aucune arête inventée, aucune dépendance omise).

Échoue si l'un de ces points est faux.
