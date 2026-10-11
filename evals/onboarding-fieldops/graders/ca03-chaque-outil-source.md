---
type: llm
focus: { source: file, path: "docs/wf/onboarding.md" }
---

CA3 : dans la section « Avant de commencer » du guide.

Réussite si toutes les affirmations suivantes sont vraies :
1. Chaque outil requis listé est accompagné soit d'une version et du chemin du
   fichier d'où elle provient, soit de la mention « version non déterminée ».
2. Aucune version n'est donnée sans fichier source cité.
3. Node.js est donné en 18.19.0 (source `.nvmrc`) ; si `package.json` (engines
   `>=18`) ou le `Dockerfile` (`node:18-alpine`) sont cités, c'est comme
   sources concordantes, sans contradiction avec 18.19.0.
4. Flutter est donné en 3.13.9 (source `mobile/.fvmrc`).
5. Aucune version n'est inventée (ex. une version de npm, de Docker ou de fvm
   qui ne figure dans aucun fichier).
