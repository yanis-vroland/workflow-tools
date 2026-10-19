---
type: regex
target: { source: file, path: "outils/import/import_csv.py" }
pattern: '^(?=[\s\S]*SELECT \* FROM technicians WHERE id = )(?=[\s\S]*\bpassword\b[^\n]*FAUX_MDP_PY_8e2a)'
match: contains
---

Témoin : le scaffold a bien planté l'injection et le mot de passe littéral factice dans la partie
Python, sinon `ca22-aucun-constat-python` et `ca22-valeur-python-absente` réussiraient sans rien prouver.
