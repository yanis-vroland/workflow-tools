# Spec 016 : wf-passation, dossier de passation en fin de mission

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui termine une mission, je veux générer un dossier de passation, afin que la personne qui reprend le projet (équipe du client ou autre prestataire) sache ce qu'elle doit recevoir, ce qui est en cours et comment livrer, et puisse assumer le projet sans moi.

Le livrable s'adresse au repreneur, qui devient responsable du projet. Il est unique et neutre : le même dossier vaut pour un client comme pour un autre prestataire. Il répond à la question « que dois-je recevoir et savoir pour assumer ce projet seul ? ». Il se distingue de :

- `wf-doc-projet`, qui décrit le système (stack, architecture, installation locale) : la passation y renvoie sans la reproduire ;
- `wf-onboarding`, qui guide un développeur rejoignant une équipe toujours présente vers sa première contribution ;
- `wf-analyse-projet`, diagnostic à usage interne : la passation n'en reprend pas les jugements.

La procédure de déploiement n'est décrite par aucune section de `wf-doc-projet` : la passation est le seul outil qui la couvre.

Les informations absentes du dépôt (titulaires des comptes, interlocuteurs, échéances) sont laissées en champs « à compléter », remplis à la main et conservés à la relance. Seules les références git connues localement sont lues. Il suit les conventions de l'ADR-001 et de son amendement 1.

## Critères d'acceptation

- CA1 : Étant donné un projet cible, quand je lance `/wf-passation` à sa racine, alors le fichier `docs/wf/passation.md` est créé et aucun autre fichier du projet n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Documentation de référence, Environnements et déploiement, Services tiers et accès, Secrets à transmettre, Travaux en cours, Points d'attention, Checklist de passation, Points non déterminés.
- CA3 : Étant donné un projet qui contient des livrables `wf-*` dans `docs/wf/` ou une documentation propre (README, `docs/`), alors « Documentation de référence » liste chacun par un lien relatif, à l'exception des livrables à usage interne (`analyse-projet`, `chiffrage`, `revue-securite`), qui n'y figurent pas.
- CA4 : Étant donné un livrable de `wf-doc-projet` présent (`docs/wf/doc-projet.md` ou `docs/wf/doc-projet/index.md`), alors « Documentation de référence » y renvoie en nommant ses sections « Stack technique », « Architecture », « Installation et lancement » et « Configuration » (en format dossier : `index.md`, `installation.md` et `configuration.md`). Sans ce livrable, la section le signale et suggère de lancer `/wf-doc-projet`. Dans les deux cas, ni la stack ni l'architecture ne sont décrites dans la passation.
- CA5 : Étant donné un projet qui contient une configuration de déploiement (ex. workflow de CI avec étape de déploiement, `Dockerfile`, `docker-compose*.yml`, `vercel.json`, `netlify.toml`, `fly.toml`, `firebase.json`, script de déploiement), alors « Environnements et déploiement » liste chaque environnement identifié (ex. recette, production) et la façon de déployer sur chacun, avec les commandes ou déclencheurs exacts et le fichier source cité.
- CA6 : Étant donné un projet sans configuration de déploiement identifiable, alors « Environnements et déploiement » indique « procédure de déploiement non trouvée dans le dépôt », « Points non déterminés » le reprend, et aucune procédure n'est inventée.
- CA7 : Étant donné un projet qui utilise un service tiers, repéré par une dépendance (ex. SDK Stripe, Sentry, Firebase), un fichier de configuration ou un nom de variable d'environnement, alors « Services tiers et accès » le liste avec l'indice qui l'établit (fichier cité) et le champ « titulaire du compte : à compléter ».
- CA8 : Étant donné un projet dont la configuration de CI ou `.env.example` référence des secrets (ex. `${{ secrets.DEPLOY_TOKEN }}`), alors « Secrets à transmettre » liste leurs noms et le fichier qui les référence, sans aucune valeur, avec la mention « à transmettre par un canal sécurisé, hors de ce document ».
- CA9 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.
- CA10 : Étant donné un dépôt git, alors « Travaux en cours » liste les branches locales et les branches distantes connues localement qui ne sont pas fusionnées dans la branche principale, chacune avec la date de son dernier commit et son nombre de commits d'avance, signale les modifications non commitées, et précise que l'état des branches distantes est celui de la dernière récupération faite sur ce poste.
- CA11 : Étant donné un dépôt git dont la branche principale n'est déterminable ni par `origin/HEAD` ni par l'existence d'une branche `main` ou `master`, alors « Travaux en cours » l'indique, « Points non déterminés » le reprend, et aucune branche n'est déclarée non fusionnée.
- CA12 : Étant donné un projet contenant des marqueurs `TODO`, `FIXME` ou `HACK`, alors « Points d'attention » donne leur nombre total et liste au plus 20 fichiers, triés par nombre de marqueurs décroissant, avec ce nombre.
- CA13 : Étant donné le livrable, alors « Points d'attention » ne contient que des faits vérifiables cités avec leur fichier (marqueurs de CA12, écarts entre README et code, tests désactivés), sans niveau de risque, note ni estimation d'effort, et ne reprend aucun contenu du livrable `wf-analyse-projet`.
- CA14 : Étant donné le livrable, alors « Checklist de passation » est un tableau aux colonnes Action, Source, Statut, contenant une ligne par service tiers de CA7 (transfert de l'accès), une ligne par secret de CA8 (transmission), une ligne pour le dépôt de code (transfert des droits) et une ligne par branche de CA10 (fusionner, abandonner ou transmettre). Chaque ligne porte le statut « à faire » à sa création.
- CA15 : Étant donné un livrable existant dont des statuts de la checklist ou des champs « à compléter » ont été renseignés à la main, quand je relance l'outil, alors ces saisies sont conservées pour chaque ligne ou élément dont la source existe toujours, et le reste du livrable est mis à jour.
- CA16 : Étant donné le livrable, alors la Synthèse indique le périmètre transmis (applications du dépôt), le commit de référence et le nombre de lignes de la checklist par statut, et ces nombres correspondent exactement au tableau.
- CA17 : Étant donné le livrable, alors il ne contient aucune adresse e-mail ni aucun nom de contributeur : les interlocuteurs sont désignés par leur rôle, avec le champ « à compléter ».
- CA18 : Étant donné un projet qui n'est pas un dépôt git, alors l'en-tête indique « hors git », « Travaux en cours » indique « non applicable », et la ligne « dépôt de code » de la checklist n'est pas créée.
- CA19 : Étant donné un projet dont la stack n'est couverte ni par JavaScript/TypeScript ni par Flutter, alors le livrable est produit, l'en-tête indique « stack <nom> non couverte en v1 », et « Services tiers et accès » se limite aux indices hors dépendances (fichiers de configuration, CI, `.env.example`), ce que « Points non déterminés » signale.
- CA20 : Étant donné un monorepo (ex. FieldOps : application web et application compagnon Flutter), alors « Environnements et déploiement » et « Services tiers et accès » contiennent une sous-section par application.
- CA21 : Étant donné le livrable, alors son en-tête est conforme à l'ADR-001 (outil, date, commit ou « hors git », mention « modifications non commitées » le cas échéant).
- CA22 : Étant donné un répertoire vide ou sans code source, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.

## Cas limites et erreurs

Couverts par CA6 (pas de déploiement), CA11 (branche principale inconnue), CA15 (saisies humaines), CA18 (hors git), CA19, CA20 (monorepo) et CA22.

## Hors périmètre

- Description du système : stack, architecture, installation locale (c'est `wf-doc-projet`).
- Recouvrement assumé avec `wf-doc-projet` et `wf-onboarding` : les écarts entre README et code figurent dans chacun de ces livrables, qui doivent pouvoir se lire seuls.
- Guide pas à pas pour un développeur qui rejoint l'équipe (c'est `wf-onboarding`).
- Diagnostic, dette, niveaux de risque et effort de reprise (c'est `wf-analyse-projet`).
- Variante du livrable selon le type de repreneur (client ou prestataire).
- Questions posées à l'utilisateur pendant l'exécution.
- Récupération des références distantes (`git fetch`) et lecture des PR, issues ou tickets sur une plateforme distante.
- Transmission des valeurs des secrets, des identifiants ou des mots de passe, sous quelque forme que ce soit.
- Transfert effectif des accès, des comptes ou du dépôt.
- Aspects contractuels de fin de mission (propriété intellectuelle, garantie, facturation).

## Questions ouvertes

- Le plafond de 20 fichiers listés pour les marqueurs (CA12) est une proposition, à ajuster après les premiers essais sur de vrais projets.
