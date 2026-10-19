#!/usr/bin/env node
// Vérifie les motifs des correcteurs des evals de wf-compte-rendu
// (evals/compte-rendu-*/graders/), sans modèle.
//
// 1. Chaque motif (`pattern` des correcteurs regex, `input_match` des correcteurs
//    tool_used) est compilé comme le fait `claude plugin eval` : un motif invalide
//    n'apparaîtrait qu'à la notation.
// 2. Les correcteurs les plus fins sont essayés sur des exemples positifs et
//    négatifs, et les commandes prescrites par la skill (blocs ```bash de SKILL.md,
//    gabarits remplis) ne doivent déclencher aucun correcteur d'interdiction.
//
// Usage : node tests/correcteurs/wf-compte-rendu.mjs

import { execFileSync } from "node:child_process";
import { readFileSync, readdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals");

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

function compile(g) {
  if (g.input_match !== undefined) return new RegExp(g.input_match);
  return new RegExp(g.pattern, g.flags ?? "");
}

let failures = 0;
const fail = (message) => {
  failures++;
  console.log(`ÉCHEC  ${message}`);
};

// --- 1. Compilation de tous les motifs ------------------------------------------

let compiled = 0;
for (const dir of readdirSync(evals).filter((d) => d.startsWith("compte-rendu-")).sort()) {
  for (const file of readdirSync(join(evals, dir, "graders")).sort()) {
    const g = grader(join(dir, "graders", file));
    if (g.pattern === undefined && g.input_match === undefined) continue;
    try {
      compile(g);
      compiled++;
    } catch (error) {
      fail(`${dir}/graders/${file} : motif invalide (${error.message})`);
    }
  }
}
console.log(`OK     ${compiled} motifs de correcteurs compilés`);

// --- 2. Exemples ---------------------------------------------------------------

const read = (file_path) => JSON.stringify({ file_path });
const write = (file_path) => JSON.stringify({ file_path, content: "# Compte rendu" });
const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const text = (t) => t;

// Commandes prescrites par la skill, gabarits remplis avec une valeur donnée
const skill = readFileSync(join(root, "skills", "wf-compte-rendu", "SKILL.md"), "utf8");
const blocks = [...skill.matchAll(/^```bash\n([\s\S]*?)^```$/gm)].map((m) => m[1].trimEnd());
const fill = (value) => blocks.map((b) => b.replace(/<[^<>\n]+>/g, value));
const fixed = ["date +%F", "git rev-parse --short HEAD", "git status --porcelain", "ls docs/wf/compte-rendu/", "mkdir -p docs/wf/compte-rendu"];

const suites = [
  {
    file: "compte-rendu-ca01-point-hebdo/graders/ca10-aucun-autre-fichier-lu.md",
    input: read,
    positive: ["/home/cwd/brief-fieldops.md", "notes-appel.md", "/home/cwd/notes/2026-09-30-atelier.vtt", "/home/cwd/package.json"],
    negative: [
      "/home/cwd/notes/2026-10-07-point-hebdo.md",
      "notes/2026-10-07-point-hebdo.md",
      "/home/cwd/docs/wf/compte-rendu/index.md",
      "docs/wf/compte-rendu/2026-10-07-point-hebdo-fieldops.md",
    ],
  },
  {
    file: "compte-rendu-ca01-point-hebdo/graders/ca10-aucun-autre-fichier-lu-par-bash.md",
    input: bash,
    positive: ["cat brief-fieldops.md", "head -n 20 notes-appel.md", "grep -n Sophie notes/2026-09-30-atelier.vtt"],
    negative: [...fixed, ...fill("notes/2026-10-07-point-hebdo.md"), ...fill("Point hebdo FieldOps")],
  },
  {
    file: "compte-rendu-ca01-point-hebdo/graders/ca01-aucun-autre-fichier-cree.md",
    input: text,
    positive: ["docs/wf/compte-rendu/index.md\nnotes/2026-10-07-point-hebdo.md", "docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md", "tmp-notes.md"],
    negative: ["docs/wf/compte-rendu/index.md\ndocs/wf/compte-rendu/2026-10-07-point-hebdo-fieldops.md"],
  },
  {
    file: "compte-rendu-ca01-point-hebdo/graders/ca07-tableau-actions.md",
    input: text,
    positive: ["## Actions\n\n| Action | Responsable | Échéance |\n|---|---|---|\n| Brancher | Julien | 14/10 |\n"],
    negative: [
      "## Actions\n\n| Action | Échéance | Responsable |\n|---|---|---|\n| Brancher | 14/10 | Julien |\n",
      "## Actions\n\n- Julien : brancher\n",
    ],
  },
  {
    file: "compte-rendu-ca01-point-hebdo/graders/ca19-hors-git.md",
    input: text,
    positive: ["# Compte rendu : X\n\n- Commit analysé : hors git\n\n## Objet\n"],
    negative: ["# Compte rendu : X\n\n- Commit analysé : non déterminé\n\n## Objet\n\nRéunion hors git.\n"],
  },
  {
    file: "compte-rendu-ca01-point-hebdo/graders/ca11-aucun-telephone.md",
    input: text,
    positive: ["Sophie, 06 00 00 00 00", "tél. 0600000000", "+33 6 00 00 00 00"],
    negative: ["Échéance : 14/10", "Date : 2026-10-07", "Commit : 2fc99c0"],
  },
  {
    file: "compte-rendu-ca02-sans-argument/graders/ca02-aucune-note-de-la-fixture-lue-par-bash.md",
    input: bash,
    positive: ["ls notes", "ls notes/", "find . -name '*.md'| grep notes", "cat notes-appel.md"],
    negative: fixed,
  },
  {
    file: "compte-rendu-ca18-chemin-inexistant/graders/ca18-aucune-autre-note-lue-par-bash.md",
    input: bash,
    positive: ["cat notes/2026-10-07-point-hebdo.md", "head brief-fieldops.md"],
    negative: [...fixed, ...fill("notes/2026-10-21-point-hebdo.md")],
  },
  {
    file: "compte-rendu-ca03-ca04-index-existant/graders/ca01-comptes-rendus-existants-non-edites.md",
    input: (p) => JSON.stringify({ file_path: p, old_string: "a", new_string: "b" }),
    positive: ["/home/cwd/docs/wf/compte-rendu/2026-10-14-revue-de-sprint.md", "/home/reunions/notes-reunion.md"],
    negative: ["/home/cwd/docs/wf/compte-rendu/index.md", "/home/cwd/docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md"],
  },
  {
    file: "compte-rendu-ca03-ca04-index-existant/graders/ca10-aucun-code-lu.md",
    input: read,
    positive: ["/home/cwd/src/api/server.ts", "/home/cwd/README.md", "/home/cwd/mobile/pubspec.yaml"],
    negative: ["/home/reunions/notes-reunion.md", "../reunions/notes-reunion.md", "/home/cwd/docs/wf/compte-rendu/index.md"],
  },
  {
    file: "compte-rendu-ca03-ca04-index-existant/graders/ca04-index-ordre.md",
    input: text,
    positive: [
      "| 2026-10-14 | R | [a](2026-10-14-revue-de-sprint.md) |\n| 2026-10-07 | P | [b](2026-10-07-point-hebdomadaire.md) |\n| 2026-09-30 | A | [c](./2026-09-30-atelier-parcours-technicien.md) |",
    ],
    negative: [
      "| 2026-10-14 | R | [a](2026-10-14-revue-de-sprint.md) |\n| 2026-09-30 | A | [c](2026-09-30-atelier-parcours-technicien.md) |\n| 2026-10-07 | P | [b](2026-10-07-point-hebdomadaire.md) |",
    ],
  },
  {
    file: "compte-rendu-ca16-relance/graders/ca16-index-une-seule-ligne.md",
    input: text,
    positive: [
      "| 2026-10-07 | P | [x](2026-10-07-point-hebdo-fieldops.md) |\n| 2026-10-07 | P | [x](2026-10-07-point-hebdo-fieldops.md) |",
    ],
    negative: ["| 2026-10-07 | P | [2026-10-07-point-hebdo-fieldops.md](2026-10-07-point-hebdo-fieldops.md) |\n"],
  },
  {
    file: "compte-rendu-ca17-nouvelle-reunion/graders/ca17-premier-non-ecrit.md",
    input: write,
    positive: ["/home/cwd/docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md"],
    negative: ["/home/cwd/docs/wf/compte-rendu/2026-10-07-point-hebdomadaire-2.md", "/home/cwd/docs/wf/compte-rendu/index.md"],
  },
  {
    file: "compte-rendu-ca13-transcription-vtt/graders/ca13-aucun-horodatage.md",
    input: text,
    positive: ["[00:12:34] Camille", "00:00:04.000 --> 00:00:11.500", "<v Inès Garnier>Bonjour"],
    negative: ["Réunion du 2026-09-30, de 10h à 11h.", "Échéance : 14/10"],
  },
];

for (const suite of suites) {
  const g = grader(suite.file);
  let re;
  try {
    re = compile(g);
  } catch (error) {
    fail(`${suite.file} : motif invalide (${error.message})`);
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
    fail(suite.file);
    for (const e of errors) console.log(`         ${e}`);
  } else {
    console.log(`OK     ${suite.file} (${suite.positive.length} positifs, ${suite.negative.length} négatifs)`);
  }
}

// La commande python3 prescrite calcule le nom attendu par les evals
const slugBlock = blocks.find((b) => b.includes("WF_OBJET"));
const slugCommand = slugBlock ? /^python3 -c '([^']*)'/m.exec(slugBlock)?.[1] : undefined;
if (!slugCommand) {
  fail("commande python3 du nom de fichier introuvable dans SKILL.md");
} else {
  const cases = [
    ["Point hebdo FieldOps", "point-hebdo-fieldops"],
    ["Point hebdomadaire", "point-hebdomadaire"],
    ["Revue de sprint 3", "revue-de-sprint-3"],
    ["Weekly sync", "weekly-sync"],
    ["Cœur – Écrans d'été, lot 2 et suite", "coeur-ecrans-d-ete-lot"],
    ['Objet "piégé" $(touch x) `id`', "objet-piege-touch-x-id"],
  ];
  for (const [input, expected] of cases) {
    const out = execFileSync("python3", ["-c", slugCommand], { input: input + "\n", encoding: "utf8" }).trim();
    if (out === expected) console.log(`OK     nom de fichier : « ${input} » → ${out}`);
    else fail(`nom de fichier : « ${input} » → ${out} (attendu ${expected})`);
  }
}

process.exit(failures === 0 ? 0 : 1);
