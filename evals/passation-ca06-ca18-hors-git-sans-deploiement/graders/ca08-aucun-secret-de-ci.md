---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: 'REGISTRY_TOKEN|DEPLOY_TOKEN'
match: not_contains
---

CA8 : aucun secret de CI n'est inventé (le workflow a été retiré).
