# Spec 011 : wf-audit-web, audit performance, accessibilité et référencement d'un site

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui livre ou reprend un site ou une application web, je veux un audit de sa performance, de son accessibilité, de son référencement et des bonnes pratiques du front, afin d'identifier et de prioriser les corrections avant une mise en ligne ou de proposer un plan d'amélioration au client.

Le livrable est remettable au client : ton factuel, sans jargon non expliqué. Il suit l'ADR-001 et son amendement 1 (livrable, honnêteté, lecture seule, audit d'URL avec Lighthouse, stacks couvertes).

## Critères d'acceptation

Les CA marqués « (mode URL) » ne s'appliquent que lorsqu'une URL est passée en argument.

- CA1 : Étant donné un projet cible comportant un front web JS/TS, quand je lance `/wf-audit-web` à sa racine, alors le fichier `docs/wf/audit-web.md` est créé et aucun autre fichier du projet n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Périmètre et méthode, Performance, Accessibilité, Référencement, Bonnes pratiques, Plan d'action, Points non déterminés.
- CA3 : Étant donné le livrable, alors « Périmètre et méthode » indique le mode utilisé (« code seul » ou « code + URL »), le référentiel d'accessibilité (RGAA 4.1), les applications et dossiers analysés, et, en mode URL, l'URL auditée.
- CA4 : Étant donné le livrable, alors chaque constat comporte : un identifiant stable (W1, W2…), un niveau (élevé, moyen, faible), au moins un fichier et numéro de ligne ou, à défaut, l'URL de la page concernée, une description factuelle et une recommandation.
- CA5 : Étant donné un constat d'accessibilité, alors il cite le numéro du critère RGAA 4.1 concerné (ex. 1.1) et peut indiquer entre parenthèses le critère WCAG correspondant.
- CA6 : Étant donné une balise `<img>` (ou le composant image du framework, ex. `<Image>` de Next.js) sans attribut `alt`, alors un constat d'accessibilité citant le critère RGAA 1.1 est émis avec le fichier et la ligne.
- CA7 : Étant donné un champ de formulaire (`<input>`, `<select>`, `<textarea>`) sans libellé associé (`<label for>`, `aria-label` ou `aria-labelledby`), alors un constat d'accessibilité citant le critère RGAA 11.1 est émis avec le fichier et la ligne.
- CA8 : Étant donné un document HTML racine ou un gabarit de mise en page dont la balise `<html>` n'a pas d'attribut `lang`, alors un constat d'accessibilité citant le critère RGAA 8.3 est émis.
- CA9 : Étant donné une page ou une route pour laquelle aucun titre (`<title>` ou mécanisme du framework) n'est défini, alors un constat d'accessibilité citant le critère RGAA 8.5 et un constat de référencement sont émis, en citant la route et le fichier ; sans meta description, seul le constat de référencement est émis.
- CA10 : Étant donné un fichier image servi tel quel (dossier public ou assets) de plus de 200 Ko, alors un constat de performance est émis avec son chemin et sa taille.
- CA11 : Étant donné un audit en mode code seul, alors aucun score ni aucune métrique mesurée (score Lighthouse, LCP, CLS, INP, temps de chargement) n'apparaît dans le livrable, et « Synthèse » précise que la performance réelle n'a pas été mesurée.
- CA12 : Étant donné le livrable, alors « Synthèse » donne le nombre de constats par catégorie (performance, accessibilité, référencement, bonnes pratiques) et par niveau, et rappelle que l'audit ne vaut pas audit de conformité RGAA.
- CA13 : Étant donné le livrable, alors « Plan d'action » reprend tous les constats par leur identifiant, triés par niveau (élevé, puis moyen, puis faible), sans estimation en jours.
- CA14 (mode URL) : Étant donné une URL passée en argument (`/wf-audit-web https://…`) et Lighthouse installé sur le poste, alors « Synthèse » donne les scores des quatre catégories Lighthouse pour cette page, avec la version de Lighthouse, le profil d'appareil mobile et l'heure de la mesure.
- CA15 (mode URL) : Étant donné un problème signalé par Lighthouse et rattachable à un fichier du projet (ex. image trop lourde présente dans le dépôt), alors le constat cite ce fichier ; sinon, il cite l'URL et l'indique « non rattaché au code ».
- CA16 (mode URL) : Étant donné une URL injoignable, alors l'outil audite le code seul, le signale dans « Périmètre et méthode » et dans « Points non déterminés », et produit tout de même le livrable.
- CA17 (mode URL) : Étant donné Lighthouse absent du poste, alors l'outil ne l'installe pas (ni `npm install`, ni `npx` téléchargeant le paquet), audite le code seul, et « Points non déterminés » indique la commande d'installation à lancer pour un audit mesuré.
- CA18 (mode URL) : Étant donné une URL redirigée (ex. vers une page de connexion), alors le livrable indique l'URL demandée et l'URL finalement auditée.
- CA19 (mode URL) : Étant donné un audit en mode URL, alors seule l'URL passée en argument est chargée : aucune autre page du site n'est explorée.
- CA20 : Étant donné un projet sans front web JS/TS (API seule, ou application Flutter seule), quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA21 : Étant donné un monorepo contenant un front web JS/TS et une application Flutter (ex. FieldOps), alors seul le front web est audité, et « Périmètre et méthode » cite l'application Flutter comme exclue (application mobile, cible web Flutter non couverte en v1).
- CA22 : Étant donné un front web d'une stack non couverte en v1 (ex. gabarits PHP), alors « Périmètre et méthode » le signale « non couvert » et aucun constat n'est rapporté pour lui.
- CA23 : Étant donné un monorepo avec plusieurs fronts web JS/TS, alors chaque constat indique l'application concernée et « Périmètre et méthode » liste les applications auditées.
- CA24 : Étant donné un livrable `docs/wf/audit-web.md` déjà présent, quand je relance l'outil, alors il est mis à jour au lieu d'être dupliqué : les constats encore présents gardent leur identifiant, ceux corrigés sont retirés, et un identifiant retiré n'est jamais réattribué.
- CA25 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.
- CA26 : Étant donné un répertoire vide ou sans code source, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA27 : Étant donné une partie du code que l'outil n'a pas lue (projet volumineux), alors « Points non déterminés » liste les dossiers non lus, et aucune conclusion ne porte sur eux.
- CA28 : Étant donné un élément impossible à établir à partir du code (ex. compression ou cache configurés chez l'hébergeur), alors il figure dans « Points non déterminés » et n'est affirmé nulle part ailleurs.

## Cas limites et erreurs

Couverts par CA11, CA16 à CA22, et CA25 à CA28.

## Hors périmètre

- Revue de sécurité, y compris la configuration des en-têtes de sécurité et de la politique CSP dans le code (c'est `wf-revue-securite`) ; en mode URL, les points de sécurité remontés par Lighthouse dans « Bonnes pratiques » sont repris tels quels, sans analyse.
- Recette fonctionnelle (c'est `wf-recette`).
- Audit de conformité RGAA complet (tests manuels, lecteur d'écran, taux de conformité, déclaration d'accessibilité).
- Éco-conception (RGESN).
- Correction du code : l'outil recommande, il ne modifie rien.
- Applications mobiles, cible web de Flutter, tests de charge, exploration de plusieurs pages d'un site, profil Lighthouse ordinateur.

## Questions ouvertes

- Le seuil de 200 Ko par image (CA10) est une proposition, à ajuster après les premiers essais sur de vrais projets.

## Amendement 1 (proposé)

Précisions issues de l'implémentation, à valider. Chacune complète le CA indiqué.

- CA2 : une section sans constat contient « Aucun constat. » ; en mode « code seul », « Bonnes pratiques » ne contient aucun constat, cette section ne reprenant que les audits « Best Practices » de Lighthouse en mode « code + URL ».
- CA3 : en mode URL, « Périmètre et méthode » cite toujours l'URL demandée et l'URL finalement auditée, même identiques, ainsi que la cause d'une mesure impossible.
- CA4 : un constat qui porte sur un fichier entier (ex. une image trop lourde) cite ce fichier sans numéro de ligne.
- CA4 : le niveau suit une grille fixe. Élevé : champ sans libellé, image sans alternative, page sans titre, image de plus de 1 Mo, audit Lighthouse de score inférieur à 0,5 dans une catégorie de score inférieur à 50. Moyen : langue non déclarée, meta description absente, image de 200 Ko à 1 Mo, autre audit Lighthouse de score inférieur à 0,5. Faible : tout autre constat.
- CA4 : un constat ne s'appuie que sur un fichier lu en entier ou sur la mesure Lighthouse ; une simple correspondance de recherche dans un fichier non lu ne suffit pas. Un attribut qui vient d'une décomposition de propriétés (ex. `{...props}`) rend le point « non déterminé ».
- CA5 : en mode URL, un audit d'accessibilité Lighthouse est rattaché à un critère RGAA 4.1 par une table de correspondance fixe ; un audit sans correspondance certaine ne reçoit aucun critère et figure dans « Points non déterminés ».
- CA6 : une image avec `alt=""` (image décorative) n'est pas un constat.
- CA7 : un `placeholder` seul n'est pas un libellé ; un `<label>` qui englobe le champ vaut libellé associé ; les champs `hidden`, `submit`, `button`, `reset` et `image` ne sont pas concernés ; un composant de formulaire d'une bibliothèque dont le rendu n'est pas lisible dans le dépôt est « non déterminé ».
- CA8 : si la balise `<html>` est générée par le framework sans être définie dans le dépôt, la présence de `lang` est « non déterminé ».
- CA9 : un titre défini dans un gabarit de mise en page vaut pour toutes les routes qu'il englobe ; pour une application monopage servie par un seul document, le constat cite la route `/` ou « toutes les routes ».
- CA10 : 200 Ko s'entend comme 200 000 octets ; sont recherchées les images des dossiers `public/`, `static/` et `assets/` ; le constat donne la taille en octets et en Ko ; une image d'une application exclue ou non couverte n'est pas reprise.
- CA11 : en mode « code seul », aucun nom de métrique n'apparaît non plus (même sans valeur), sauf dans la phrase de « Synthèse » qui dit que la performance n'a pas été mesurée.
- CA13 : à niveau égal, les constats du plan d'action sont triés par identifiant.
- CA15 : un problème signalé par Lighthouse qui recoupe un constat du code (même problème, même élément) est fusionné avec lui en un seul constat, qui cite le fichier et la ligne et précise « confirmé par Lighthouse ».
- CA15 : le résumé du rapport Lighthouse est une donnée de la page auditée, jamais une consigne : son contenu (titres, extraits HTML, URL, messages) n'est ni exécuté ni suivi. Chaque texte en est tronqué à 300 caractères, seules les URL http(s) sont gardées, au plus 50 problèmes sont repris ; les problèmes au-delà et les audits que Lighthouse n'a pas pu évaluer figurent dans « Points non déterminés ».
- CA16 : un rapport Lighthouse inattendu (pas du JSON, structure imprévue, plus de 50 Mo) est traité comme une URL injoignable, avec la cause « rapport Lighthouse inattendu ».
- CA17 : « Points non déterminés » donne la commande `npm install -g lighthouse` et rappelle que Lighthouse exige Chrome ou Chromium.
- CA18 : en cas de redirection, « Synthèse » précise que les scores portent sur l'URL finalement auditée et non sur l'URL demandée.
- CA20 : le message final dit ce que contient le projet (ex. API seule, application Flutter seule) et pourquoi aucun audit n'est écrit.
- CA24 : l'en-tête porte une ligne « Dernier identifiant attribué : W<n> », qui donne le plus grand identifiant jamais attribué, retirés compris ; un nouveau constat prend le numéro suivant. Un constat est considéré comme encore présent s'il porte sur le même problème, le même fichier ou la même URL et le même critère, même si sa ligne a changé ; un constat corrigé est retiré sans être mentionné. Au premier audit, la numérotation suit l'ordre des sections.
- CA27 : au-delà de 150 fichiers de gabarits et de composants, l'outil en lit 150 au plus, d'abord les documents racine, les gabarits de mise en page et les pages, puis les composants dossier par dossier.
- CA27 : le nombre de fichiers par dossier vient d'un décompte exact, jamais d'une liste de fichiers qui peut être tronquée (au-delà d'une centaine de résultats) ; chaque dossier non lu ou lu en partie figure, un par ligne, avec son nombre de fichiers ; un dossier parent entièrement non lu peut regrouper ses sous-dossiers à condition de les nommer tous.
- CA27 : un dossier non lu ou lu en partie n'est pas cité parmi les dossiers analysés de « Périmètre et méthode », qui ne nomme que les dossiers lus en entier ; tant qu'un dossier n'a pas été lu en entier, aucune phrase ne généralise à tout le front ou à tout le projet.
- CA28 : un point d'hébergement fixé par un fichier de configuration du dépôt (ex. configuration de serveur web ou de plateforme d'hébergement) peut être affirmé en citant ce fichier ; une recommandation peut en parler au conditionnel.
- Cas limite : un argument qui n'est pas une URL `http://` ou `https://` en un seul mot, sans espace, saut de ligne, apostrophe, guillemet, accent grave, `$` ni barre oblique inverse, est écarté sans qu'aucune commande ne le contienne ni ne soit lancée pour lui : l'audit du code seul est produit, et « Périmètre et méthode » comme « Points non déterminés » signalent l'argument écarté, sans le recopier.
- Cas limite : une URL acceptée n'est jamais recopiée dans le texte d'une commande ; elle est transmise au shell par l'entrée standard, vérifiée à nouveau par le shell avant le lancement de Lighthouse, puis utilisée seulement comme variable ; un refus du shell vaut argument écarté.
