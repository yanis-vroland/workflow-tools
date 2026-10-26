# Chiffrage : outil de gestion des interventions

- Outil : wf-chiffrage
- Date : 2026-10-01
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Fichier d'entrée : cadrage-besoin.md (en-tête daté du 2026-09-30)
- Dernier identifiant attribué : C10

## Synthèse

Chiffrage d'un outil de planification et de suivi des interventions, avec saisie mobile des comptes rendus. Développement à partir de zéro.

- Total bas : 15,5 j
- Total haut : 25 j

## Périmètre chiffré

- B01 : Planification des interventions par les dispatchers, avec affectation à un technicien selon sa zone et ses compétences (source : cadrage-besoin.md) : C01, C02.
- B02 : Suivi de l'état de chaque intervention (planifiée, en cours, terminée) (source : cadrage-besoin.md) : C03.
- B03 : Saisie du compte rendu sur mobile et envoi au client par e-mail (source : cadrage-besoin.md) : C04.
- B04 : Historique des interventions par client et par équipement (source : cadrage-besoin.md) : C05.
- B05 : Tableau de bord mensuel pour la direction (source : cadrage-besoin.md) : C06.

## Détail par lot

### Lot 1 : Planification

| Identifiant | Tâche | Besoins couverts | Estimation basse (j) | Estimation haute (j) | Commentaire |
|---|---|---|---|---|---|
| C01 | Écran de planning des dispatchers | B01 | 2 | 3 | Vue par technicien et par jour. |
| C02 | Règles d'affectation par zone et compétences | B01 | 1,5 | 3 | Incertitude sur le volume à traiter (voir Q01, hypothèse H1). |
| C03 | Suivi de l'état des interventions | B02 | 1 | 1,5 | Trois états fixés par le cadrage. |

### Lot 2 : Comptes rendus

| Identifiant | Tâche | Besoins couverts | Estimation basse (j) | Estimation haute (j) | Commentaire |
|---|---|---|---|---|---|
| C04 | Saisie mobile du compte rendu et envoi au client | B03 | 3 | 5 | Hors connexion à confirmer. |

### Lot 3 : Historique et pilotage

| Identifiant | Tâche | Besoins couverts | Estimation basse (j) | Estimation haute (j) | Commentaire |
|---|---|---|---|---|---|
| C05 | Historique par client et par équipement | B04 | 2 | 3 | Sans reprise du tableur (hypothèse H2). |
| C06 | Tableau de bord mensuel | B05 | 1,5 | 2,5 | Indicateurs à préciser. |

## Activités transverses

| Identifiant | Tâche | Besoins couverts | Estimation basse (j) | Estimation haute (j) | Commentaire |
|---|---|---|---|---|---|
| C07 | Gestion de projet | aucun | 2 | 3 | Projet à cinq lots (Synthèse du cadrage). |
| C08 | Recette | aucun | 1,5 | 2,5 | Recette des besoins B01 à B05. |
| C09 | Déploiement | aucun | 1 | 1,5 | Données hébergées en France (Contraintes du cadrage). |

- Total bas : 15,5 j
- Total haut : 25 j

## Hypothèses

- H1 : le volume reste de quelques centaines d'interventions par mois (Q01 sans réponse) ; tâches concernées : C02.
- H2 : l'historique du tableur n'est pas repris ; tâches concernées : C05.
- Développement à partir de zéro : le projet ne contient pas de code source.

## Exclusions

- Facturation : hors périmètre du cadrage.

## Risques

- Volume d'interventions inconnu (Q01) : tâches affectées : C02 ; effet inclus dans l'estimation haute : oui.

## Points non déterminés

- Aucun.
