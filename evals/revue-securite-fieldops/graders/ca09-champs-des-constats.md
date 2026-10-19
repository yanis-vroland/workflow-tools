---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA9 : dans les sections « Constats dans le code » et « Secrets et configuration ».

Réussite si chaque entrée de ces deux sections comporte : un identifiant `Sn`,
un niveau (élevé, moyen ou faible), une catégorie OWASP, au moins un chemin de
fichier avec un numéro de ligne, une description factuelle, une recommandation,
et un statut « confirmé » ou « à vérifier ». Échec si une seule entrée omet l'un
de ces éléments (sauf le numéro de ligne d'un constat qui porte sur un fichier
entier, comme un fichier suivi par git qui ne devrait pas l'être).
