---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '`[^`\n]*(?:pip install -r|poetry |pipenv|uvicorn|flask run|manage\.py)|```[^`]*(?:pip install -r|poetry |pipenv|uvicorn|flask run|manage\.py)'
flags: "i"
match: not_contains
---

CA18 : aucune commande propre à un outillage Python absent du projet n'est inventée.
