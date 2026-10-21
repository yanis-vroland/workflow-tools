---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-006\s*\|[^\n]*001-interventions\.md#CA1\b[^\n]*\|\s*conforme\s*\|\s*Validé en démo du 10/09\s*\|'
match: contains
---

CA9 : REC-006, listé hors campagne dans le cahier précédent, revient au tableau
(la spec 001 a changé depuis v1.3.0) avec son ID, son statut « conforme » et
son commentaire, mot pour mot. Le cahier déposé ne l'a pas dans son tableau :
ce correcteur échoue tant que la skill ne l'a pas réintégré.
