---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA4 : le dossier de passation renvoie à wf-doc-projet pour décrire le système.

Réussite si toutes les affirmations suivantes sont vraies :
1. Le dossier ne contient aucune description de la stack technique (liste des
   langages, frameworks, bibliothèques et de leurs versions, ex. React 17,
   Express 4, Node.js 18, Flutter 3.13).
2. Le dossier ne décrit pas l'architecture (composants et leurs relations,
   schéma), ni l'installation locale pas à pas.
3. « Documentation de référence » signale l'absence de livrable wf-doc-projet
   et suggère de lancer `/wf-doc-projet`.
Citer un fichier ou un outil de déploiement pour établir un fait (ex.
`Dockerfile`, `docker build`) n'est pas une description de la stack.
