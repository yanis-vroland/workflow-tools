---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA6. Le projet déclare Node.js 18 (fin de support publiée par endoflife.date : 2025-04-30, donc passée) et Flutter 3.13.9 (endoflife.date ne publie pas de calendrier pour Flutter).

PASS si toutes ces conditions sont réunies :
1. « Inventaire des versions » indique pour Node.js 18 une date de fin de support, ou « non déterminé » ; s'il donne une date, c'est 2025-04-30.
2. Si une date de fin de support passée est indiquée pour Node.js 18, « Synthèse » signale que cette version n'est plus supportée.
3. Pour Flutter (ou le SDK Dart), la date de fin de support est « non déterminé » (ou équivalent : non publiée, non déterminée), jamais une date inventée.

FAIL si une date de fin de support est affirmée sans être 2025-04-30 pour Node.js 18, si une date est inventée pour Flutter, ou si une fin de support passée n'est pas reprise dans « Synthèse ».
