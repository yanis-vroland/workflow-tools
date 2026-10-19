---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA7 : FieldOps utilise trois services tiers repérés par variables
d'environnement (`.env.example`) et par leur client dans le code : cartographie
(`src/services/mapClient.ts`), e-mail transactionnel (`src/services/mailer.ts`),
paiement (`src/services/payment.ts`).

Réussite si toutes les affirmations suivantes sont vraies dans « Services tiers
et accès » :
1. Les trois services sont listés.
2. Chaque service listé cite au moins un fichier qui établit son usage (indice).
3. Chaque service listé porte le champ « titulaire du compte : à compléter ».
4. Aucun fournisseur commercial n'est nommé sans indice dans le code (le code ne
   nomme aucun fournisseur : pas de Google Maps, Mapbox, SendGrid, Stripe…).
5. Aucune valeur de variable (URL, clé) n'est recopiée.
