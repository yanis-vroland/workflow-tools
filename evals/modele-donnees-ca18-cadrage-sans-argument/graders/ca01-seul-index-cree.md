---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/modele-donnees/index\.md$).+$'
flags: m
match: not_contains
---

017-CA1 : aucun fichier autre que `docs/wf/modele-donnees/index.md` n'est créé ni modifié ; en particulier `docs/wf/cadrage-besoin.md`, livrable d'un autre outil, reste intact.
