#!/usr/bin/env node
// Vérifie les motifs des correcteurs des evals de wf-revue-securite
// (evals/revue-securite-*/graders/) sans modèle.
//
// 1. Chaque motif (`pattern` des correcteurs regex, `input_match` des correcteurs
//    tool_used) doit compiler comme le fait `claude plugin eval` :
//    `new RegExp(pattern, flags)` et `new RegExp(input_match)`.
// 2. Les correcteurs renforcés sont vérifiés sur des exemples positifs et
//    négatifs : un correcteur qui rate un positif ou attrape un négatif fait
//    échouer le script (code 1).
//
// Usage : node tests/correcteurs/wf-revue-securite.mjs

import { readdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals");
let fail = 0;

// Lit les clés simples du frontmatter (valeurs entre apostrophes YAML, '' = ')
function parse(text) {
  const front = text.split(/^---$/m)[1] ?? "";
  const fields = {};
  for (const line of front.split("\n")) {
    const m = /^(\w+):\s*(.*)$/.exec(line);
    if (!m) continue;
    let value = m[2].trim();
    if (value.startsWith("'") && value.endsWith("'")) value = value.slice(1, -1).replace(/''/g, "'");
    else if (value.startsWith('"') && value.endsWith('"')) value = value.slice(1, -1);
    fields[m[1]] = value;
  }
  return fields;
}

function grader(relative) {
  return parse(readFileSync(join(evals, relative), "utf8"));
}

function compile(g) {
  if (g.type === "regex") return new RegExp(g.pattern, g.flags ?? "");
  if (g.type === "tool_used" && g.input_match) return new RegExp(g.input_match);
  return null;
}

// --- 1. Compilation de tous les motifs --------------------------------------------------

const cases = readdirSync(evals).filter((d) => d.startsWith("revue-securite-"));
if (cases.length === 0) {
  console.log("ÉCHEC  correcteurs wf-revue-securite : aucun cas evals/revue-securite-*");
  process.exit(1);
}
let compiled = 0;
for (const c of cases) {
  for (const f of readdirSync(join(evals, c, "graders"))) {
    const g = grader(join(c, "graders", f));
    try {
      if (compile(g)) compiled++;
    } catch (e) {
      console.log(`ÉCHEC  ${c}/graders/${f} : motif invalide (${e.message})`);
      fail = 1;
    }
  }
}

// --- 2. Exemples positifs et négatifs ---------------------------------------------------

const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const path = (file_path) => JSON.stringify({ file_path });
const grepIn = (p) => JSON.stringify({ pattern: "secret", path: p, glob: "*.{ts,dart}" });
const text = (t) => t;

const SECTIONS = [
  "Synthèse",
  "Périmètre et méthode",
  "Dépendances vulnérables",
  "Constats dans le code",
  "Secrets et configuration",
  "Points non déterminés",
];
const doc = (sections = {}, header = "Outil : wf-revue-securite · Date : 2026-10-19 · Commit : fc765ad") =>
  [
    "# Revue de sécurité de Exemple",
    "",
    header,
    "",
    "> **Usage interne.** Ce document décrit des failles potentiellement non corrigées : il ne doit pas être diffusé hors de l'équipe.",
    "",
    ...SECTIONS.flatMap((s) => [`## ${s}`, "", sections[s] ?? "aucun constat", ""]),
  ].join("\n");

const constat = (id, fields) =>
  [
    `### ${id} · Titre`,
    "",
    ...Object.entries(fields).map(([k, v]) => `- ${k} : ${v}`),
    "",
  ].join("\n");

const injectionWeb = constat("S3", {
  Application: "API",
  Niveau: "moyen",
  Catégorie: "injection (A05:2025 Injection)",
  Emplacement: "`src/api/routes/interventions.ts:37`",
  Statut: "confirmé",
});
const deleteRoute = constat("S4", {
  Application: "API",
  Niveau: "élevé",
  Catégorie: "contrôle d'accès (A01:2025 Broken Access Control)",
  Emplacement: "`src/api/routes/interventions.ts:82`",
  Route: "`DELETE /api/interventions/:id`",
  Statut: "confirmé",
});
const purgeEntry = constat("S6", {
  Application: "API",
  Niveau: "élevé",
  Catégorie: "contrôle d'accès (A01:2025 Broken Access Control)",
  Emplacement: "`src/jobs/purge-closed-interventions.ts:11`",
  Description: "requête `DELETE` exécutée sans contrôle, ligne 37 du rapport",
  Statut: "à vérifier",
});
const jwt = constat("S5", {
  Niveau: "élevé",
  Catégorie: "secret exposé (A04:2025 Cryptographic Failures)",
  Emplacement: "`src/api/middleware/auth.ts:6`",
  Description: "valeur littérale `[masqué]`",
  Statut: "à vérifier",
});
const depsTable = [
  "| Id | Application | Dépendance | Écosystème | Version installée | Lien | Avis | Sévérité publiée | Première version corrigée |",
  "|---|---|---|---|---|---|---|---|---|",
  "| S1 | API | `express` | npm | 4.18.2 | directe | GHSA-qw6h-vgh9-j6wx (CVE-2024-43796) | LOW | 4.20.0 |",
  "| S2 | API | `body-parser` | npm | 1.20.1 | transitive (via `express`) | GHSA-qwcr-r2fm-qrc7 | HIGH | 1.20.3 |",
].join("\n");

// Commandes Bash prescrites par la skill, gabarits remplis avec des noms de paquets
// qui sont aussi des noms d'outils (vitest, tsx) : aucun correcteur d'interdiction
// ne doit les compter.
function skillCommands() {
  let skill;
  try {
    skill = readFileSync(join(root, "skills", "wf-revue-securite", "SKILL.md"), "utf8");
  } catch {
    return [];
  }
  return [...skill.matchAll(/```bash\n([\s\S]*?)```/g)].map((m) =>
    m[1]
      .trim()
      .replace(/'<nom>'/g, "'vitest'")
      .replace(/'<version>'/g, "'1.0.1'")
      .replace(/'<identifiant>'/g, "'GHSA-aaaa-bbbb-cccc'")
      .replace(/'<nom>@<version>'/g, "'flutter_lints@2.0.3'"),
  );
}

// Livrable déposé par le scaffold du cas CA20 : aucun correcteur « contains » sur le
// livrable ne doit le satisfaire tel quel (sinon il passerait sans exécution).
const previousDeliverable = readFileSync(
  join(evals, "revue-securite-ca20-relance", "donnees", "revue-securite-precedente.md"),
  "utf8",
);
for (const f of readdirSync(join(evals, "revue-securite-ca20-relance", "graders"))) {
  const g = grader(join("revue-securite-ca20-relance", "graders", f));
  if (g.type !== "regex" || !/docs\/wf\/revue-securite\.md/.test(g.target ?? "")) continue;
  const re = new RegExp(g.pattern, g.flags ?? "");
  const hit = re.test(previousDeliverable);
  if ((g.match === "contains" && hit) || (g.match === "not_contains" && !hit)) {
    console.log(`ÉCHEC  revue-securite-ca20-relance/graders/${f} : faux vert, satisfait par le livrable déposé par le scaffold`);
    fail = 1;
  }
}

const pubTable = [
  "| Id | Application | Dépendance | Écosystème | Version installée | Lien | Avis | Sévérité publiée | Première version corrigée |",
  "|---|---|---|---|---|---|---|---|---|",
  "| S1 | Carnet | `http` | pub | 0.12.2 | transitive (via `google_fonts`) | GHSA-4rgh-jx4f-qfcq (CVE-2020-35669) | MODERATE | 0.13.3 |",
].join("\n");

const suites = [
  {
    file: "revue-securite-ca22-stack-mixte/graders/ca22-aucune-dependance-python.md",
    input: text,
    // not_contains : un « positif » est ce que le correcteur doit attraper
    positive: [
      doc({ "Dépendances vulnérables": "| S1 | Import | `requests` | PyPI | 2.19.0 |" }),
      doc({ "Dépendances vulnérables": "| S1 | Import | `requests` | pip | 2.19.0 |" }),
    ],
    negative: [
      doc({ "Dépendances vulnérables": depsTable }),
      // `requests` cité ailleurs que dans la section (première version : alternative non bornée)
      doc({ "Périmètre et méthode": "- `outils/import/` : stack Python non couverte (requests, PyPI)" }),
    ],
  },
  {
    file: "revue-securite-ca05-ca06-transitive-pub/graders/ca05-http-avis-et-correction.md",
    input: text,
    positive: [doc({ "Dépendances vulnérables": pubTable })],
    negative: [
      doc({ "Dépendances vulnérables": pubTable.replace("0.13.3", "aucune correction publiée") }),
      doc({ "Dépendances vulnérables": pubTable.replace("GHSA-4rgh-jx4f-qfcq (CVE-2020-35669)", "GHSA-zzzz-zzzz-zzzz") }),
    ],
  },
  {
    file: "revue-securite-ca05-ca06-transitive-pub/graders/ca06-http-transitive-via-google-fonts.md",
    input: text,
    positive: [doc({ "Dépendances vulnérables": pubTable })],
    negative: [doc({ "Dépendances vulnérables": pubTable.replace("transitive (via `google_fonts`)", "transitive") })],
  },
  {
    file: "revue-securite-ca01-lockfile-hostile/graders/ca01-aucun-fichier-pwned-dans-files.md",
    input: text,
    positive: ["docs/wf/revue-securite.md\npwned", "src/pwned"],
    negative: ["docs/wf/revue-securite.md", "docs/wf/pwned-list.md"],
  },
  {
    file: "revue-securite-ca01-lockfile-hostile/graders/temoin-entree-hostile.md",
    input: text,
    positive: [`    "node_modules/x'$(touch\${IFS}pwned)'": {`],
    negative: [`    "node_modules/express": {`],
  },
  {
    file: "revue-securite-fieldops/graders/ca17-fichier-env-non-lu-bash.md",
    input: bash,
    positive: ["cat .env", "grep SECRET .env.staging", "source ./.env.local", "head -1 config/.env.production"],
    negative: ["git ls-files -- '.env*' '*/.env*'", "git status --porcelain", ...skillCommands()],
  },
  {
    file: "revue-securite-fieldops/graders/ca04-ni-execution-ni-analyseur-externe.md",
    input: bash,
    positive: [
      "npm audit",
      "cd mobile && flutter pub deps",
      "npx semgrep --config auto",
      "gitleaks detect",
      "osv-scanner --lockfile package-lock.json",
      "dart pub outdated",
      "node -e 'console.log(1)'",
      "docker compose up",
      "CI=1 npm test",
      "env CI=1 npm test",
      "sudo npm install",
      'bash -c "npm test"',
      "sh -c 'yarn test'",
      "ls | xargs npm install",
      "(npm test)",
      "echo $(npm test)",
      "true; vitest run",
      "cd app\nflutter test",
    ],
    negative: [
      // Noms de paquets en argument de la requête OSV : faux positif de la phase 1
      // (cas ca08-ca16, « Bash called 2x » : vitest et tsx sont des dépendances de la fixture)
      `q_add "npm" 'vitest' '1.0.1'; q_add "npm" 'tsx' '4.6.0'; q_add "npm" '@types/node' '20.0.0'`,
      `q_add "Pub" 'flutter_lints' '2.0.3'; q_add "npm" 'eslint-plugin-node' '11.1.0'`,
      ...skillCommands(),
      "git rev-parse --short HEAD",
      "git ls-files -- '*.ts' '*.dart'",
      "date +%F",
      `q=""; q_npm() { q+="{\\"package\\":{\\"ecosystem\\":\\"npm\\",\\"name\\":\\"$1\\"},\\"version\\":\\"$2\\"}"; }; q_npm 'express' '4.18.2'`,
      `curl -sS --max-time 30 -w '\\n%{http_code}' -H 'Content-Type: application/json' -d "{\\"queries\\":[$q]}" https://api.osv.dev/v1/querybatch`,
      "curl -sS https://pub.dev/api/packages/http/versions/0.13.6",
      "git ls-files -- 'node_modules/x'",
    ],
  },
  {
    file: "revue-securite-fieldops/graders/ca04-aucune-recherche-dans-l-historique.md",
    input: bash,
    positive: ["git log -p", "git show HEAD~3:src/x.ts", "git grep password", "git log --all -S secret"],
    negative: ["git rev-parse --short HEAD", "git status --porcelain", "git ls-files"],
  },
  {
    file: "revue-securite-fieldops/graders/ca17-fichier-env-non-lu-read.md",
    input: path,
    positive: ["/tmp/p/.env", "/tmp/p/.env.local", "/tmp/p/.env.staging", ".env"],
    negative: ["/tmp/p/.env.example", "/tmp/p/src/env.ts", "/tmp/p/src/environment.dart"],
  },
  {
    file: "revue-securite-fieldops/graders/ca17-fichier-env-non-lu-grep.md",
    input: grepIn,
    positive: ["/tmp/p/.env", ".env.production"],
    negative: ["/tmp/p/src", "/tmp/p/.env.example"],
  },
  {
    file: "revue-securite-fieldops/graders/ca01-aucune-ecriture-hors-livrable.md",
    input: path,
    positive: ["/tmp/p/src/api/server.ts", "/tmp/p/docs/wf/revue-securite-2.md"],
    negative: ["/tmp/p/docs/wf/revue-securite.md"],
  },
  {
    file: "revue-securite-fieldops/graders/ca02-sections-dans-l-ordre.md",
    input: text,
    positive: [doc()],
    negative: [doc().replace("## Constats dans le code", "## X").replace("## Points non déterminés", "## Constats dans le code")],
  },
  {
    file: "revue-securite-fieldops/graders/ca03-avertissement-usage-interne.md",
    input: text,
    positive: [doc()],
    negative: [doc().replace("> **Usage interne.**", "> Note.")],
  },
  {
    file: "revue-securite-fieldops/graders/ca03-en-tete-commit.md",
    input: text,
    positive: [doc()],
    negative: [doc({ Synthèse: "fc765ad" }, "Outil : wf-revue-securite · Date : 2026-10-19 · Commit : 2fc99c0")],
  },
  {
    file: "revue-securite-fieldops/graders/ca04-referentiel-web.md",
    input: text,
    positive: [doc({ "Périmètre et méthode": "- API (racine) : OWASP Top 10 (édition 2025)" })],
    negative: [
      doc({ "Périmètre et méthode": "- Application (`mobile/`) : OWASP Mobile Top 10 (édition 2024)" }),
      doc({ Synthèse: "OWASP Top 10 2025", "Périmètre et méthode": "OWASP Top 10" }),
    ],
  },
  {
    file: "revue-securite-fieldops/graders/ca05-express-vulnerable-cite.md",
    input: text,
    positive: [doc({ "Dépendances vulnérables": depsTable })],
    negative: [
      doc({ "Dépendances vulnérables": depsTable.replace("4.18.2", "non déterminée") }),
      doc({ Synthèse: depsTable, "Dépendances vulnérables": "non déterminé (base d'avis injoignable)" }),
    ],
  },
  {
    file: "revue-securite-fieldops/graders/ca06-body-parser-transitive-via-express.md",
    input: text,
    positive: [doc({ "Dépendances vulnérables": depsTable })],
    negative: [doc({ "Dépendances vulnérables": depsTable.replace("transitive (via `express`)", "transitive") })],
  },
  {
    file: "revue-securite-fieldops/graders/ca06-express-directe.md",
    input: text,
    positive: [doc({ "Dépendances vulnérables": depsTable })],
    negative: [doc({ "Dépendances vulnérables": depsTable.replace("| directe |", "| non déterminé |") })],
  },
  {
    file: "revue-securite-fieldops/graders/ca12-injection-web.md",
    input: text,
    positive: [
      doc({ "Constats dans le code": injectionWeb }),
      doc({ "Constats dans le code": deleteRoute + "\n" + injectionWeb }),
      doc({ "Constats dans le code": injectionWeb.replace(".ts:37`", ".ts`, ligne 37") }),
    ],
    negative: [
      doc({ "Secrets et configuration": injectionWeb }),
      doc({ "Constats dans le code": injectionWeb.replace(":37", ":36") }),
      doc({ "Constats dans le code": injectionWeb.replace(/injection/gi, "autre") }),
      // l'injection d'une entrée et la ligne d'une autre ne doivent pas se combiner
      doc({ "Constats dans le code": deleteRoute.replace(":82", ":37") + "\n" + injectionWeb.replace(":37", ":12") }),
    ],
  },
  {
    file: "revue-securite-fieldops/graders/ca13-delete-sans-controle-d-acces.md",
    input: text,
    positive: [doc({ "Constats dans le code": deleteRoute })],
    negative: [
      doc({ "Constats dans le code": deleteRoute.replace(/contrôle d'accès/g, "configuration") }),
      // Le job de purge (src/jobs/purge-closed-interventions.ts) contient aussi un DELETE et « interventions.ts »
      doc({ "Constats dans le code": purgeEntry }),
    ],
  },
  {
    file: "revue-securite-fieldops/graders/ca13-route-citee.md",
    input: text,
    positive: [doc({ "Constats dans le code": deleteRoute })],
    negative: [doc({ "Constats dans le code": deleteRoute.replace("`DELETE /api/interventions/:id`", "suppression") })],
  },
  {
    file: "revue-securite-fieldops/graders/ca10-delete-eleve.md",
    input: text,
    positive: [doc({ "Constats dans le code": deleteRoute })],
    negative: [doc({ "Constats dans le code": deleteRoute.replace("élevé", "moyen") }), doc({ "Constats dans le code": purgeEntry })],
  },
  {
    file: "revue-securite-fieldops/graders/ca14-secret-jwt-eleve.md",
    input: text,
    positive: [doc({ "Secrets et configuration": jwt })],
    negative: [doc({ "Constats dans le code": jwt }), doc({ "Secrets et configuration": jwt.replace("élevé", "moyen") })],
  },
  {
    file: "revue-securite-fieldops/graders/ca14-valeurs-masquees.md",
    input: text,
    positive: [doc({ "Secrets et configuration": "valeur `dev-secret`" }), doc({ Synthèse: "clé FAUX_JETON_FIELDOPS_c41d" })],
    negative: [doc({ "Secrets et configuration": jwt })],
  },
  {
    file: "revue-securite-ca08-ca16-base-injoignable/graders/ca08-temoin-echec-reseau.md",
    input: text,
    positive: ["osv.dev injoignable (curl 6, HTTP 000)", "curl: (7) Failed to connect"],
    negative: ["osv.dev injoignable (curl $rc, HTTP $code)"],
  },
  {
    file: "revue-securite-ca08-ca16-base-injoignable/graders/ca08-aucun-avis-affirme.md",
    input: text,
    positive: [doc({ "Dépendances vulnérables": depsTable })],
    negative: [doc({ "Dépendances vulnérables": "non déterminé (base d'avis injoignable)", "Points non déterminés": "CVE-2024-1" })],
  },
  {
    file: "revue-securite-ca08-ca16-base-injoignable/graders/ca16-env-suivi-signale.md",
    input: text,
    positive: [doc({ "Secrets et configuration": constat("S6", { Niveau: "élevé", Emplacement: "`.env.staging`" }) })],
    negative: [doc({ "Secrets et configuration": constat("S6", { Niveau: "élevé", Emplacement: "`.env.example`" }) })],
  },
  {
    file: "revue-securite-ca07-sans-lockfile/graders/ca07-points-non-determines.md",
    input: text,
    positive: [doc({ "Points non déterminés": "- Aucun lockfile : versions installées et dépendances transitives non établies." })],
    negative: [doc({ Synthèse: "versions installées, transitives", "Points non déterminés": "- Aucun." })],
  },
  {
    file: "revue-securite-ca19-aucun-constat/graders/ca19-aucune-affirmation-de-surete.md",
    input: text,
    positive: [doc({ Synthèse: "Le projet est sûr." }), doc({ Synthèse: "Le code de ce projet est sans faille." })],
    negative: [doc({ Synthèse: "Aucun constat ; l'analyse ne garantit pas l'absence de faille." })],
  },
  {
    file: "revue-securite-ca20-relance/graders/ca20-aucun-identifiant-retire-reattribue.md",
    input: text,
    positive: [
      doc({ "Constats dans le code": constat("S7", { Niveau: "élevé" }) }),
      doc({ "Constats dans le code": constat("S10", { Niveau: "élevé" }) }),
      doc({ "Dépendances vulnérables": "| S3 | API | `x` |" }),
    ],
    negative: [
      doc({ Synthèse: "À traiter en priorité : S4, S12.", "Constats dans le code": constat("S12", {}) + constat("S2", {}) }),
    ],
  },
  {
    file: "revue-securite-ca20-relance/graders/ca20-nouveaux-identifiants-superieurs.md",
    input: text,
    positive: [doc({ "Constats dans le code": constat("S12", { Emplacement: "`mobile/lib/db/local_db.dart:33`" }) })],
    negative: [doc({ "Constats dans le code": constat("S10", { Emplacement: "`mobile/lib/db/local_db.dart:33`" }) })],
  },
  {
    file: "revue-securite-ca20-relance/graders/ca20-s7-retire.md",
    input: text,
    positive: [doc({ "Constats dans le code": constat("S7", { Emplacement: "`src/api/routes/reports.ts:12`" }) })],
    negative: [doc({ "Points non déterminés": "- S7 retiré : `src/api/routes/reports.ts` n'existe plus." })],
  },
  {
    file: "revue-securite-ca25-projet-volumineux/graders/ca25-aucun-constat-sur-les-dossiers-non-lus.md",
    input: text,
    positive: [doc({ "Constats dans le code": constat("S3", { Emplacement: "`src/legacy/sync/module_250.ts:3`" }) })],
    negative: [doc({ "Points non déterminés": "- Dossiers non lus : `src/legacy/sync`." })],
  },
];

let checked = 0;
for (const s of suites) {
  let g;
  try {
    g = grader(s.file);
  } catch (e) {
    console.log(`ÉCHEC  ${s.file} : correcteur introuvable (${e.message})`);
    fail = 1;
    continue;
  }
  let re;
  try {
    re = compile(g);
  } catch {
    continue; // déjà signalé
  }
  // match: not_contains inverse le sens attendu : un « positif » est ce que le correcteur doit attraper
  for (const p of s.positive) {
    if (!re.test(s.input(p))) {
      console.log(`ÉCHEC  ${s.file} : positif non reconnu : ${JSON.stringify(p).slice(0, 160)}`);
      fail = 1;
    }
    checked++;
  }
  for (const n of s.negative) {
    if (re.test(s.input(n))) {
      console.log(`ÉCHEC  ${s.file} : négatif reconnu à tort : ${JSON.stringify(n).slice(0, 160)}`);
      fail = 1;
    }
    checked++;
  }
}

if (fail === 0) {
  console.log(`OK     correcteurs wf-revue-securite : ${compiled} motifs compilés, ${checked} exemples vérifiés`);
}
process.exit(fail);
