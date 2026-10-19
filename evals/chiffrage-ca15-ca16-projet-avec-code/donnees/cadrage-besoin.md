# Cadrage du besoin : évolutions du back-office des interventions

- Outil : wf-cadrage-besoin
- Date : 2026-10-10
- Commit analysé : 2fc99c0
- Sources lues : demande-evolutions.md
- Derniers identifiants attribués : B03, Q02

## Synthèse

Le client souhaite trois évolutions du back-office web existant : un export PDF de la liste des interventions, un filtre par technicien et un e-mail envoyé au client à la clôture d'une intervention. La mise en page du PDF reste à préciser (Q01).

## Contexte et objectifs

- Le back-office est utilisé chaque jour par les dispatchers ; ils doivent aujourd'hui recopier la liste des interventions pour la transmettre (demande-evolutions.md, « Contexte »).

## Utilisateurs et rôles

- Dispatchers : consultent et filtrent la liste des interventions, exportent la liste (demande-evolutions.md, « Contexte »).
- Clients : reçoivent un e-mail à la clôture d'une intervention (demande-evolutions.md, « Évolutions demandées »).

## Besoins fonctionnels

- B01 : Export PDF de la liste des interventions affichée dans le back-office. Priorité : indispensable. Source : demande-evolutions.md, « Évolutions demandées ».
- B02 : Filtre de la liste des interventions par technicien. Priorité : important. Source : demande-evolutions.md, « Évolutions demandées ».
- B03 : Envoi d'un e-mail au client à la clôture d'une intervention. Priorité : non précisée. Source : demande-evolutions.md, « Évolutions demandées ».

## Contraintes

- Les évolutions s'intègrent au back-office existant, sans nouvelle application (demande-evolutions.md, « Contraintes »).

## Hors périmètre

- Application mobile des techniciens : aucune évolution demandée (demande-evolutions.md, « Contraintes »).

## Hypothèses

- Hypothèse à valider : le PDF reprend les colonnes de la liste affichée, sans mise en page spécifique (voir Q01).

## Questions au client

- Q01 (B01) : Le PDF doit-il suivre une charte graphique ou un modèle de mise en page particulier ?
  Réponse :
- Q02 (B03) : Le client doit-il pouvoir se désabonner de ces e-mails ?
  Réponse : Non, l'e-mail de clôture est un message de service.

## Points non déterminés

- Aucun.
