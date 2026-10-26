---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA27. `react` (et `react-dom`) est installé en 17.0.2 dans `apps/web` et en 18.2.0 dans `apps/admin` (`pnpm-lock.yaml`). `dayjs` est à la même version dans les deux. PASS si « Inventaire des versions » signale explicitement que `react` est présent à des versions différentes selon l'application, en citant les deux versions et les deux applications, et ne signale pas `dayjs` comme divergent. FAIL sinon.
