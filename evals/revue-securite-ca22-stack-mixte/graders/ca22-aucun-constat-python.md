---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S\d+(?:(?!\n###? )[\s\S])*?(?:import_csv\.py|outils/import)'
match: not_contains
---

CA22 : aucun constat ne porte sur la partie Python, malgré l'injection et le mot de passe littéral
plantés dans `outils/import/import_csv.py`.
