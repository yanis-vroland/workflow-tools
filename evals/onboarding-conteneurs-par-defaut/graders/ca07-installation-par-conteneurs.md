---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\n\d+\.[^\n]*docker compose build'
match: contains
---

CA7 : le README ne décrit aucune voie, la voie principale est celle par
conteneurs : « Installer le projet » a une étape numérotée `docker compose build`
(`docker-compose.yml`).
