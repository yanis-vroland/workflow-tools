# Spec 007 : wf-compte-rendu, compte rendu de réunion

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui anime ou suit des réunions sur un projet (point hebdomadaire, atelier, revue de sprint), je veux transformer mes notes brutes ou une transcription en un compte rendu structuré, afin de le diffuser tel quel au client et aux participants et de garder une trace des décisions et des actions à côté du code du projet.

L'entrée principale n'est pas le code du projet mais un fichier de notes ou de transcription passé en argument, ou à défaut un texte collé dans la conversation. Le code du projet n'est pas lu. Formats acceptés : texte brut et Markdown (`.txt`, `.md`), sous-titres de visio (`.vtt`, `.srt`).

Le livrable suit les conventions de l'ADR-001 et de son amendement 1, en particulier l'organisation « un fichier par occurrence » (`docs/wf/compte-rendu/`), les entrées hors du code et l'absence de connexion à un service privé (pas de plateforme de transcription). Les évaluations s'appuient sur la fixture `tests/fixtures/fieldops-brief/`.

## Critères d'acceptation

- CA1 : Étant donné un fichier de notes (ex. `notes/2026-10-07-point-hebdo.md` de la fixture `fieldops-brief`, ou un fichier hors du projet), quand je lance `/wf-compte-rendu <chemin>` à la racine du projet, alors un compte rendu est créé sous `docs/wf/compte-rendu/` et aucun autre fichier n'est modifié, en particulier le fichier de notes.
- CA2 : Étant donné aucun chemin en argument, quand je lance `/wf-compte-rendu`, alors l'outil me demande un chemin de fichier ou le texte des notes ; si je colle le texte, il est utilisé comme source et l'en-tête indique « notes fournies dans la conversation ».
- CA3 : Étant donné une réunion datée du 2026-10-07 dont l'objet est « point hebdomadaire », alors le compte rendu est le fichier `docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md` : date de la réunion au format `AAAA-MM-JJ`, puis l'objet en minuscules, sans accents, mots séparés par des tirets, au plus 5 mots.
- CA4 : Étant donné le dossier `docs/wf/compte-rendu/`, alors son fichier `index.md` liste tous les comptes rendus du dossier, du plus récent au plus ancien, avec pour chacun la date, l'objet et un lien relatif vers le fichier.
- CA5 : Étant donné un compte rendu produit, alors il contient dans cet ordre les sections : Objet, Participants, Points abordés, Décisions, Actions, Questions en suspens, Points non déterminés. Ces noms de sections sont un contrat au sens de l'amendement 1 de l'ADR-001 : « Questions en suspens » est lue par `wf-rapport-avancement` (spec 008).
- CA6 : Étant donné un compte rendu produit, alors son en-tête contient les éléments prévus par l'ADR-001, ainsi que la date de la réunion et la source des notes : le nom du fichier seul, sans chemin, ou « notes fournies dans la conversation ».
- CA7 : Étant donné un compte rendu produit, alors la section « Actions » est un tableau à trois colonnes : Action, Responsable, Échéance. Quand les notes ne mentionnent pas le responsable ou l'échéance d'une action, la cellule contient « non déterminé » ; aucun responsable ni aucune échéance n'est déduit.
- CA8 : Étant donné des notes où un point est formulé comme une proposition sans accord explicite (ex. « Proposition : passer l'export PDF en tâche de fond, à valider avec l'équipe terrain »), alors ce point figure dans « Questions en suspens » et pas dans « Décisions ».
- CA9 : Étant donné un compte rendu produit, alors chaque participant, décision, action et échéance qu'il cite figure dans les notes source ; aucun élément n'est ajouté à partir d'une autre source.
- CA10 : Étant donné un compte rendu produit, alors l'outil n'a lu aucun fichier de code du projet pour le compléter, et le compte rendu ne cite aucun chemin de fichier du projet qui ne figure pas dans les notes.
- CA11 : Étant donné des notes qui contiennent des adresses e-mail ou des numéros de téléphone de participants, alors le compte rendu n'en contient aucun ; les participants sont désignés par leur nom tel qu'écrit dans les notes, suivi de leur rôle si les notes le mentionnent.
- CA12 : Étant donné des notes qui contiennent un secret (mot de passe, token, clé d'API), alors la valeur n'est pas recopiée dans le compte rendu ; « Points non déterminés » signale qu'un secret a été retiré, sans le reproduire.
- CA13 : Étant donné une transcription horodatée avec tours de parole (ex. `[00:12:34] Camille : …`, ou un fichier `.vtt`), alors le compte rendu ne contient aucun horodatage et ne reproduit pas le verbatim ligne à ligne : les échanges sont regroupés par sujet dans « Points abordés ».
- CA14 : Étant donné des notes rédigées dans une autre langue que le français, alors le compte rendu est rédigé en français ; les noms propres et les termes techniques sont conservés tels quels.
- CA15 : Étant donné des notes sans date de réunion, quand le nom du fichier de notes ne contient pas non plus de date au format `AAAA-MM-JJ`, alors l'outil me demande la date de la réunion ; il n'utilise jamais la date du jour sans me l'avoir demandé.
- CA16 : Étant donné un compte rendu déjà présent pour la même date et le même objet, quand je relance l'outil sur les mêmes notes (éventuellement complétées), alors ce fichier est mis à jour au lieu d'être dupliqué, et `index.md` ne contient toujours qu'une seule ligne pour cette réunion.
- CA17 : Étant donné deux réunions différentes à la même date dont l'objet produit le même nom de fichier, quand je lance l'outil sur les secondes notes, alors l'outil me demande s'il s'agit d'une relance (CA16) ou d'une nouvelle réunion ; pour une nouvelle réunion, le compte rendu est nommé avec le suffixe `-2` (ex. `2026-10-07-point-hebdomadaire-2.md`) et le premier n'est pas modifié.
- CA18 : Étant donné un chemin de notes inexistant, un fichier vide ou un fichier dans un autre format que `.txt`, `.md`, `.vtt` ou `.srt`, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA19 : Étant donné un répertoire sans code source ou qui n'est pas un dépôt git (ex. la fixture `fieldops-brief`), alors le compte rendu est tout de même produit, avec « hors git » dans l'en-tête le cas échéant.
- CA20 : Étant donné des notes dont un passage est ambigu (ex. responsable désigné par « il » sans antécédent), alors l'ambiguïté figure dans « Points non déterminés » avec la citation du passage, et elle n'est pas tranchée ailleurs dans le compte rendu.

## Cas limites et erreurs

Couverts par CA2, CA8 et CA11 à CA20.

## Hors périmètre

- Transcription d'un enregistrement audio ou vidéo : l'outil part d'un texte déjà écrit.
- Connexion à une plateforme de transcription ou de visio (amendement 1 de l'ADR-001).
- Formats bureautiques en entrée (`.docx`, `.pdf`).
- Reprise et suivi des actions du compte rendu précédent : chaque compte rendu ne porte que sur ses notes.
- Envoi ou diffusion du compte rendu (e-mail, messagerie) et export PDF ou Word.
- Création de tickets à partir des actions (c'est `wf-specs-tickets`).
- Synthèse de l'avancement sur une période (c'est `wf-rapport-avancement`) : ici, une seule réunion.
- Lecture du code du projet pour compléter ou vérifier les notes.

## Questions ouvertes

- La limite de 5 mots pour l'objet dans le nom de fichier (CA3) est une proposition, à ajuster après les premiers essais.
