---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA11 (identifiants retirés jamais réattribués). L'en-tête du livrable précédent indiquait « Derniers identifiants attribués : E06, RG06, Q05, D02 », et les identifiants E03, E06, RG03, RG06, Q02 et D02 n'y étaient plus utilisés : ils avaient été retirés.

- Aucune entité du nouveau livrable ne porte E03 ou E06, aucune règle RG03 ou RG06, aucune question Q02, aucun encadré D02 (une mention qui indique qu'ils sont retirés est permise).
- Toute entité absente du livrable précédent (ex. le site, issu de la réponse à Q01) reçoit un identifiant supérieur à E06 (E07, E08…) ; toute nouvelle règle un identifiant supérieur à RG06 ; toute nouvelle question un identifiant supérieur à Q05 ; tout nouvel encadré un identifiant supérieur à D02.
- Le nouveau livrable contient au moins une entité nouvelle (le site, ou adresse d'intervention).

Échoue si aucune entité nouvelle n'apparaît, si un identifiant retiré est réattribué, ou si un nouvel élément reçoit un identifiant déjà utilisé ou comblant un trou.
