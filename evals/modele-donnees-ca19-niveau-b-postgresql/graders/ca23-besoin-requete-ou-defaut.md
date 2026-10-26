---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Preuve par les cas d.usage *$(?:(?!^## )[\s\S])*?^[-*] +(?![^\n]*(`?R\d\d`?|défaut du schéma))[^\n]*$'
flags: mi
match: not_contains
---

017-CA23 : chaque besoin de « Preuve par les cas d'usage » a sa requête `Rnn`, ou est signalé comme défaut du schéma.
