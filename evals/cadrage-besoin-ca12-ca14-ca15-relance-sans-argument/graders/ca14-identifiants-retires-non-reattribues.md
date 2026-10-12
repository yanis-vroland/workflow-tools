---
type: llm
focus: { source: file, path: "docs/wf/cadrage-besoin.md" }
---

004-CA14 (identifiants retirés jamais réattribués). Dans le livrable précédent, les identifiants B03 et Q02 n'étaient plus utilisés : ils avaient été retirés.

- Aucun besoin du nouveau livrable ne porte l'identifiant B03, et aucune question ne porte l'identifiant Q02 (une simple mention indiquant qu'ils sont retirés est permise).
- Tout besoin absent du livrable précédent (ex. historique par client et par équipement, photos avant et après intervention) reçoit un identifiant supérieur à B05 (B06, B07…).
- Toute question absente du livrable précédent reçoit un identifiant supérieur à Q05 (Q06, Q07…).
- Le nouveau livrable contient au moins un besoin absent du livrable précédent : l'historique des interventions par client et par équipement, demandé dans `brief-fieldops.md` (« Fonctionnalités souhaitées »), relu à la relance.

Échoue si aucun nouveau besoin n'apparaît, si B03 ou Q02 est réattribué, ou si un nouvel élément reçoit un identifiant déjà utilisé ou comblant un trou.
