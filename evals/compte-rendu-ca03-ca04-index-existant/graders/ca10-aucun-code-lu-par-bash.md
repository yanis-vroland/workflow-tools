---
type: llm
focus: trace
---

007-CA10. Le projet contient du code (`src/`, `mobile/`), des manifestes (`package.json`, `pubspec.yaml`), un `README.md` et des specs internes (`docs/specs/`).

Vérifie dans la trace qu'aucune commande Bash ne lit ni ne recherche le contenu d'un de ces fichiers (`cat`, `head`, `tail`, `less`, `grep`, `rg`, `sed -n`, `awk`…). Lister le contenu de `docs/wf/compte-rendu/` est permis, de même que `git rev-parse`, `git status` et `date`.

Échoue si une commande lit ou recherche le contenu d'un fichier du code ou de la documentation du projet.
