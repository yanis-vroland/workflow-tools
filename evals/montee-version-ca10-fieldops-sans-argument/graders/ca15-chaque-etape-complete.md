---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n### [ÉE]tape \d+\b[^\n]*\n(?!(?=(?:(?!\n### |\n## )[\s\S])*?\n[ \t]*-[ \t]*Paquets\s*:[^\n]*→)(?=(?:(?!\n### |\n## )[\s\S])*?\n[ \t]*-[ \t]*Commandes?\s*:)(?=(?:(?!\n### |\n## )[\s\S])*?\n[ \t]*-[ \t]*Ruptures à traiter\s*:)(?=(?:(?!\n### |\n## )[\s\S])*?\n[ \t]*-[ \t]*Vérification[^\n]*:))'
match: not_contains
---

CA15 : chaque étape numérotée (`### Étape N`) comporte les paquets avec version de départ et version visée (`→`), les commandes, les ruptures à traiter et la vérification avant l'étape suivante. Remplace le juge `llm` ca15-etapes-completes, bruité sur ce livrable long (PASS FAIL FAIL) ; ca15-commande-npm et ca15-commande-flutter-pub vérifient les commandes elles-mêmes.
