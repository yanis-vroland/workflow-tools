---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: 'REGISTRY_TOKEN|DEPLOY_TOKEN|PRODUCTION_DATABASE_URL'
match: not_contains
---

CA8 : aucun secret de CI n'est inventé (les workflows `deploy.yml` et `purge.yml` ont été retirés).
