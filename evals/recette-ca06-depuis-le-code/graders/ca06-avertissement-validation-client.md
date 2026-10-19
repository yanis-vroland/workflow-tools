---
type: llm
focus: { source: file, path: "docs/wf/recette.md" }
---

CA6 : sans spec, les cas sont déduits du code.

Réussite si « Périmètre et sources » avertit explicitement (1) que les
résultats attendus décrivent le comportement actuel du code, et non un
comportement spécifié, et (2) qu'ils doivent être validés par le client avant
la recette. Échec si l'un des deux points manque, ou si l'avertissement est
ailleurs que dans « Périmètre et sources ».
