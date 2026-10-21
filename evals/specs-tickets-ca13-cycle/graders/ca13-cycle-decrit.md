---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA13. Le cadrage impose que l'import des équipements (B01) soit livré après l'import des contrats (B02), et l'import des contrats après celui des équipements : les tickets qui réalisent B01 et B02 dépendent l'un de l'autre. La consultation (B03) dépend des deux.

- Les rubriques « Dépendances » des tickets reprennent ces contraintes : le ticket de B01 dépend de celui de B02 et inversement (le livrable ne fusionne pas les deux besoins dans un même ticket ni n'invente un découpage pour faire disparaître le cycle).
- « Points non déterminés » décrit le cycle en citant les identifiants `Tnn` des tickets concernés.
- « Ordre de réalisation » indique qu'aucun ordre ne peut être proposé à cause de ce cycle (en renvoyant au cycle), au lieu de proposer un ordre complet des tickets ; il peut contenir le schéma Mermaid des dépendances, cycle compris.

Échoue si l'un de ces points est faux.
