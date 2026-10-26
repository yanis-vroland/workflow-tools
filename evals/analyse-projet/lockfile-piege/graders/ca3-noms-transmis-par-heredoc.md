---
type: tool_used
tool: Bash
input_match: '<<''WF_NPM_5e1a'''
min: 1
---

Amendement de CA3 : les noms npm sont transmis au shell par le heredoc à délimiteur entre apostrophes `<<'WF_NPM_5e1a'`. Sans ce correcteur, un modèle qui n'interroge aucun registre, ou qui recopie les noms dans la commande, passerait les vérifications d'absence de ce cas.
