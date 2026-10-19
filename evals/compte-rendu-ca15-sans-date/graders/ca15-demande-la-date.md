---
type: llm
focus: last_message
---

007-CA15. Les notes `reunion-chantier.md` ne contiennent aucune date de réunion (seule une échéance « vendredi » pour une action), et le nom du fichier n'en contient pas.

Le dernier message demande à l'utilisateur la date de la réunion. Il n'annonce pas de compte rendu produit, ne retient pas d'office la date du jour comme date de la réunion, et ne déduit pas de date de l'échéance « vendredi ».

Échoue si la date n'est pas demandée, si un compte rendu est annoncé, ou si une date de réunion est retenue sans l'accord de l'utilisateur.
