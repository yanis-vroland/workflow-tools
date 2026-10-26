---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA3 et CA4 : le projet contient dans `docs/wf/` les livrables doc-projet
(dossier `doc-projet/`), onboarding, exploitation, analyse-projet, chiffrage
et revue-securite, ainsi que `README.md`, `mobile/README.md` et des specs dans
`docs/specs/`.

Réussite si toutes les affirmations suivantes sont vraies dans « Documentation
de référence » :
1. Chaque document listé l'est par un lien Markdown relatif au dossier
   `docs/wf/` (ex. `onboarding.md`, `../../README.md`), jamais par un chemin
   absolu.
2. doc-projet, onboarding, exploitation et le README sont listés.
3. analyse-projet, chiffrage et revue-securite n'y figurent pas.
4. Le renvoi à doc-projet nomme « Stack technique » et « Architecture »
   (`index.md`), « Installation et lancement » (`installation.md`) et
   « Configuration » (`configuration.md`), sans décrire la stack ni
   l'architecture.
