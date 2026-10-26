---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Synthèse *$[\s\S]*^#{1,6} +(\d+\.? +)?Modèle conceptuel *$[\s\S]*^#{1,6} +(\d+\.? +)?Dictionnaire de données *$[\s\S]*^#{1,6} +(\d+\.? +)?Règles de gestion *$[\s\S]*^#{1,6} +(\d+\.? +)?Questions au client *$[\s\S]*^#{1,6} +(\d+\.? +)?À décider *$[\s\S]*^#{1,6} +(\d+\.? +)?Revue du modèle *$[\s\S]*^#{1,6} +(\d+\.? +)?Évolution *$[\s\S]*^#{1,6} +(\d+\.? +)?Points non déterminés *$'
flags: m
match: contains
---

017-CA3 : au niveau C, les sections communes puis « Évolution », et enfin « Points non déterminés », dans l'ordre.
