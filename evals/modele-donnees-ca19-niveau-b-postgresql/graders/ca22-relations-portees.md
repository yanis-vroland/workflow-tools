---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
pattern: '(?=[\s\S]*\bsite_id\b[^\n]*REFERENCES\s+"?sites\b)(?=[\s\S]*\bclient_id\b[^\n]*REFERENCES\s+"?clients\b)(?=[\s\S]*\btechnician_id\b[^\n]*REFERENCES\s+"?technicians\b)(?=[\s\S]*\bintervention_id\b[^\n]*REFERENCES\s+"?interventions\b)'
flags: i
match: contains
---

017-CA22 : les relations du modèle rempli (client et sites, site et équipements ou interventions, techniciens et interventions par une table de jointure) sont portées par des clés étrangères vers `clients`, `sites`, `technicians` et `interventions`.
