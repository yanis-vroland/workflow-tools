---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Synthèse *$[\s\S]*^#{1,6} +(\d+\.? +)?Périmètre chiffré *$[\s\S]*^#{1,6} +(\d+\.? +)?Détail par lot *$[\s\S]*^#{1,6} +(\d+\.? +)?Activités transverses *$[\s\S]*^#{1,6} +(\d+\.? +)?Hypothèses *$[\s\S]*^#{1,6} +(\d+\.? +)?Exclusions *$[\s\S]*^#{1,6} +(\d+\.? +)?Risques *$[\s\S]*^#{1,6} +(\d+\.? +)?Points non déterminés *$'
flags: m
match: contains
---

005-CA2 : les huit sections contractuelles sont des titres Markdown portant exactement les noms de la spec, dans l'ordre de la spec.
