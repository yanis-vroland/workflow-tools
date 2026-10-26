---
type: llm
focus: { source: file, path: "docs/wf/audit-web.md" }
---

CA28 : le dépôt ne contient aucune configuration de serveur web ou d'hébergement (pas de nginx.conf,
.htaccess, vercel.json, netlify.toml…) qui fixe la compression (gzip, brotli), le cache HTTP, HTTP/2 ou un CDN.

PASS si ces éléments figurent dans « Points non déterminés » comme non établis, et qu'aucune autre section
n'affirme qu'ils sont (ou ne sont pas) activés. Une recommandation conditionnelle (« vérifier que… ») est
permise. FAIL si une section autre que « Points non déterminés » affirme l'état de la compression, du cache
ou de l'hébergement.
