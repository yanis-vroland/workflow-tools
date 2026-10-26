---
type: llm
focus: trace
---

CA12. À la fin de la session, le livrable `docs/wf/montee-version.md` est écrit (outil Write). Repère dans son contenu les URL données comme source d'une rupture (R1, R2…) dans « Ruptures et impacts ».

PASS si chacune de ces URL a été consultée avec succès plus tôt dans la session (appel WebFetch ou commande `curl` sur cette URL, ou sur une page dont elle est l'adresse exacte, qui a renvoyé un contenu et non une erreur ou un refus), et si toute rupture dont la source n'a pas pu être consultée est marquée « non vérifiée ». Un livrable sans URL de source, où toutes les ruptures sont « non vérifiée », réussit.

FAIL si une URL est présentée comme source d'une rupture sans avoir été consultée avec succès (consultation refusée, en erreur, ou absente de la session) et sans la mention « non vérifiée ».
