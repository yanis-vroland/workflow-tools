---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA21. PASS si « Synthèse » donne toutes ces informations :
1. le nombre de dépendances par écart : majeur, mineur, correctif, à jour (un nombre « non déterminé » est accepté s'il est justifié) ;
2. le nombre d'étapes du plan, cohérent avec « Plan de montée » ;
3. un effort qualitatif global, exactement « faible », « moyen » ou « élevé », justifié par le nombre de ruptures et de fichiers impactés.

FAIL si l'un manque, si l'effort est chiffré en jours, semaines ou heures, ou si le nombre d'étapes annoncé diffère du plan.
