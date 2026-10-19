---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA15. Le projet web utilise npm (`package-lock.json`) et l'application Flutter pub (`mobile/pubspec.lock`).

PASS si chaque étape de « Plan de montée » est numérotée et comporte toutes ces informations :
1. les paquets concernés, chacun avec sa version de départ et sa version visée ;
2. les commandes du gestionnaire détecté : `npm install <paquet>@<version>` pour l'application web, `flutter pub add` ou `flutter pub upgrade` pour l'application Flutter (une étape d'environnement, Node.js ou Flutter, peut à la place indiquer les fichiers de version à modifier) ;
3. les identifiants des ruptures à traiter (R1…), ou l'indication qu'il n'y en a aucune ;
4. la vérification à faire avant de passer à l'étape suivante.

FAIL si une étape omet l'un de ces éléments ou utilise un gestionnaire non détecté (pnpm, yarn).
