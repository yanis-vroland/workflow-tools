---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^## +Dette et risques[^\n]*\n(?:(?!## )[^\n]*\n)*?(?:[-*]|\d+\.) +(?:(?!\*\*(?:élevé|moyen|faible)\*\* *:)|(?![^\n]*`[^`\n]*(?:/|\.[A-Za-z][A-Za-z0-9]{0,5}\b|\b(?:Dockerfile|Makefile|Procfile)\b)[^`\n]*`))'
flags: m
match: not_contains
---

CA8 : chaque risque de « Dette et risques » (élément de liste en début de ligne) commence par un niveau, exactement « **élevé** », « **moyen** » ou « **faible** » comme dans le modèle de la skill, et cite au moins un fichier du projet entre accents graves (chemin avec `/`, nom avec extension, ou `Dockerfile`, `Makefile`, `Procfile`). Un renvoi à une autre section, une version (`3.13.9`) ou une commande (`npm run start:dev`) ne comptent pas comme fichier. Remplace un juge `llm` bruité sur ce long livrable (série r17, 16 000 caractères) ; la vérification se fait ligne à ligne, un risque rédigé sur plusieurs lignes n'est vu que par sa première.
