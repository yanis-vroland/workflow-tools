---
type: llm
focus: { source: file, path: "docs/wf/analyse-projet.md" }
---

Lis uniquement la section « Dette et risques » de ce livrable.
PASS si chaque risque listé dans cette section porte un niveau parmi exactement « élevé », « moyen » ou « faible », ET cite au moins un chemin de fichier du projet.
FAIL si un seul risque n'a pas de niveau, utilise un autre niveau (critique, majeur, bas…), ou ne cite aucun fichier, ou si la section est absente ou vide.
