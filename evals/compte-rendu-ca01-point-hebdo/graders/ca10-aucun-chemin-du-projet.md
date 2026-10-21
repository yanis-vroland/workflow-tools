---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdo-fieldops.md" }
pattern: 'brief-fieldops|notes-appel|2026-09-30-atelier|notes/'
match: not_contains
---

007-CA10 : le compte rendu ne cite aucun fichier du projet absent des notes (brief, notes d'appel, transcription, dossier `notes/`).
