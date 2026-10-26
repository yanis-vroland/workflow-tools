---
type: regex
target: files
pattern: '^(?!\.git/).+$'
flags: "m"
match: not_contains
---

CA22 : aucun fichier n'est créé, ni sous docs/ ni ailleurs (hors fichiers internes de git).
