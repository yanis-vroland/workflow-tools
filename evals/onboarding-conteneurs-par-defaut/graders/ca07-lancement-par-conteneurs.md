---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Lancer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\n\d+\.[^\n]*docker compose up'
match: contains
---

CA7 : « Lancer le projet » suit la voie par conteneurs, avec une étape numérotée
`docker compose up` (`docker-compose.yml`).
