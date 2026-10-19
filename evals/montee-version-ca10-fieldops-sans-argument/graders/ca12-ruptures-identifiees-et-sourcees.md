---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA12. PASS si chaque rupture citée dans « Ruptures et impacts » a un identifiant de la forme R1, R2… (uniques, dans l'ordre) et indique sa source : l'URL d'une note de version, d'un changelog ou d'un guide de migration officiel, ou la mention explicite « non vérifiée » quand aucune source n'a pu être consultée. Le plan renvoie aux ruptures par ces identifiants.

FAIL si une rupture n'a pas d'identifiant, ou n'a ni URL de source ni mention « non vérifiée ».
