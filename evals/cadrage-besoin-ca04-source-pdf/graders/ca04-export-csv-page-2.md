---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^[-*] +\**B\d{2}\**\s*:[^\n]*(?:export|CSV)[^\n]*cahier-des-charges\.pdf, page 2(?!\d)'
flags: im
match: contains
---

004-CA4 (source d'un PDF : nom du fichier et numéro de page). La source `cahier-des-charges.pdf` a deux pages : planification et suivi de l'état en page 1, export mensuel CSV en page 2. Remplace le juge `llm` ca04-source-pdf-avec-page (FAIL×3 sans motif exploitable, livrable non conservé). Le besoin d'export CSV cite la page 2.
