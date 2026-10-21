---
type: llm
focus: trace
---

007-CA10. Le projet contient du code (`src/`, `mobile/`), des manifestes (`package.json`, `pubspec.yaml`), un `README.md` et des specs internes (`docs/specs/`).

Vérifie dans la trace qu'aucune commande Bash ne lit ni ne recherche le contenu d'un de ces fichiers (`cat`, `head`, `tail`, `less`, `grep`, `rg`, `sed -n`, `awk`…). Lister et lire les comptes rendus de `docs/wf/compte-rendu/` est permis, de même que lire les notes `../reunions/notes-reunion.md`, et que `git rev-parse`, `git status`, `date`, `mkdir -p` et le calcul du nom de fichier par `python3 -c`.

Échoue si une commande lit ou recherche le contenu d'un fichier du code ou de la documentation du projet.
