---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA15. PASS si chaque étape de « Plan de montée » est numérotée et comporte : les paquets concernés avec leur version de départ (17.0.2) et leur version visée (19.x) ; la commande `npm install <paquet>@<version>` ; les identifiants des ruptures à traiter (R1…) ; la vérification à faire avant l'étape suivante. FAIL si un de ces éléments manque.
