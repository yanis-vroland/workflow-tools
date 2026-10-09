# Spec 002 : wf-doc-projet, documentation d'un projet existant

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui intervient sur un projet peu ou pas documenté, je veux générer une documentation technique fidèle au code, afin de la remettre à l'équipe ou au client et de faciliter la prise en main du projet.

Le livrable s'adresse à l'équipe ou au client : il décrit, il ne juge pas. Il suit les conventions de l'ADR-001.

## Critères d'acceptation

- CA1 : Étant donné un projet cible, quand je lance `/wf-doc-projet` à sa racine, alors le livrable est créé sous `docs/wf/` (fichier unique ou dossier, voir CA9 et CA10) et aucun autre fichier du projet n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Présentation, Stack technique, Architecture, Installation et lancement, Configuration, Fonctionnalités, Structure du code, Points non déterminés.
- CA3 : Étant donné un projet qui définit des scripts de lancement (ex. `package.json`, `Makefile`), alors « Installation et lancement » donne les commandes réelles tirées de ces fichiers.
- CA4 : Étant donné un projet qui utilise des variables d'environnement, alors « Configuration » liste leurs noms (tirés de `.env.example` ou du code) sans aucune valeur, et l'outil ne lit pas les fichiers `.env*` autres que `.env.example`.
- CA5 : Étant donné le livrable, alors « Architecture » contient un schéma Mermaid des principaux composants et de leurs relations.
- CA6 : Étant donné le livrable, alors il ne contient aucun jugement de qualité (dette, risque, note) : ces éléments relèvent de `wf-analyse-projet`.
- CA7 : Étant donné un livrable déjà présent, quand je relance l'outil, alors il est mis à jour au lieu d'être dupliqué, et les sections encore exactes sont conservées.
- CA8 : Étant donné le livrable, alors son en-tête indique l'outil, la date et le commit documenté, suivi de la mention « modifications non commitées » si le répertoire de travail n'est pas propre.
- CA9 : Étant donné un projet qui n'est pas un monorepo et dont la documentation tient en 500 lignes, quand je lance l'outil, alors le livrable est le fichier unique `docs/wf/doc-projet.md` et le dossier `docs/wf/doc-projet/` n'existe pas.
- CA10 : Étant donné un monorepo, ou un projet dont la documentation dépasse 500 lignes, quand je lance l'outil, alors le livrable est le dossier `docs/wf/doc-projet/` contenant `index.md` (en-tête, Présentation, Stack technique, Architecture, Points non déterminés, liens vers les autres fichiers), `installation.md`, `configuration.md`, `fonctionnalites.md` et `structure.md`, et le fichier `docs/wf/doc-projet.md` n'existe pas. Dans un monorepo, chacun de ces fichiers contient une sous-section par application.
- CA11 : Étant donné un fichier `docs/wf/doc-projet.md` produit par l'outil, alors il compte au plus 500 lignes. Toutes les lignes du fichier sont comptées, en-tête et lignes vides compris (`wc -l`).
- CA12 : Étant donné un livrable existant dans un format (fichier unique ou dossier) et un projet qui relève désormais de l'autre, quand je relance l'outil, alors l'ancien format est remplacé par le nouveau, sans que les deux coexistent.
- CA13 : Étant donné un projet dont le README contredit le code (ex. une commande de lancement absente des scripts), alors l'écart est décrit factuellement dans « Points non déterminés », en citant le README et le fichier qui le contredit, et le README n'est pas modifié.
- CA14 : Étant donné un répertoire vide ou sans code source, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA15 : Étant donné un projet sans commande de lancement identifiable, alors « Installation et lancement » le dit, « Points non déterminés » le reprend, et aucune commande n'est inventée.

## Cas limites et erreurs

Couverts par CA10 (monorepo), CA12, et CA13 à CA15.

## Hors périmètre

- Diagnostic, dette et risques (c'est `wf-analyse-projet`).
- Guide de prise en main pas à pas pour un nouvel arrivant (c'est `wf-onboarding`).
- Modification du README ou de la documentation existante du projet.
- Documentation de chaque fonction ou endpoint (référence d'API exhaustive).
- Livrable dans une autre langue que le français.

## Questions ouvertes

- Le seuil de 500 lignes est une proposition, à ajuster après les premiers essais sur de vrais projets.
