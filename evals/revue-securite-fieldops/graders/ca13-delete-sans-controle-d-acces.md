---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?contr[ôo]le d.acc[èe]s)(?=(?:(?!\n###? )[\s\S])*?\bDELETE\b)(?=(?:(?!\n###? )[\s\S])*?routes/interventions\.ts)'
flags: 'i'
match: contains
---

CA13 : la route `DELETE` des interventions, sans contrôle d'authentification, donne un constat de
catégorie « contrôle d'accès » qui cite la méthode HTTP et le fichier.
