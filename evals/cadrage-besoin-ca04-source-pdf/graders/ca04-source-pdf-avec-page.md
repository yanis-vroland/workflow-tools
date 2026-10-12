---
type: llm
focus: { source: file, path: "docs/wf/cadrage-besoin.md" }
---

004-CA4 (source d'un PDF : nom du fichier et numéro de page). La source est `cahier-des-charges.pdf`, de deux pages : la planification des interventions et le suivi de l'état sont en page 1, l'export mensuel CSV pour la direction en page 2.

Dans « Besoins fonctionnels » :

- chaque besoin a un identifiant `Bnn` unique, un libellé, une priorité et une source ;
- la planification et le suivi de l'état citent `cahier-des-charges.pdf` avec la page 1 ;
- l'export CSV cite `cahier-des-charges.pdf` avec la page 2.

Échoue si un numéro de page manque ou est faux, ou si un besoin n'a pas d'identifiant, de priorité ou de source.
