---
type: llm
focus: { source: file, path: "docs/wf/recette.md" }
---

CA9 : à la relance, chaque cas dont la source existe toujours conserve son ID,
et les nouveaux cas reçoivent des ID jamais utilisés auparavant.

Le cahier précédent comptait REC-001 à REC-011 dans le tableau, avec cette
correspondance : REC-001 à REC-006 pour `docs/specs/001-interventions.md#CA1`
à `#CA6`, REC-007 pour `002-ordres-de-travail.md#CA1`, REC-008 pour `#CA3`,
REC-009 pour `#CA5`. REC-012 avait déjà été retiré, et la ligne « Dernier
identifiant attribué » valait REC-012.

Réussite si : REC-001 à REC-009 sont toujours dans le tableau, chacun avec la
même source qu'avant ; tout cas dont la source n'avait pas de cas auparavant
(`002-ordres-de-travail.md#CA2`, `#CA4`, critères de `003-export-pdf.md`,
éventuels cas tirés du code) porte un identifiant supérieur ou égal à REC-013 ;
aucun identifiant n'est attribué deux fois. Échec sinon.
