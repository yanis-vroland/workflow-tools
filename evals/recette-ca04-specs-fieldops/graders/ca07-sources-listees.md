---
type: llm
focus: { source: file, path: "docs/wf/recette.md" }
---

CA7 : « Périmètre et sources » liste chaque source lue, avec son chemin.

Réussite si cette section cite, avec leur chemin relatif, les trois specs
`docs/specs/001-interventions.md`, `docs/specs/002-ordres-de-travail.md` et
`docs/specs/003-export-pdf.md`, et le code lu (au moins des chemins ou dossiers
sous `src/`, et `mobile/` ou des fichiers sous `mobile/lib/`). Elle ne doit pas
présenter `docs/wf/specs-tickets.md` comme une source lue (il n'existe pas ; le
dire absent est permis). Échec si une spec manque ou si le code lu n'est pas cité.
