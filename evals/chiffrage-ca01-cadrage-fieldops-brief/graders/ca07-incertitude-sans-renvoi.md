---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C\d{2} *\|[^|\n]*\|[^|\n]*\| *(?:0(?:,0+)? *(?:j|jours?)? *\| *(?:0,50*|1(?:,0+)?|1,50*|2(?:,0+)?|2,50*|3(?:,0+)?|3,50*|4(?:,0+)?|4,50*|5(?:,0+)?) *(?:j|jours?)?|0,50* *(?:j|jours?)? *\| *(?:1(?:,0+)?|1,50*|2(?:,0+)?|2,50*|3(?:,0+)?|3,50*|4(?:,0+)?|4,50*|5(?:,0+)?) *(?:j|jours?)?|1(?:,0+)? *(?:j|jours?)? *\| *(?:2(?:,0+)?|2,50*|3(?:,0+)?|3,50*|4(?:,0+)?|4,50*|5(?:,0+)?) *(?:j|jours?)?|1,50* *(?:j|jours?)? *\| *(?:3(?:,0+)?|3,50*|4(?:,0+)?|4,50*|5(?:,0+)?) *(?:j|jours?)?|2(?:,0+)? *(?:j|jours?)? *\| *(?:4(?:,0+)?|4,50*|5(?:,0+)?) *(?:j|jours?)?|2,50* *(?:j|jours?)? *\| *(?:5(?:,0+)?) *(?:j|jours?)?) *\|(?![^|\n]*(?:\bH\d+\b|\bQ\d{2}\b|[Rr]isque))[^|\n]*\| *$'
flags: m
match: not_contains
---

005-CA7 : aucune tâche dont l'estimation haute est au moins le double de la basse (couples énumérés sur le pas de 0,5 jour, de 0 à 5 jours) n'a un commentaire sans renvoi à l'hypothèse (`Hn`), à la question (`Qnn`) ou au risque qui cause l'incertitude. Motif généré par un script ; remplace un juge `llm` bruité sur ce long livrable (FAIL x3 sans livrable conservé pour le vérifier).
