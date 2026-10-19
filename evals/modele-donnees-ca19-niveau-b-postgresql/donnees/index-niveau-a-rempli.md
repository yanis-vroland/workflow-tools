# Modèle de données : outil de gestion des interventions

- Outil : wf-modele-donnees
- Date : 2026-10-08
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Niveau atteint : A (modèle conceptuel)
- Sources lues : brief-fieldops.md, notes-appel.md
- Derniers identifiants attribués : E07, RG07, Q05, D01
- Exécution : aucune ; les fichiers produits n'ont pas été exécutés.

## Synthèse

Modèle conceptuel des interventions de maintenance : clients et leurs sites, équipements, techniciens et interventions. Toutes les questions bloquantes et toutes les décisions sont remplies : le niveau B peut être produit.

## Modèle conceptuel

```mermaid
erDiagram
    CLIENT ||--|{ SITE : possede
    SITE ||--o{ EQUIPEMENT : accueille
    SITE ||--o{ INTERVENTION : accueille
    EQUIPEMENT ||--o{ INTERVENTION : concerne
    TECHNICIEN }o--o{ INTERVENTION : realise
```

### Entités

- E01 Client : société ou particulier chez qui ont lieu les interventions. Source : « Historique des interventions par client et par équipement » (brief-fieldops.md, « Fonctionnalités souhaitées »).
- E02 Technicien : salarié qui réalise les interventions. Source : « Nous employons 40 techniciens répartis sur deux agences » (brief-fieldops.md, « Contexte »).
- E04 Intervention : visite d'un ou plusieurs techniciens sur un site. Source : « Planification des interventions par les dispatchers » (brief-fieldops.md, « Fonctionnalités souhaitées »).
- E05 Équipement : chaudière ou pompe à chaleur entretenue. Source : « Historique des interventions par client et par équipement » (brief-fieldops.md, « Fonctionnalités souhaitées »).
- E07 Site : adresse d'un client où sont installés des équipements. Source : réponse saisie à la question `Q01`.

### Relations

- Client 1 — 1..n Site : un client a un ou plusieurs sites (RG06).
- Site 1 — 0..n Équipement : un équipement est installé sur un seul site (RG06).
- Site 1 — 0..n Intervention : une intervention a lieu sur un site (RG06).
- Équipement 1 — 0..n Intervention : une intervention concerne un équipement (RG05, supposé).
- Technicien n — n Intervention : une intervention peut mobiliser plusieurs techniciens (RG02).

## Dictionnaire de données

| Entité | Champ | Type | Obligatoire | Exemple | Source |
|---|---|---|---|---|---|
| Client | nom | texte | oui | Société Exemple Chauffage | supposé |
| Site | adresse | texte | oui | 1 rue de l'Exemple, 00000 Villefictive | réponse saisie à la question `Q01` |
| Technicien | nom | texte | oui | Technicien Fictif | supposé |
| Technicien | zone | texte | oui | Nord | « affectation à un technicien selon sa zone et ses compétences » (brief-fieldops.md, « Fonctionnalités souhaitées ») |
| Technicien | compétences | liste de textes | oui | pompe à chaleur | « selon sa zone et ses compétences » (brief-fieldops.md, « Fonctionnalités souhaitées ») |
| Technicien | date de départ | date | non | 2026-12-31 | décision saisie en `D01` |
| Intervention | date prévue | date et heure | oui | 2026-11-02 09:00 | « Planification des interventions » (brief-fieldops.md, « Fonctionnalités souhaitées ») |
| Intervention | état | énumération (planifiée, en cours, terminée) | oui | planifiée | « planifiée, en cours, terminée » (brief-fieldops.md, « Fonctionnalités souhaitées ») |
| Intervention | compte rendu | texte | non | Remplacement du joint, essai concluant. | « Saisie du compte rendu par le technicien » (brief-fieldops.md, « Fonctionnalités souhaitées ») |
| Équipement | type | texte | oui | pompe à chaleur | supposé |

## Règles de gestion

- RG01 : une intervention est demandée par un et un seul client, au travers de son site. Source : « Informer le client à la fin de chaque intervention » (brief-fieldops.md, « Objectifs ») ; réponse saisie à la question `Q01`.
- RG02 : une intervention mobilise un ou plusieurs techniciens ; un technicien réalise plusieurs interventions. Source : réponse saisie à la question `Q03`.
- RG04 : un client possède zéro, un ou plusieurs équipements, chacun sur un de ses sites. Source : « par client et par équipement » (brief-fieldops.md, « Fonctionnalités souhaitées »).
- RG05 : une intervention concerne un et un seul équipement. Source : supposé.
- RG06 : un client a un ou plusieurs sites ; un équipement et une intervention sont rattachés à un seul site. Source : réponse saisie à la question `Q01`.
- RG07 : l'état d'une intervention vaut planifiée, en cours ou terminée. Source : « planifiée, en cours, terminée » (brief-fieldops.md, « Fonctionnalités souhaitées »).

## Questions au client

- Q01 (E01, E05) : « Historique des interventions par client et par équipement » (brief-fieldops.md, « Fonctionnalités souhaitées ») : un client peut-il avoir plusieurs adresses d'intervention, et à quelle adresse un équipement est-il rattaché ? Bloquante : oui.
  Réponse : Oui, un client peut avoir plusieurs sites ; chaque équipement est installé sur un seul site, et une intervention a lieu sur un site.
- Q03 (E02, E04) : « affectation à un technicien selon sa zone et ses compétences » (brief-fieldops.md, « Fonctionnalités souhaitées ») : une intervention peut-elle mobiliser plusieurs techniciens à la fois ? Bloquante : oui.
  Réponse : Oui, parfois deux techniciens pour les grosses installations.
- Q04 (E04) : « Tableau de bord mensuel pour la direction » (brief-fieldops.md, « Fonctionnalités souhaitées ») : quels indicateurs doit-il contenir ? Bloquante : non.
  Réponse :
- Q05 (E04) : « Faut-il reprendre l'historique du tableur ? » (notes-appel.md, « À clarifier ») : faut-il reprendre l'historique du tableur, et sous quelle forme ? Bloquante : non.
  Réponse :

## À décider

> **D01 — Retrait d'un technicien**
>
> Contexte : une intervention mobilise des techniciens (RG02) ; les sources ne disent pas ce qu'il advient d'un technicien qui quitte l'entreprise (supposé).
>
> - **Option 1 : suppression définitive.** Conséquence : ses interventions passées perdent leur technicien, ou doivent être supprimées avec lui.
> - **Option 2 : désactivation.** Conséquence : l'historique est conservé ; chaque liste de techniciens doit filtrer les inactifs.
>
> Décision : Option 2, désactivation avec une date de départ ; on garde l'historique.

## Revue du modèle

### Données personnelles

- Technicien.nom : nom d'une personne. Durée de conservation : à préciser.
- Site.adresse : adresse, personnelle si le client est un particulier. Durée de conservation : à préciser.

### Éléments supposés

- Client.nom, Technicien.nom, Équipement.type, RG05.

### Nommage incohérent

Aucun élément.

## Points non déterminés

- Durées de conservation des données personnelles : non déterminé.
