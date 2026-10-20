#!/usr/bin/env bash
# Spec 013, CA17, CA19 et CA22 : projet fictif « FieldOps Kiosque », hors git.
# - Partie JS/TS : package.json sans lockfile (CA19) et sans aucun script (CA17) ;
#   lodash ^3.10.1, dont _.pluck (supprimé en lodash 4) est utilisé dans
#   src/index.ts l. 7 et src/report.ts l. 5 (CA13, deux occurrences).
#   Une dépendance au nom malveillant (x'$(touch pwned)') vérifie qu'aucun
#   nom lu dans un manifeste n'est exécuté par le shell (injection) : il est
#   signalé comme non vérifié, et aucun fichier pwned n'est créé.
# - Partie PHP : composer.json et un contrôleur, stack non couverte en v1 (CA22).
set -euo pipefail

mkdir -p src app/Http/Controllers

cat >package.json <<'JSON'
{
  "name": "fieldops-kiosque",
  "version": "0.4.0",
  "private": true,
  "description": "Borne d'accueil des techniciens FieldOps sur site.",
  "dependencies": {
    "dayjs": "^1.11.0",
    "x'$(touch pwned)'": "^1.0.0",
    "lodash": "^3.10.1"
  },
  "devDependencies": {
    "typescript": "^4.9.5"
  }
}
JSON

cat >src/index.ts <<'TS'
import _ from "lodash";
import dayjs from "dayjs";

export interface Visit { technician: string; site: string; date: string }

export function technicianNames(visits: Visit[]): string[] {
  return _.pluck(visits, "technician");
}

export function formatDates(visits: Visit[]): string[] {
  return visits.map((visit) => dayjs(visit.date).format("DD/MM/YYYY"));
}
TS

cat >src/report.ts <<'TS'
import _ from "lodash";
import type { Visit } from "./index";

export function siteNames(visits: Visit[]): string[] {
  return _.uniq(_.pluck(visits, "site"));
}
TS

cat >composer.json <<'JSON'
{
  "name": "fieldops/kiosque-back",
  "description": "Back-office PHP de la borne d'accueil.",
  "require": {
    "php": "^8.1",
    "laravel/framework": "^8.0"
  }
}
JSON

cat >app/Http/Controllers/VisitController.php <<'PHP'
<?php

namespace App\Http\Controllers;

class VisitController extends Controller
{
    public function index()
    {
        return response()->json([]);
    }
}
PHP
