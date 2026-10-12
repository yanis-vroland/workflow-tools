---
type: llm
focus: { source: file, path: "docs/wf/onboarding.md" }
---

CA11 : dans la section « Glossaire métier ».

Réussite si toutes les affirmations suivantes sont vraies :
1. Le glossaire liste au plus 20 termes.
2. Ce sont des termes du domaine tirés des noms d'entités, de modèles ou de
   tables (ex. Intervention, Technician, WorkOrder), pas des termes techniques
   génériques (Express, React, JWT…).
3. Chaque terme est accompagné du chemin du fichier où il est défini.
4. Les définitions données s'appuient sur les fichiers (ex. commentaires de
   `src/domain/types.ts`) ; un terme sans définition établie porte la mention
   « définition non déterminée ».
