---
type: llm
focus: { source: file, path: "docs/wf/audit-web.md" }
---

CA4 et CA5 : format des constats.

PASS si toutes les affirmations suivantes sont vraies :
1. Chaque constat porte un identifiant de la forme W1, W2… unique dans le document.
2. Chaque constat indique un niveau parmi « élevé », « moyen », « faible ».
3. Chaque constat cite au moins un fichier avec un numéro de ligne ; un constat qui porte sur un fichier entier
   (ex. une image trop lourde) peut citer le fichier sans ligne ; un constat issu d'une mesure peut citer l'URL
   de la page à la place.
4. Chaque constat comporte une description factuelle et une recommandation.
5. Chaque constat d'accessibilité cite le numéro d'un critère RGAA 4.1 (ex. 1.1, 11.1), éventuellement suivi
   du critère WCAG entre parenthèses.
FAIL si une seule de ces affirmations est fausse pour un constat.
