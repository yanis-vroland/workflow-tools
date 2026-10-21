---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md" }
pattern: 'modifications non commitées|hors git'
match: not_contains
---

007-CA6 et CA19 : l'arbre de travail est propre au lancement (les comptes rendus existants sont exclus de git) et le projet est un dépôt git : ni « modifications non commitées », ni « hors git ».
