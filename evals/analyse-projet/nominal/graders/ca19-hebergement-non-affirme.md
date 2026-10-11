---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '\b(?:AWS|Amazon Web Services|Azure|Google Cloud|GCP|Heroku|Vercel|Netlify|OVH(?:cloud)?|Scaleway|Fly\.io|DigitalOcean|Clever Cloud|Railway)\b'
match: not_contains
---

CA19 : aucun hébergeur n'est affirmé ailleurs : le livrable ne nomme aucun fournisseur d'hébergement, aucun n'apparaissant dans la fixture.
