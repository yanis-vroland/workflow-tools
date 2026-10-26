---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^[-*] +\**B\d{2}\**\s*:(?![^\n]*Priorité\s*:[^\n]*Source\s*:)[^\n]*$'
flags: im
match: not_contains
---

004-CA4 (source d'un PDF : nom du fichier et numéro de page). La source `cahier-des-charges.pdf` a deux pages : planification et suivi de l'état en page 1, export mensuel CSV en page 2. Remplace le juge `llm` ca04-source-pdf-avec-page (FAIL×3 sans motif exploitable, livrable non conservé). Aucune ligne de besoin sans priorité ni source (ordre du modèle : Priorité, puis Source).
