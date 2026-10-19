---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdo-fieldops.md" }
pattern: '^#{2,3} +Actions *\n+\| *Action *\| *Responsable *\| *Échéance *\| *\n\|[ :|-]+\n\|'
flags: m
match: contains
---

007-CA7 : la section « Actions » commence par un tableau à trois colonnes, Action, Responsable, Échéance, dans cet ordre, avec au moins une ligne.
