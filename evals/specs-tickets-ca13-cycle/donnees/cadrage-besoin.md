# Cadrage du besoin : reprise du parc et des contrats de maintenance

- Outil : wf-cadrage-besoin
- Date : 2026-10-14
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Sources lues : demande-reprise.md
- Derniers identifiants attribués : B03, Q01

## Synthèse

Le responsable d'exploitation demande la reprise du parc d'équipements et des contrats de maintenance depuis l'ancien tableur, puis leur consultation. La demande impose un ordre de livraison contradictoire entre les deux reprises (Q01).

## Contexte et objectifs

- Le parc d'équipements et les contrats de maintenance sont tenus dans deux onglets d'un tableur (demande-reprise.md, « Contexte »).

## Utilisateurs et rôles

- Dispatchers : consultent la fiche d'un équipement et son contrat (demande-reprise.md, « Demandes »).

## Besoins fonctionnels

- B01 : Import du parc d'équipements depuis le tableur. Priorité : indispensable. Source : demande-reprise.md, « Demandes ».
- B02 : Import des contrats de maintenance depuis le tableur. Priorité : indispensable. Source : demande-reprise.md, « Demandes ».
- B03 : Consultation de la fiche d'un équipement avec son contrat de maintenance. Priorité : important. Source : demande-reprise.md, « Demandes ».

## Contraintes

- L'import des équipements (B01) ne peut être livré qu'après l'import des contrats (B02), chaque équipement devant être rattaché à un contrat existant (demande-reprise.md, « Contraintes »).
- L'import des contrats (B02) ne peut être livré qu'après l'import des équipements (B01), chaque contrat devant désigner des équipements existants (demande-reprise.md, « Contraintes »).
- La consultation (B03) n'est livrée qu'une fois les deux imports livrés (demande-reprise.md, « Contraintes »).

## Hors périmètre

Aucun élément.

## Hypothèses

Aucun élément.

## Questions au client

- Q01 (B01, B02) : « les équipements après les contrats » et « les contrats après les équipements » (demande-reprise.md, « Contraintes ») : lequel des deux imports doit être livré en premier ?
  Réponse :

## Points non déterminés

Aucun élément.
