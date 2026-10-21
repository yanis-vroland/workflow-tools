---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Synth[èe]se[^\n]*\n(?:(?!\n## )[\s\S])*?\bS\d+\b'
match: contains
---

CA18 : « Synthèse » liste des identifiants `Sn` (constats élevés et dépendances de sévérité
critique ou élevée).
