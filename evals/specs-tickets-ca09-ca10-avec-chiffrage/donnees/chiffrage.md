# Chiffrage : outil de gestion des interventions

- Outil : wf-chiffrage
- Date : 2026-10-15
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Fichier d'entrée : cadrage-besoin.md (daté du 2026-10-14)

## Synthèse

Développement à partir de zéro d'un back-office web pour les dispatchers et d'une application mobile Android hors connexion pour les techniciens. Total : 27 à 40,5 jours.

## Périmètre chiffré

- B01 à B07 du cadrage, tous chiffrés.

## Détail par lot

### Lot 1 : planning

| Identifiant | Tâche | Besoins couverts | Estimation basse | Estimation haute | Commentaire |
|---|---|---|---|---|---|
| C01 | Écran de planning des dispatchers (vue par technicien et par jour) | B01 | 2 | 3 | Volume à confirmer (Q01). |
| C02 | Affectation d'un technicien selon sa zone et ses compétences | B01 | 2 | 4 | Règles d'affectation à préciser avec les dispatchers ; incertitude liée à l'hypothèse H2. |
| C03 | Suivi de l'état d'une intervention (planifiée, en cours, terminée) | B02 | 1 | 1,5 | |

### Lot 2 : application mobile

| Identifiant | Tâche | Besoins couverts | Estimation basse | Estimation haute | Commentaire |
|---|---|---|---|---|---|
| C04 | Application Android : liste des interventions du jour et saisie du compte rendu | B03 | 4 | 5 | |
| C05 | Fonctionnement hors connexion et synchronisation des comptes rendus | B03 | 3 | 5 | Gestion des conflits de synchronisation non cadrée (risque R1). |
| C06 | Prise de photos avant et après intervention, envoi avec le compte rendu | B07 | 1 | 2 | Taille et nombre de photos non précisés (risque R2). |

### Lot 3 : suivi client et pilotage

| Identifiant | Tâche | Besoins couverts | Estimation basse | Estimation haute | Commentaire |
|---|---|---|---|---|---|
| C07 | Envoi automatique du compte rendu au client par e-mail | B04 | 1 | 1,5 | Contenu fixé par la réponse à Q07. |
| C08 | Historique des interventions par client et par équipement | B05 | 2 | 3 | Sans reprise de l'historique du tableur (hypothèse H3). |
| C09 | Tableau de bord mensuel de la direction | B06 | 2 | 3 | |

## Activités transverses

| Identifiant | Tâche | Besoins couverts | Estimation basse | Estimation haute | Commentaire |
|---|---|---|---|---|---|
| C10 | Gestion de projet | | 3 | 4,5 | Deux applications à coordonner (contrainte « Application mobile Android… navigateur sur PC », réponse à Q03). |
| C11 | Recette | | 2 | 3 | Deux applications à recetter (réponse à Q03). |
| C12 | Publication de l'application sur le Google Play Store | B03 | 1 | 1,5 | Application mobile Android demandée (réponse à Q03). |
| C13 | Déploiement du back-office et de l'API | | 3 | 3,5 | Hébergement en France (contrainte « Les données restent en France ») ; hébergeur non déterminé (Q05). |

Total : 27 jours (bas) à 40,5 jours (haut).

## Hypothèses

- H1 : développement à partir de zéro, aucun code existant.
- H2 : Q01 sans réponse : on suppose au plus 1 500 interventions par mois (C01, C02).
- H3 : Q06 sans réponse : l'historique du tableur n'est pas repris (C08).
- Q03 : réponse prise en compte comme un fait (application Android pour les techniciens).

## Exclusions

- Facturation : hors périmètre du cadrage.

## Risques

- R1 : conflits de synchronisation hors connexion. Tâches affectées : C05. Effet inclus dans l'estimation haute.
- R2 : volume de photos à transférer. Tâches affectées : C06. Effet non inclus dans l'estimation haute.

## Points non déterminés

- Hébergeur : non déterminé (Q05).
