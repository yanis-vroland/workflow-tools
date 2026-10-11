---
type: llm
focus: { source: file, path: "docs/wf/onboarding.md" }
---

CA4 : dans les sections « Installer le projet », « Lancer le projet » et
« Vérifier l'installation ».

Réussite si toutes les affirmations suivantes sont vraies :
1. Chaque étape numérotée donne au moins une commande exacte (dans un bloc de
   code ou entre accents graves), ou est explicitement une étape sans commande
   (ex. copier un fichier, signaler un point non déterminé).
2. Chaque commande est attribuée à un fichier du projet cité par son chemin
   (ex. `package.json`, `README.md`, `mobile/README.md`, `docker-compose.yml`).
3. Les commandes correspondent à des fichiers de FieldOps : par exemple
   `npm install` (README.md), `npm run db:seed`, `npm run dev`, `npm run dev:web`,
   `npm test` (package.json), `fvm flutter pub get`, `fvm flutter run`,
   `fvm flutter test` (mobile/README.md). Aucune commande ne sort de nulle part.
