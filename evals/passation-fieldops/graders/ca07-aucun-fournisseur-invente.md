---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\b(?:Google Maps|Mapbox|HERE Maps|OpenStreetMap|SendGrid|Mailgun|Mailjet|Brevo|Postmark|Amazon SES|Stripe|PayPal|Adyen|Mollie|Docker Hub|GitHub Container Registry|ghcr\.io)\b'
flags: "i"
match: not_contains
---

CA7 : aucun fournisseur commercial n'est nommé alors que les fichiers n'en citent aucun.

Remplace, avec les autres correcteurs `ca07-*`, le juge `llm` `ca07-chaque-service-source`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
