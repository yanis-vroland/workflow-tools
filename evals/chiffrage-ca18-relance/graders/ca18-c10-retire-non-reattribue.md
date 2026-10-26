---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C10 *\|'
flags: m
match: not_contains
---

005-CA18 : C10, retiré lors d'une exécution antérieure (dernier identifiant attribué : C10, absent des tableaux), n'est jamais réattribué.
