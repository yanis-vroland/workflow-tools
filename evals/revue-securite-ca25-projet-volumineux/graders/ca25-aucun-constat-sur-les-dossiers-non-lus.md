---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S\d+(?:(?!\n###? )[\s\S])*?src/legacy'
match: not_contains
---

CA25 : aucun constat ne porte sur un fichier de `src/legacy/`, dossier non lu (l'injection et le
jeton littéral plantés dans `src/legacy/sync/module_250.ts` ne doivent pas être rapportés).
