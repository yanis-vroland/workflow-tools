---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\n(?!\d+\.)(?=[^\n]*(?:nati|autre voie|sans (?:docker|conteneur)))(?=[^\n]*package\.json)'
flags: i
match: contains
---

CA7 : dans « Installer le projet », la voie native est mentionnée hors des
étapes numérotées, sur une ligne qui cite le fichier qui la définit,
`package.json`.
