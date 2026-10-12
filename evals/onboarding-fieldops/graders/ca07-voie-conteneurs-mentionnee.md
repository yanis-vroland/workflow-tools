---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?docker-compose\.yml'
match: contains
---

CA7 : dans « Installer le projet », l'autre voie (conteneurs) est mentionnée avec le fichier qui la définit, `docker-compose.yml`.
