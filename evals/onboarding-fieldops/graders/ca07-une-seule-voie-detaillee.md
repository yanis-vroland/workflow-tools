---
type: llm
focus: { source: file, path: "docs/wf/onboarding.md" }
---

CA7 : FieldOps propose une installation native (décrite par `README.md`) et une
installation par conteneurs (`docker-compose.yml`, mentionnée en une ligne par
le README).

Réussite si toutes les affirmations suivantes sont vraies :
1. Les étapes numérotées de « Installer le projet » et « Lancer le projet » pour
   l'application web suivent la voie native (`npm install`, scripts de
   `package.json`).
2. La voie par conteneurs (`docker compose up`) n'est pas déroulée en étapes :
   elle est mentionnée en une seule ligne, avec le fichier `docker-compose.yml`.
