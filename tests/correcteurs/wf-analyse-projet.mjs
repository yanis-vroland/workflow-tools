#!/usr/bin/env node
// Vérifie les motifs des correcteurs des evals de wf-analyse-projet
// (evals/analyse-projet/) sur des exemples positifs et négatifs, sans modèle.
//
// Chaque motif est lu dans le fichier du correcteur (frontmatter YAML) et compilé
// comme le fait `claude plugin eval` : `new RegExp(input_match)` sur l'entrée de
// l'outil sérialisée en JSON (correcteurs tool_used), `new RegExp(pattern, flags)`
// sur le texte visé (correcteurs regex). Un correcteur qui ne compile pas, qui
// rate un positif ou qui attrape un négatif fait échouer le script (code 1).
//
// Usage : node tests/correcteurs/wf-analyse-projet.mjs

import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals", "analyse-projet");

// Lit les clés simples du frontmatter (valeurs entre apostrophes YAML, '' = ')
function grader(relative) {
  const text = readFileSync(join(evals, relative), "utf8");
  const front = text.split(/^---$/m)[1] ?? "";
  const fields = {};
  for (const line of front.split("\n")) {
    const m = /^(\w+):\s*(.*)$/.exec(line);
    if (!m) continue;
    let value = m[2].trim();
    if (value.startsWith("'") && value.endsWith("'")) value = value.slice(1, -1).replace(/''/g, "'");
    fields[m[1]] = value;
  }
  return fields;
}

const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const grep = (input) => JSON.stringify({ pattern: "TODO", ...input });
const text = (t) => t;

// Livrables minimaux pour les correcteurs regex sur le livrable
const doc = (header, sections = {}) =>
  [
    "# Analyse du projet",
    "",
    header,
    "",
    ...[
      "Synthèse",
      "Stack et dépendances",
      "Architecture",
      "Activité du dépôt",
      "Qualité et tests",
      "Sécurité",
      "Dette et risques",
      "Effort de reprise",
      "Points non déterminés",
    ].flatMap((s) => [`## ${s}`, "", sections[s] ?? "Contenu.", ""]),
  ].join("\n");

const suites = [
  {
    file: "nominal/graders/ca1-ni-installation-ni-execution.md",
    input: bash,
    positive: [
      "npm install",
      "npm i",
      "cd mobile && flutter pub get",
      "fvm flutter test",
      "timeout 60 npm test",
      "env CI=1 npm test",
      "CI=1 npm run build",
      "sudo npm install",
      'bash -c "npm test"',
      "sh -c 'yarn test'",
      "{ npm test; }",
      "echo `npm test`",
      "echo $(npm test)",
      "ls | xargs npm install",
      "xargs -n 1 npm install < deps.txt",
      "yarn",
      "cd web && yarn",
      "yarn install --frozen-lockfile",
      "pnpm add lodash",
      "pnpm i",
      "node src/api/server.js",
      "tsx src/scripts/seed.ts",
      "npx vitest run",
      "echo ok; vitest run",
      "git status\nnpm ci",
      "if true; then npm test; fi",
      "docker compose up -d",
      "docker-compose -f docker-compose.yml build",
      "dart run build_runner build",
      "nohup npm start &",
      "npm --prefix mobile install",
      "./gradlew build",
      "bash scripts/deploy.sh",
      "python3 manage.py migrate",
      "vite",
      "tsc",
    ],
    negative: [
      "for f in lib/*.dart test/*.dart; do cat $f; done",
      'for p in vite vitest; do curl -sf "https://registry.npmjs.org/$p/latest"; done',
      "npm view react version",
      "npm outdated --json",
      "npm info express",
      "yarn info react version",
      "pnpm view react",
      "node --version",
      'node -e "console.log(1)"',
      "curl -sf https://pub.dev/api/packages/http",
      'grep -r "npm install" README.md',
      'grep -n "vitest" package.json',
      'grep -E "react|vite|vitest" package.json',
      "grep -E '\"(react|yarn)\"' package.json",
      'echo "run npm test to check"',
      "cat package.json",
      "git log --format=%ad --date=short HEAD",
      "ls node_modules/.bin/vitest",
      "cat vite.config.ts",
      'rg "docker compose up" -n',
      'find . -name "*.test.ts"',
      "wc -l src/**/*.ts",
      "cat docs/yarn.md",
      "tsc --noEmit",
      "python3 -c 'import json'",
    ],
  },
  {
    file: "nominal/graders/ca1-aucune-modification-par-bash.md",
    input: bash,
    positive: [
      "sed -i '' 's/a/b/' src/app.ts",
      "sed -i.bak 's/a/b/' src/app.ts",
      "sed --in-place 's/a/b/' src/app.ts",
      "perl -pi -e 's/a/b/' src/app.ts",
      "echo x | tee src/app.ts",
      "echo x | tee -a README.md",
      "echo x > src/app.ts",
      "echo x >> README.md",
      'git log > "$TMPDIR/log.txt"',
      "sort -rn > /tmp/hot.txt",
      "rm src/app.ts",
      "cd src && mv a.ts b.ts",
      "touch package.json",
      "cp README.md README.old",
    ],
    negative: [
      "ls 2>/dev/null",
      "git log 2>&1 | head",
      "echo erreur >&2",
      "cat package.json > /dev/null",
      "cat > docs/wf/analyse-projet.md",
      "sed -n '1,20p' src/app.ts",
      "sed 's|^\\./||' liste.txt",
      "grep -c '=>' src/app.ts",
      "awk '$1 > 1' counts.txt",
      "grep -o '<title>' src/web/index.html",
      "git rm --cached x",
      "echo x | tee /dev/null",
      "mkdir -p docs/wf",
      "grep -rn 'committee' docs",
    ],
  },
  {
    file: "nominal/graders/ca1-aucune-operation-git-modifiante.md",
    input: bash,
    positive: [
      "git add .",
      "git commit -m x",
      "git -C mobile checkout main",
      "git -c core.quotepath=off -C . stash",
      "git --no-pager reset --hard",
      "git tag v2.0.0",
      "git tag -d v1.0.0",
      "git branch -D feat/x",
      "git branch nouvelle-branche",
      "git config user.name x",
      "git config --local core.worktree ..",
      "git fetch origin",
      "git sparse-checkout set src",
    ],
    negative: [
      "git log --oneline",
      "git -C mobile log -1",
      "git -c core.quotepath=off status --porcelain -- .",
      "git tag",
      "git tag -l",
      "git tag --sort=-creatordate | head",
      "git branch --show-current",
      "git branch -a",
      "git config --get remote.origin.url",
      "git rev-parse --is-inside-work-tree",
      "git ls-files -- .",
      "git shortlog -sn HEAD",
    ],
  },
  {
    file: "nominal/graders/ca3-registre-npm-interroge.md",
    input: bash,
    positive: [
      'curl -sf --max-time 10 "https://registry.npmjs.org/react/latest"',
      'for p in react express; do curl -sf "https://registry.npmjs.org/$p/latest"; done',
      "npm view react version",
      "npm --json outdated",
      "npm show express version",
    ],
    negative: [
      "grep -o 'https://registry.npmjs.org/[^\"]*' package-lock.json",
      "cat package-lock.json",
      "grep registry.npmjs.org package-lock.json | head",
      "curl -sf https://pub.dev/api/packages/http",
    ],
  },
  {
    file: "nominal/graders/ca3-registre-pub-dev-interroge.md",
    input: bash,
    positive: [
      'curl -sf --max-time 10 "https://pub.dev/api/packages/http"',
      'for p in http; do curl -sf "https://pub.dev/api/packages/$p"; done',
    ],
    negative: ["cat mobile/pubspec.lock", "grep -n 'pub.dev' mobile/pubspec.lock", "curl -sf https://registry.npmjs.org/react/latest"],
  },
  {
    file: "nominal/graders/ca10-fichier-env-non-lu-grep.md",
    input: grep,
    positive: [
      { path: "/projet/.env" },
      { path: ".env.local" },
      { path: "/projet/config/.env.production" },
      { glob: ".env*" },
      { glob: "**/.env.local" },
      { glob: "*.env" },
      { glob: ".env" },
      { glob: "**/.env" },
      { glob: "{.env,src/**}" },
      { path: "/home/cwd/.env.local", glob: "*" },
    ],
    negative: [
      { path: "/home/cwd", glob: "!{.env*,package-lock.json,.git/**}" },
      { glob: "!{.env*,x}" },
      { glob: "!.env" },
      { glob: ".env.example" },
      { path: "/projet/.env.example" },
      { path: "/projet/src" },
      { glob: "!.env*" },
      { glob: "*.ts" },
      { path: "/projet/src/environment.ts" },
      { glob: "*.environment.ts" },
    ],
  },
  {
    file: "nominal/graders/ca10-fichier-env-non-lu-bash.md",
    input: bash,
    positive: [
      "cat .env",
      "cat ./.env",
      "head -5 .env.local",
      "grep DATABASE_URL .env",
      'grep -n KEY ".env"',
      "source .env.production",
      "cat config/.env",
      "ls -la .env",
    ],
    negative: [
      "cat .env.example",
      'grep -rn "process.env" src',
      "rg TODO --glob '!.env*'",
      "grep -r TODO --exclude='.env*' .",
      "grep -r TODO --exclude=.env* .",
      "find . -type f -not -name '.env*'",
      "cat .envrc.example.md",
      "cat src/environment.ts",
    ],
  },
  {
    file: "ca4-registre-injoignable/graders/ca4-temoin-echec-reseau.md",
    input: text,
    positive: [
      '{"type":"tool_result","content":"npm react injoignable (curl 7)\\nnpm express injoignable (curl 7)"}',
      '{"type":"tool_result","content":"curl: (6) Could not resolve host: registry.npmjs.org"}',
      '{"type":"tool_result","content":"pub http injoignable (curl 56)"}',
    ],
    negative: [
      '{"type":"tool_use","input":{"command":"*) echo \\"npm $p injoignable (curl $rc)\\" ;;"}}',
      '{"type":"tool_result","content":"npm react \\"version\\":\\"19.2.0\\""}',
      "Le registre est injoignable : repli sur le lockfile.",
    ],
  },
  {
    file: "nominal/graders/ca6-dernier-commit.md",
    input: text,
    positive: [doc("En-tête", { "Activité du dépôt": "- Premier commit : 2025-08-04 · dernier commit : 2026-09-29." })],
    negative: [
      doc("En-tête", { "Activité du dépôt": "- Premier commit : 2025-08-04 · dernier commit : 2026-09-30." }),
      doc("En-tête", { "Activité du dépôt": "- dernier commit : 30 septembre 2026." }),
    ],
  },
  {
    file: "nominal/graders/ca8-niveau-du-point-chaud.md",
    input: text,
    positive: [
      doc("En-tête", { "Dette et risques": "- **élevé** : point chaud non testé (`src/api/routes/interventions.ts`)." }),
      doc("En-tête", { "Dette et risques": "- `src/api/routes/interventions.ts` : risque moyen." }),
    ],
    negative: [
      doc("En-tête", {
        "Dette et risques":
          "- Point chaud sans niveau (`src/api/routes/interventions.ts`).\n- **élevé** : autre risque (`src/domain/scheduling.ts`).",
      }),
    ],
  },
  {
    file: "nominal/graders/ca17-sous-section-web.md",
    input: text,
    positive: [
      doc("En-tête", { Architecture: "### Application web (racine)\n\nTexte." }),
      doc("En-tête", { Architecture: "### Back-office React\n\nTexte." }),
    ],
    negative: [doc("En-tête", { Architecture: "### Client d'API de l'application mobile\n\nTexte." })],
  },
  {
    file: "ca20-sous-dossier/graders/ca20-en-tete-commit.md",
    input: text,
    positive: [
      doc("Outil : wf-analyse-projet · Date : 2026-10-11 · Commit analysé : 3277c5e · Sous-dossier : `app/`"),
      doc("Outil : wf-analyse-projet · Date : 2026-10-11 · **Commit analysé** : `1234567`"),
    ],
    negative: [doc("Outil : wf-analyse-projet · Date : 2026-10-11 · Commit analysé : hors git")],
  },
  {
    file: "ca20-sous-dossier/graders/ca20-en-tete-sous-dossier.md",
    input: text,
    positive: [doc("Outil : wf-analyse-projet · Date : 2026-10-11 · Commit analysé : 3277c5e · Sous-dossier : `app/`")],
    negative: [doc("Outil : wf-analyse-projet · Date : 2026-10-11 · Commit analysé : 3277c5e", { Synthèse: "Sous-dossier." })],
  },
  {
    file: "ca20-sous-dossier/graders/ca20-activite-sans-commit-hors-sous-dossier.md",
    input: text,
    positive: [doc("En-tête", { "Activité du dépôt": "- dernier commit : 2026-10-06." })],
    negative: [doc("Date : 2026-10-06", { "Activité du dépôt": "- dernier commit : 2026-09-29." })],
  },
];

// Les commandes que la skill prescrit (blocs ```bash de SKILL.md) ne doivent
// déclencher aucun correcteur d'interdiction : sinon une exécution conforme à la
// skill échouerait.
const skill = readFileSync(join(root, "skills", "wf-analyse-projet", "SKILL.md"), "utf8");
const skillCommands = [...skill.matchAll(/^```bash\n([\s\S]*?)^```$/gm)].map((m) => m[1].trimEnd());
for (const file of [
  "nominal/graders/ca1-ni-installation-ni-execution.md",
  "nominal/graders/ca1-aucune-modification-par-bash.md",
  "nominal/graders/ca1-aucune-operation-git-modifiante.md",
  "nominal/graders/ca10-fichier-env-non-lu-bash.md",
]) {
  suites.push({ file, input: bash, positive: [], negative: skillCommands, label: "commandes de la skill" });
}
// À l'inverse, les registres sont interrogés par une commande de la skill
for (const file of ["nominal/graders/ca3-registre-npm-interroge.md", "nominal/graders/ca3-registre-pub-dev-interroge.md"]) {
  suites.push({ file, input: bash, positive: [skillCommands.join("\n")], negative: [], label: "commandes de la skill" });
}

let failures = 0;
for (const suite of suites) {
  const g = grader(suite.file);
  const source = g.input_match ?? g.pattern;
  let re;
  try {
    re = new RegExp(source, g.input_match ? "" : (g.flags ?? ""));
  } catch (error) {
    console.log(`ÉCHEC  ${suite.file} : motif invalide (${error.message})`);
    failures++;
    continue;
  }
  const errors = [];
  for (const example of suite.positive) {
    if (!re.test(suite.input(example))) errors.push(`positif non détecté : ${JSON.stringify(example)}`);
  }
  for (const example of suite.negative) {
    if (re.test(suite.input(example))) errors.push(`négatif détecté : ${JSON.stringify(example)}`);
  }
  if (errors.length > 0) {
    failures++;
    console.log(`ÉCHEC  ${suite.file}${suite.label ? ` (${suite.label})` : ""}`);
    for (const e of errors) console.log(`         ${e}`);
  } else {
    const counts = suite.label
      ? `${suite.positive.length + suite.negative.length} ${suite.label}`
      : `${suite.positive.length} positifs, ${suite.negative.length} négatifs`;
    console.log(`OK     ${suite.file} (${counts})`);
  }
}
process.exit(failures === 0 ? 0 : 1);
