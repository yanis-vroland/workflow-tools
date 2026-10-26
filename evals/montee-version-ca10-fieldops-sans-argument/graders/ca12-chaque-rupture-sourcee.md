---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n### R\d+\b[^\n]*\n(?!(?:(?!\n### |\n## )[\s\S])*?\n[ \t]*-[ \t]*Source\s*:[^\n]*(?:https?://|non vérifiée))'
match: not_contains
---

CA12 : chaque rupture (`### Rn`) a une ligne « Source : » qui cite une URL (note de version, changelog, guide de migration) ou porte la mention « non vérifiée ». Une source qui n'est ni l'une ni l'autre (par exemple « métadonnées du registre ») échoue. Remplace le juge `llm` ca12-ruptures-identifiees-et-sourcees, bruité sur ce livrable long (16 000 caractères).
