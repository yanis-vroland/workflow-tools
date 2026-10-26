---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Preuve par les cas d.usage *$(?=(?:(?!^## )[\s\S])*?planning)(?=(?:(?!^## )[\s\S])*?(état|statut))(?=(?:(?!^## )[\s\S])*?historique)(?=(?:(?!^## )[\s\S])*?compte rendu)(?=(?:(?!^## )[\s\S])*?tableau de bord)(?=(?:(?!^## )[\s\S])*?photo)'
flags: mi
match: contains
---

017-CA23 : « Preuve par les cas d'usage » reprend les besoins des sources : planning et affectation, suivi de l'état, historique, compte rendu, tableau de bord, photos.
