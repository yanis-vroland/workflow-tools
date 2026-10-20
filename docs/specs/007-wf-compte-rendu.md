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

## Amendement 1 (proposé)

Précisions issues de l'implémentation, à valider. Chacune complète le CA indiqué.

- CA1 : le texte collé n'est enregistré dans aucun fichier, et rien n'est écrit tant que la source, la date de la réunion et le nom du compte rendu ne sont pas établis.
- CA2 : sans argument, l'outil ne cherche ni ne liste aucun fichier de notes dans le projet ; il demande la source. Un argument qui n'est pas un fichier existant et ne ressemble pas à un chemin (une seule ligne sans espace, contenant un `/` ou se terminant par une extension) est le texte des notes, collé dans la commande ; un texte collé vide revient à l'absence d'argument.
- CA2, CA15, CA17 : un chemin de notes suivi d'un autre texte dans la commande donne une réponse anticipée aux questions de l'outil (date de la réunion, « relance » ou « nouvelle réunion ») ; l'outil l'applique au lieu de poser la question, et n'en reprend rien dans le compte rendu, hors la date de la réunion.
- CA3 : l'objet est, dans cet ordre, la valeur d'une ligne « Objet : » (ou son équivalent dans la langue des notes), le titre des notes (titre Markdown, ou première ligne courte qui n'est ni un élément de liste, ni un horodatage, ni un tour de parole), le nom du fichier de notes sans date ni extension, ou « Réunion » pour des notes collées sans titre. Il est repris tel qu'écrit, sans reformulation, sans développer d'abréviation et sans traduction ; la date et les séparateurs qui l'entourent sont retirés.
- CA3 : au-delà de 5 mots, seuls les 5 premiers sont gardés ; « œ » et « æ » deviennent « oe » et « ae ».
- CA3, CA15 : la date de la réunion est, dans cet ordre, celle écrite dans les notes (tout format, convertie en `AAAA-MM-JJ`), sinon celle du nom du fichier ; une échéance d'action ou un jour de la semaine n'est jamais pris pour la date de la réunion. Une date sans année n'est retenue que si le nom du fichier la confirme avec l'année. Si les notes et le nom du fichier diffèrent, la date des notes est retenue et l'écart est signalé dans « Points non déterminés ».
- CA4 : l'index porte l'en-tête commun (outil, date de génération, commit) et un tableau Date, Objet, Compte rendu, une ligne par fichier ; à date égale, les comptes rendus sont classés par nom de fichier. L'objet affiché est celui du titre du compte rendu, à défaut celui du nom de fichier. L'index est réécrit à chaque exécution qui écrit un compte rendu.
- CA5 : une section sans élément contient la seule ligne « Aucun élément. » ; sans action, le tableau des actions garde son en-tête, suivi de cette ligne. Chaque entrée de « Questions en suspens » est une phrase compréhensible sans les notes.
- CA6, CA19 : l'en-tête porte les lignes « Outil », « Date » (génération), « Commit analysé », « Date de la réunion » et « Source des notes ». Le commit est « hors git » quand le répertoire n'est pas un dépôt git ou n'a aucun commit ; sinon le hash court, suivi de « modifications non commitées » si le répertoire de travail n'est pas propre.
- CA7 : l'échéance est reprise telle que les notes la donnent, sans en changer la valeur ni la compléter. Le responsable est la personne nommée en tête de l'action, ou l'orateur qui s'engage à la première personne dans une transcription.
- CA8 : seule une formulation d'accord explicite, en toute langue, fait une décision ; une idée, une piste, un point reporté ou « à valider » va dans « Questions en suspens ».
- CA10 : l'outil ne lit, ne liste ni ne recherche aucun fichier du projet en dehors des notes et du dossier `docs/wf/compte-rendu/`, dont il lit les comptes rendus pour l'index et les doublons.
- CA11 : une personne seulement mentionnée dans les notes (absente, à contacter) n'est pas un participant ; aucun rôle n'est inventé ; adresse e-mail et numéro de téléphone sont retirés même d'une citation.
- CA12 : l'identifiant de connexion qui accompagne un secret est retiré avec lui ; le secret n'est reproduit ni en entier, ni en partie, ni masqué.
- CA14 : sont traduits en français le titre, la section « Objet », les synthèses, décisions, actions, échéances et questions ; le nom du fichier garde l'objet tel qu'écrit dans les notes. Une citation dans la langue d'origine n'est permise que dans « Points non déterminés » ; ailleurs, le passage est reformulé en français.
- CA16 : un compte rendu existant au même nom dont la source est le même nom de fichier de notes est mis à jour sans question. Il est réécrit entièrement à partir des notes actuelles, sous le même nom, avec une date de génération et un commit à jour.
- CA17 : la question est posée dès que la source du compte rendu existant diffère, ou que l'un des deux provient de notes fournies dans la conversation ; elle nomme le compte rendu existant et sa source. Pour une nouvelle réunion, le compte rendu prend le premier suffixe libre : `-2`, puis `-3`, etc.
- CA18 : les vérifications se font dans cet ordre : fichier d'environnement (nom commençant par `.env`, refusé sans être ouvert, y compris `.env.example`), fichier introuvable, format non accepté (fichier non ouvert, formats acceptés rappelés), fichier vide ou ne contenant que des espaces. Le message nomme le fichier et la raison, et l'outil ne se rabat sur aucun autre fichier du projet.
- Cas limite : l'outil ne pose de question que dans les trois cas prévus (aucune source, date introuvable, doublon de nom) ; il n'écrit alors rien et attend la réponse. Le message final donne le chemin du compte rendu, le nombre de décisions, d'actions et de questions en suspens, et signale le retrait d'un secret sans le citer ; si rien n'est écrit, il le dit avec la raison ou la question posée.
