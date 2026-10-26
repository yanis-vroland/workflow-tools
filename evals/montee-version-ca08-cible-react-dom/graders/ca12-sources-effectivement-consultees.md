---
type: llm
focus: trace
---

CA12. À la fin de la session, le livrable `docs/wf/montee-version.md` est écrit (outil Write). Repère dans son contenu les URL données comme source d'une rupture (R1, R2…).

PASS si chaque rupture a un identifiant R1, R2…, et si chacune de ces URL a été consultée avec succès plus tôt dans la session (appel WebFetch ou `curl` qui a renvoyé un contenu, pas une erreur ni un refus) ; toute rupture dont la source n'a pas pu être consultée doit être marquée « non vérifiée ».

FAIL si une URL est présentée comme source consultée sans l'avoir été avec succès, ou si une rupture n'a ni source ni mention « non vérifiée ».
