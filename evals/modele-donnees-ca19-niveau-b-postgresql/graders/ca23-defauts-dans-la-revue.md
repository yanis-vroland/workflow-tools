---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?:(?![\s\S]*défaut du schéma signalé)|[\s\S]*^### +Défauts du schéma *\n+[-*] +\S)'
flags: mi
match: contains
---

017-CA23 : un besoin sans requête signalé dans la preuve figure aussi sous « Défauts du schéma » de « Revue du modèle ».
