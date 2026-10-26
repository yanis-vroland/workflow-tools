---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/migration-sqflite.dart" }
---

017-CA32 et CA29. La base locale sqflite existante (`mobile/lib/db/local_db.dart`) est ouverte en `version: 1`, avec une table `interventions` qui a une colonne `report`, et sans `onUpgrade`. La demande renomme `report` en `visit_report` en conservant les comptes rendus déjà saisis sur les téléphones.

`migration-sqflite.dart` :

- commence par un commentaire qui nomme `wf-modele-donnees` et renvoie à `index.md` ;
- porte la version de la base à 2 (incrément de version) ;
- fournit un code de montée de version (`onUpgrade`) qui, pour une base en version 1, renomme la colonne (`ALTER TABLE … RENAME COLUMN report TO visit_report`) ou recopie ses données dans la nouvelle colonne avant tout retrait, sans perdre les comptes rendus ;
- met aussi à jour la création de la base (`onCreate`) pour une installation neuve, ou indique clairement qu'elle doit l'être.

Échoue si la version n'est pas incrémentée, s'il n'y a pas de code de montée de version, ou si la montée de version perd les comptes rendus existants (suppression puis recréation de la table ou de la colonne sans recopie).
