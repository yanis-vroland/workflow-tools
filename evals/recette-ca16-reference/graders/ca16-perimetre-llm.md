---
type: llm
focus: { source: file, path: "docs/wf/recette.md" }
---

CA16 : campagne limitée aux changements depuis la référence v1.3.0.

Depuis v1.3.0, seuls ont changé : la spec `docs/specs/002-ordres-de-travail.md`
(ajout de CA6) et, dans `docs/wf/specs-tickets.md`, la sous-section du ticket
T02 (ajout de CA3). Les tickets T01 et T03, les specs 001 et 003 et le code
n'ont pas changé.

Réussite si : le tableau ne contient que des cas dont la source est un critère
de la spec 002 ou du ticket T02 ; chaque critère de ces deux sources est
couvert par un cas ou listé comme non recettable manuellement ; « Périmètre et
sources » indique que la campagne est limitée aux changements depuis v1.3.0.
Échec si un cas a pour source la spec 001 ou 003, le ticket T01 ou T03, ou du
code, ou si la limitation à la référence n'est pas indiquée.
