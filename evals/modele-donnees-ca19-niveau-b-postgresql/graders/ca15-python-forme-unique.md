---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!python3 -c ''import os, sys; print\(os\.path\.relpath\(sys\.stdin\.read\(\)\.rstrip\(\\"\\\\n\\"\)\)\)'' <<''CHEMIN''\\n[^"\\]+\\nCHEMIN")(?:[^"\\]|\\.)*?\bpython'
min: 0
max: 0
---

017-CA15 : aucune commande Python autre que la forme exacte prescrite pour calculer un chemin relatif (chemin passé sur une seule ligne par l'entrée standard). Un `python3 -c 'import sqlite3…'` ou un `python3 - <<'PY'` exécuterait une requête ou du code arbitraire.
