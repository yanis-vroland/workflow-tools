#!/usr/bin/env bash
# Spec 010, CA19 : petit projet TypeScript sous git, sans dépendance, sans
# serveur, sans secret ni faille : une bibliothèque de formatage de durées.
# Aucune entrée Sn n'est attendue, et aucune base d'avis n'est à interroger.
set -euo pipefail

if [ -n "$(ls -A .)" ]; then
  echo "Le répertoire de travail de l'eval devrait être vide." >&2
  exit 1
fi

mkdir -p src

cat >package.json <<'JSON'
{
  "name": "duration-format",
  "version": "0.3.0",
  "private": true,
  "description": "Formatage des durées en heures et minutes.",
  "type": "module",
  "main": "src/duration.ts"
}
JSON

cat >src/duration.ts <<'TS'
// Formatage d'une durée exprimée en minutes, ex. 135 -> "2 h 15".

export function formatDuration(totalMinutes: number): string {
  if (!Number.isFinite(totalMinutes) || totalMinutes < 0) {
    throw new RangeError("La durée doit être un nombre positif de minutes.");
  }
  const hours = Math.floor(totalMinutes / 60);
  const minutes = Math.round(totalMinutes % 60);
  if (hours === 0) {
    return `${minutes} min`;
  }
  return minutes === 0 ? `${hours} h` : `${hours} h ${String(minutes).padStart(2, "0")}`;
}
TS

cat >README.md <<'MD'
# duration-format

Formatage des durées en heures et minutes (`src/duration.ts`).
MD

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Théo Vasseur" GIT_AUTHOR_EMAIL="theo.vasseur@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-09-15T10:00:00Z" GIT_COMMITTER_DATE="2026-09-15T10:00:00Z"
git -c core.hooksPath=/dev/null init -q -b main
git -c core.hooksPath=/dev/null add package.json src/duration.ts README.md
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat: formatage des durées"
