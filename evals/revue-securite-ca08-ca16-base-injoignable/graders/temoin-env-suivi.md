---
type: regex
target: { source: file, path: ".env.staging" }
pattern: 'FIELDOPS_FAUX_SECRET_STAGING_5d1c'
match: contains
---

Témoin : le scaffold a bien créé `.env.staging` avec son marqueur.
